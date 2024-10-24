%% EEG Pre-Processing Script
clear all;
close all;
clc;
%% EEG Markers for this Experiment
%% Prepare Participant Characteristics
fileNames = dir('*.vhdr'); %Load in all the header files, which is what we use to load EEG data.
%Index the participant in your folder, useful if you don't have all the participant files in the folder when analyzing.
load("reref32_locs.mat")

for participant = 14 % input participant number

    split = strsplit(fileNames(participant).name(1:end-5),'_'); %Split the name into components so we can find the number

    %% Prepare Data and Run ICA
    [EEG] = doLoadBVData(fileNames(participant).folder,fileNames(participant).name); %Load in the header file for this participant

    % doRawDataInspection(EEG);
    filterSettings.low = 0.5;
    filterSettings.high = 20;
    filterSettings.order = 1;
    filterSettings.srate = EEG.srate;
    filterSettings.notch = 60;

    [EEG] = doFiltering(EEG,filterSettings); %Filter data

    [EEG] = doRereference(EEG,{'TP9','TP10'},'ALL');  %Rerefernce to mastoids

    [EEG] = pop_cleanline(EEG); % Clean line noise

    % Clean your dirty data!
    [EEG] = pop_clean_rawdata(EEG,'Bandwidth',2,'ChanCompIndices',[1:EEG.nbchan],...
        'SignalType','Channels','ComputeSpectralPower',true,'LineFrequencies',...
        [60 120], 'NormalizeSpectrum',false,'LineAlpha',0.01,'PaddingFactor',2,...
        'PlotFigures',false,'SidingWinStep',EEG.pnts/EEG.srate);


    [EEG] = doInterpolate(EEG,reref32_locs); %Interpolate bad removed earlier channels

    [EEG] = doICA(EEG); %Run ICA to remove eye blinks
    %% Post-ICA processing

    [EEG] = iclabel(EEG, 'default'); %Automatic Inverse ICA
    eyeLabel = find(strcmp(EEG.etc.ic_classification.ICLabel.classes,'Eye')); %Find the components classified as blinks
    eyeI = find(EEG.etc.ic_classification.ICLabel.classifications(:,eyeLabel)>0.8); %Index the components most likely to be blinks
    [EEG] = pop_subcomp(EEG,eyeI,0); %Remove/subtract the eyeblink components from the data

    postICADir = '/Users/mathewhammerstrom/Documents/Master_Lab/BlackjackSRE/Data/ProcessedEEG';
    save(fullfile(postICADir,['EEG_Pilot_' num2str(participant)]),'EEG');


    allMarkers = {'S101','S102', 'S103','S104'...
        'S201','S202','S203','S204'...
        'S 50', 'S 51', 'S 60','S 61'...
        'S 71', 'S 72', 'S 73', 'S 74'...
        'S 81', 'S 82', 'S 83', 'S 84'...
        'S 91', 'S 92', 'S 93', 'S 94', ...
        'S 11', 'S 12', 'S 13', 'S 14'};

    cueMarkers = {'S101','S102', 'S103','S104'...
        'S201','S202','S203','S204'};

    decisionMarkers = {'S 50', 'S 51', 'S 60','S 61'};

    rewardMarkers = {'S 71', 'S 72', 'S 73', 'S 74'...
        'S 81', 'S 82', 'S 83', 'S 84'...
        'S 91', 'S 92', 'S 93', 'S 94', ...
        'S 11', 'S 12', 'S 13', 'S 14'};
    %Markers for data (See marker guide at top of script)
    [sEEG] = doSegmentData(EEG,cueMarkers,[-200, 1000]);

    [EEG] = doSegmentData(EEG,allMarkers,[-200 800]); %Segment your data

    [EEG] = doBaseline(EEG,[-200,0]);%Baseline correction
    [sEEG] = doBaseline(sEEG,[-200,0]);%Baseline correction

    % %Do artifact rejection with both methods, Remove Bad Trials
    [EEG] = doArtifactRejection(EEG,'Gradient',10);
    [EEG] = doArtifactRejection(EEG,'Difference',100);
    removalMatrix = EEG.artifact(1).badSegments + EEG.artifact(2).badSegments;
    [EEG] = doRemoveEpochs(EEG,removalMatrix,0);

    [sEEG] = doArtifactRejection(sEEG,'Gradient',10);
    [sEEG] = doArtifactRejection(sEEG,'Difference',100);
    removalMatrix = sEEG.artifact(1).badSegments + sEEG.artifact(2).badSegments;
    [sEEG] = doRemoveEpochs(sEEG,removalMatrix,0);

    %% ERP Processing
    [sERP] = doERP(sEEG,cueMarkers,0); %Make ERPs
    [dERP] = doERP(EEG,decisionMarkers,0);
    [rERP] = doERP(EEG,rewardMarkers,0); %Make ERPs

    exportFolder = '/Users/mathewhammerstrom/Documents/Master_Lab/BlackjackSRE/Data/ERP';
    save(fullfile(exportFolder,['rERP_' num2str(participant)]),'rERP');
    save(fullfile(exportFolder,['dERP_' num2str(participant)]),'dERP');
    save(fullfile(exportFolder,['sERP_' num2str(participant)]),'sERP');
end

