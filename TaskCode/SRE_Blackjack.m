%% The BlackJack Game
clear all;
close all;
clc;
rng('shuffle'); % Shuffle random generator

%% DataPixx setup
% Set up the DataPixx2 for using bluebox/response controller. Otherwise,
% keyboard is used.
useDataPixx = 1;
if useDataPixx
    
    Datapixx('Open');
    Datapixx('StopAllSchedules');

    % We'll make sure that all the TTL digital outputs are low before we start
    Datapixx('SetDoutValues', 0);
    Datapixx('RegWrRd');

    % Configure digital input system for monitoring button box
    Datapixx('EnableDinDebounce');                          % Debounce button presses
    Datapixx('SetDinLog');                                  % Log button presses to default address
    Datapixx('StartDinLog');                                % Turn on logging
    Datapixx('RegWrRd');
end

%% Set-up
pCredit = 1000; % Start with $500 to play with
oCredit = 900+randi([1,200]); 

cardDir = 'C:\Users\Krigolson Admin\Documents\Blackjack\Card_Images';
cards = readtable('cardValues.xlsx'); % Read in a table with a deck of cards

cards.Properties.VariableNames = {'CardNumber', 'PointValue', 'Label','Suit'};
% Card Number lets us pick from the deck,
% Point value lets us score each card,
% Label helps tell the player what card they have
% Suit helps us draw cards on the screen.
for cardCounter = 1:height(cards)
    cards(cardCounter,5) = {strjoin([cards.Label(cardCounter) '_' cards.Suit(cardCounter) '.png'],'')};
end

% Read in Card image textures
im = imread(fullfile(cardDir,"Ace_Clubs.png")); % Use imread to get images from card folder
[imHeight, imWidth,~] = size(im); % Get image dimensions
cardaspectRatio = imWidth/imHeight; % Get aspect ratio to ensure proper scaling

% Read in image textures
[playerImage, ~, alpha] = imread('cardImage.png');
[imHeight, imWidth, ~] = size(playerImage); % Get image dimensions
playeraspectRatio = imWidth/imHeight; % Get aspect ratio to ensure proper scaling
playerImage(:,:,4) = alpha;

% Read in image textures
[earnerImage, ~, alpha] = imread('earnerImage.png');
[imHeight, imWidth, ~] = size(earnerImage); % Get image dimensions
earneraspectRatio = imWidth/imHeight; % Get aspect ratio to ensure proper scaling
earnerImage(:,:,4) = alpha;

% Set Participant info
pNumber = 7;
fileName = sprintf('Blackjack_Pilot_beh_%d',pNumber);

% Set number of hands and blocks
numHands = 20;
numTables = 20;
bet = 50;

% Organize trial conditions
trialType = Shuffle(repmat(1:4,[1,numHands*numTables/4])); % Shuffle four trial types with 100 trials each, for a total of 400
conditionGrid = [1 1; 1 2; 2 1; 2 2]; % Indicate what each trial type (row) means for who is earning (column 1) and who is playing (column 2)

colours = [230 159 0; 86 180 233]; %First colour pair
colours(:,:,2) = [213 94 0; 0 114 178];
colours(:,:,3) = [240 228 66; 0 158 115];
colours(:,:,4) = [0 0 0; 201 121 167];
colourNames = [{'Yellow'},{'Blue'};...
    {'Orange'},{'Blue'};
    {'Yellow'},{'Blue'};...
    {'Black'},{'Pink'}];

currentColourPair = randi([1,4]);
currentColourOrder = randi([1,2]);

if currentColourOrder == 1
    colourCodes = [colours(1,:,currentColourPair); colours(2,:,currentColourPair)];
    currentColourNames = [colourNames(currentColourPair,1); colourNames(currentColourPair,2)];
else
    colourCodes = [colours(2,:,currentColourPair); colours(1,:,currentColourPair)];
    currentColourNames = [colourNames(currentColourPair,2); colourNames(currentColourPair,1)];
end


%Organize trial type cue order
typeCueOrder = Shuffle(repmat(1:2,[1,numHands*numTables/8]));% Shuffle 2 presentation orders (Earner-Player, Player-Earner) with 50 trials each, for a total of 100 per type
typeCueOrder(2,:) = Shuffle(typeCueOrder(1,:)); %Repeat shuffle for each trial type
typeCueOrder(3,:) = Shuffle(typeCueOrder(1,:));
typeCueOrder(4,:) = Shuffle(typeCueOrder(1,:));

% Organize conditional markers
trialTypeMarkers = [101, 102, 103, 104;...  % Store markers for presentation of who is earning
    201, 202, 203, 204]; % Store markers for presentation of who is playing

feedbackMarkers = [71, 72, 73, 74;...  % Store markers for wins
    81, 82, 83, 84;...% Store markers for losses
    91, 92, 93, 94;...% Store markers for busts
    11,12,13,14]; 


%% Screen Setup
% These are basic functions for setting up a psychtoolbox screen.
% For testing, I recommend using 50 50 800 500 as screen dimensions.
% Leave empty for full screen.

% Set up a PTB window
Screen('Preference', 'SkipSyncTests', 1);
[win, rec] = Screen('OpenWindow', 0, [0 0 0], [], 32, 2);
[screenXpixels, screenYpixels] = Screen('WindowSize', win);
xmid = rec(3)/2; ymid = rec(4)/2;
% Activate for alpha blending, allows us to remove backgrounds from card
% images
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Retrieves color codes for black and white and gray. Needs to be uniform
% for gratings to work.
black = BlackIndex(win);  % Retrieves the CLUT color code for black.
white = WhiteIndex(win);  % Retrieves the CLUT color code for white.
gray = (black + white) / 2;  % Computes the CLUT color code for gray.
if round(gray)==white
    gray=black;
end

% Make Background Grey
Screen('FillRect', win, gray);


% Setup some dimensions to draw our new images
scalingFactor = 0.2; % Determine how much to scale the image by
imageHeight = screenYpixels .* scalingFactor; % Determine new image height based on scaling factor
imageWidth = imageHeight .* cardaspectRatio; % Maintain aspect ratio when determining width
cardImageRect = [0 0 imageWidth imageHeight];

scalingFactor = 0.2; % Determine how much to scale the image by
imageHeight = screenYpixels .* scalingFactor; % Determine new image height based on scaling factor
imageWidth = imageHeight .* playeraspectRatio; % Maintain aspect ratio when determining width
playerImageRect = [0 0 imageWidth imageHeight];
playerImageRect = CenterRectOnPointd(playerImageRect, xmid, ymid);
playerImage = Screen('MakeTexture',win,playerImage);

scalingFactor = 0.15; % Determine how much to scale the image by
imageHeight = screenYpixels .* scalingFactor; % Determine new image height based on scaling factor
imageWidth = imageHeight .* earneraspectRatio; % Maintain aspect ratio when determining width
earnerImageRect = [0 0 imageWidth imageHeight];
earnerImageRect = CenterRectOnPointd(earnerImageRect, xmid, ymid);
earnerImage = Screen('MakeTexture',win,earnerImage);

squareSize = [0,0,200,200];
squarePosition = CenterRect(squareSize,rec);

%% Instructions and Practice

doBlackJackInstruction(win, ymid, xmid, cards,numHands, numTables,cardDir,cardImageRect, useDataPixx)

practice = 1;
if practice == 1

    practiceRounds = 10;
    practiceRound(win,xmid,ymid,cards,cardDir,cardImageRect,practiceRounds,colourCodes, conditionGrid, earnerImage, earnerImageRect, playerImage, squarePosition, playerImageRect, 0,useDataPixx)

end

doSREBlackJackInstruction(win, ymid, xmid,playerImage, playerImageRect, earnerImage,earnerImageRect,squarePosition, colourCodes,currentColourNames,useDataPixx);

practice = 1;
if practice == 1

    practiceRounds = 10;
    practiceRound(win,xmid,ymid,cards,cardDir,cardImageRect,practiceRounds,colourCodes, conditionGrid, earnerImage, earnerImageRect, playerImage, squarePosition, playerImageRect, 1,useDataPixx)
end


Screen('TextFont',win,'Arial');
Screen('TextSize',win,30);
DrawFormattedText(win,'Do you understand how to play?','center',ymid-120,[255 255 255]);
DrawFormattedText(win,'You may ask the researcher any questions about the task you may have.','center',ymid-60,[255 255 255]);
DrawFormattedText(win,'Otherwise, if you are ready, press the green/red button to begin.','center',ymid,[255 255 255]);
Screen('Flip',win);



while 1
    [res] = getresponse(useDataPixx);
    if res == 'g'
        break
    end
    if res == 'r'
        break
    end
end
WaitSecs(1);

Screen('TextFont',win,'Arial');
Screen('TextSize',win,30);
DrawFormattedText(win,'The deck will be shuffled for every hand. You will play at several tables with many hands at each table.', 'center',ymid-60,[255 255 255]);
DrawFormattedText(win,sprintf('Number of hands per table: %d\n',numHands),'center',ymid,[255 255 255]);
DrawFormattedText(win,sprintf('Number of tables: %d\n',numTables),'center',ymid+30,[255 255 255]);
Screen('TextFont',win,'Arial');
Screen('TextSize',win,20);
DrawFormattedText(win,'Press the green/red button to continue','center',ymid+120,[255 255 255]);
Screen('Flip',win);

while 1
    [res] = getresponse(useDataPixx);
    if res == 'g'
        break
    end
    if res == 'r'
        break
    end
end
WaitSecs(0.5);
%% Game Start
totalTrial = 0;
totalTypeTrial = [0,0,0,0];
behTrial = NaN(numTables*numHands,22);
behTrial = num2cell(behTrial);


for tables = 1:numTables

    
    blockString = sprintf('Block %d',tables);
    Screen('TextFont',win,'Arial');
    Screen('TextSize',win,30);
    DrawFormattedText(win,blockString,'center',ymid,[255 255 255]);
    DrawFormattedText(win,'Press the green/red button to continue.','center',ymid+60,[255 255 255]);
    Screen('Flip',win);
    while 1
        [res] = getresponse(useDataPixx);
        if res == 'g'
            break
        end
        if res == 'r'
            break
        end
    end
    WaitSecs(1);

    bCredit = pCredit; %Store credit that they start the block with
    for hands = 1:numHands
        totalTrial = totalTrial+1;

        currentTrialType = trialType(totalTrial); %Add one to total trial counter, helps keep track of trial types over task
        totalTypeTrial(1,currentTrialType) = totalTypeTrial(1,currentTrialType)+1;%Add one to condition-specific order counter

        
        %% Condition Phase
        deck = cards; % Reset each hand from the deck of cards
        result = 0;

        % Show Perceptual Grating
        fixationInterval = rand()*.4 + .3;
        showgrating(win,200,fixationInterval,2,1);

        if typeCueOrder(currentTrialType,totalTypeTrial(1,currentTrialType)) == 1
            % Show earning cue
            currentEarner = conditionGrid(currentTrialType,1);

            Screen('FrameRect', win, colourCodes(currentEarner,:),squarePosition,10);
            Screen('DrawTexture', win, earnerImage, [], earnerImageRect);
            flipandmark(win,trialTypeMarkers(1,currentTrialType),useDataPixx)
            WaitSecs(1.5);

            % Show Perceptual Grating
            fixationInterval = rand()*.4 + .3;
            showgrating(win,200,fixationInterval,3,1);

            % Show playing cue
            currentPlayer = conditionGrid(currentTrialType,2);
            Screen('FrameRect', win, colourCodes(currentPlayer,:),squarePosition,10);
            Screen('DrawTexture', win, playerImage, [], playerImageRect);
            flipandmark(win,trialTypeMarkers(2,currentTrialType),useDataPixx)
            WaitSecs(1.5);
        else


            % Show playing cue
            currentPlayer = conditionGrid(currentTrialType,2);
            Screen('FrameRect', win, colourCodes(currentPlayer,:),squarePosition,10);
            Screen('DrawTexture', win, playerImage, [], playerImageRect);
            flipandmark(win,trialTypeMarkers(2,currentTrialType),useDataPixx)
            WaitSecs(1.5);

            % Show Perceptual Grating
            fixationInterval = rand()*.4 + .3;
            showgrating(win,200,fixationInterval,3,1);

            % Show earning cue
            currentEarner = conditionGrid(currentTrialType,1);
            Screen('FrameRect', win, colourCodes(currentEarner,:),squarePosition,10);
            Screen('DrawTexture', win, earnerImage, [], earnerImageRect);
            flipandmark(win,trialTypeMarkers(1,currentTrialType),useDataPixx)
            WaitSecs(1.5);
        end


        %% Dealing Phase

        Screen(win,'TextSize',35);
        DrawFormattedText(win,'+','center','center',[255 255 255]);
        flipandmark(win,4,useDataPixx);
        fixationInterval = rand()*.4 + .3;
        WaitSecs(fixationInterval);

        [deck,mHand,mBase,mScore,dHand,dBase,dScore,cardTextures,dstRects,hiddenText] = dealCards(deck,cardDir,win,cardImageRect,xmid,ymid,useDataPixx); % Deal cards to player and dealer


        mDisplay = join([mHand{:}]); % Make label for new hand
        dDisplay = join([dHand{:}]);
        % Player can hit or stay now


        mHits = 0; %Initialize hit counter
        mBust = 0;
        respondedEarly = 0;
        invalidResponse = 0;
        respondedLate = 0;

        if currentTrialType == 1 || currentTrialType == 3 % If the participant is playing:
        res = 0;
        startTime = GetSecs();
        respTime = 0;
        dispTime = 0;

        tstart = tic;
        while toc(tstart) < 1
            if ischar(getresponse(useDataPixx))
                respondedEarly = 1;
            end
        end

       
        if ~respondedEarly
                invalidResponse = 1;

            Screen('DrawTextures', win, cardTextures, [], dstRects);
            Screen(win,'TextSize',35);
            DrawFormattedText(win,'+','center','center',[0 0 0]);
            Screen(win,'TextSize',25);
            DrawFormattedText(win,'Press the red button to HIT.',xmid+500,ymid+500,[255 255 255]);
            DrawFormattedText(win,'Press the green button to STAY.',xmid-800,ymid+500,[255 255 255]);
            flipandmark(win,51,useDataPixx);

            while respTime <5
                [res] = getresponse(useDataPixx);
                if res == 'r' % If they hit,
                    mHits = mHits+1;  % Add one to hit counter
                    [deck,mHand,mBase,mScore,dstRects,cardTextures,mBust] = hitCard(deck,mHits,mHand,mBase,win,cardImageRect,xmid,ymid,dstRects,cardTextures,cardDir,1,currentTrialType,useDataPixx); % Give player additional card
                    invalidResponse = 0;
                    mDisplay = join([mHand{:}]); % Make label for new hand
                    if mHits ==1
                        respTime = GetSecs()-startTime;
                    end

                    if mBust || mScore == 21 % If they bust or blackjack, play stops
                        WaitSecs(1)
                        break;
                     end

                elseif res == 'g' % If they Stay, continue
                    invalidResponse = 0;
                    sendmarker(61,useDataPixx);
                    dispTime = GetSecs()-startTime;

                    break
                elseif res == 'b' || res =='w' || res == 'y'
                    invalidResponse = 1;
                end

            end
            if respTime >= 5
                respondedLate = 1;
                sendmarker(7,useDataPixx);
            end
        elseif respondedEarly
            flipandmark(win,6,useDataPixx)
        elseif invalidResponse
            flipandmark(win,7,useDataPixx)
        end
        
        else % If the "other" is playing.
            dispTime = 0;

            WaitSecs(1)

            Screen('DrawTextures', win, cardTextures, [], dstRects);
            Screen(win,'TextSize',35);
            DrawFormattedText(win,'+','center','center',[0 0 0]);
            flipandmark(win,51,useDataPixx);

            respTime = rand()*.4 + .5; %Create an artificial delay in response time
            WaitSecs(respTime);


            while mScore <= 16 % Other hits on anything under 16; this hit logic is the same as when the participant plays

%                 if mHits >= 1 %Add another deicison delay for every subsequent hit
%                     respTime = rand()*.4 + .5; %Create an artificial delay in response time
%                     WaitSecs(respTime);
%                 end
                mHits = mHits+1;  % Add one to hit counter
                [deck,mHand,mBase,mScore,dstRects,cardTextures,mBust] = hitCard(deck,mHits,mHand,mBase,win,cardImageRect,xmid,ymid,dstRects,cardTextures,cardDir,1,currentTrialType,useDataPixx); % Give player additional card

                mDisplay = join([mHand{:}]); % Make label for new hand

                if mBust || mScore == 21 % If they bust or blackjack, play stops
                    WaitSecs(1)
                    break;
                end
                
                %Wait to make another decision
                respTime = rand()*.4 + .5; %Create an artificial delay in response time
                WaitSecs(respTime);

            end


        end

    
        % Now Dealer will hit
        dHits = 0;
        dBust = 0;

        

%         if ~respondedEarly && ~invalidResponse && dScore <= 16 && ~mBust && mScore ~= 21 %Dealer hits on anything under 16
%             dHits = dHits +1;
%             [deck,dHand,dBase,dScore,dstRects,cardTextures,dBust] = hitCard(deck,dHits,dHand,dBase,win,cardImageRect,xmid,ymid,dstRects,cardTextures,cardDir,0,currentTrialType, useDataPixx); % Give dealer an additional card
%             WaitSecs(1);
%         end

        Screen(win,'TextSize',35);
        DrawFormattedText(win,'+','center','center',[255 255 255]);
        flipandmark(win,4,useDataPixx);
        fixationInterval = rand()*.4 + .3;
        WaitSecs(fixationInterval);

        %% Feedback Phase
        % Now that dealing is done, lets see who won.
        tie = 0;
        chance = rand();

        if respondedEarly

            Screen('TextFont',win,'Arial');
            Screen('TextSize',win,30);
            DrawFormattedText(win,'Too Early!','center',ymid,[255 255 255]);
            Screen('Flip',win);
        elseif invalidResponse

            Screen('TextFont',win,'Arial');
            Screen('TextSize',win,30);
            DrawFormattedText(win,'Invalid Response!','center',ymid,[255 255 255]);
            Screen('Flip',win);
        elseif respondedLate

            Screen('TextFont',win,'Arial');
            Screen('TextSize',win,30);
            DrawFormattedText(win,'Too Slow!','center',ymid,[255 255 255]);
            Screen('Flip',win);

        elseif  ~mBust && chance > 0.5 || mScore == 21 || dScore>21 % If player score is higher than dealer score and they didnt bust,
            
            if currentTrialType == 1 || currentTrialType == 2 % If the player is earning on the current trial,
                pCredit = pCredit + bet; % Add bet to credit pool
            else 
                oCredit = oCredit + bet;
            end

            Screen('TextFont',win,'Arial');
            Screen('TextSize',win,50);
            DrawFormattedText(win,'WIN','center',ymid,[255 255 255]);
            %             DrawFormattedText(win,sprintf('You now have: $ %d\n',credit),'center',ymid+360,[255 255 255]);
            flipandmark(win,feedbackMarkers(1,currentTrialType),useDataPixx);

            result = 1;
        elseif ~mBust && chance < 0.5 % If they have less points 
            
            if currentTrialType == 1 || currentTrialType == 2 % If the player is earning on the current trial,
                pCredit = pCredit - bet; % Add bet to credit pool
            else 
                oCredit = oCredit - bet;
            end

            Screen('TextFont',win,'Arial');
            Screen('TextSize',win,50);
            DrawFormattedText(win,'LOSS','center',ymid,[255 255 255]);
            %             DrawFormattedText(win,sprintf('You now have: $ %d\n',credit),'center',ymid+360,[255 255 255]);
            flipandmark(win,feedbackMarkers(2,currentTrialType),useDataPixx);

            result = 0;

        elseif mBust % If they have busted 
           
            if currentTrialType == 1 || currentTrialType == 2 % If the player is earning on the current trial,
                pCredit = pCredit - bet; % Add bet to credit pool
            else 
                oCredit = oCredit - bet;
            end

            Screen('TextFont',win,'Arial');
            Screen('TextSize',win,50);
            DrawFormattedText(win,'BUST','center',ymid,[255 255 255]);
            
            flipandmark(win,feedbackMarkers(3,currentTrialType),useDataPixx);

            result = 0;

        elseif mScore == dScore % If there is a tie (i.e. a Push)

            Screen('TextFont',win,'Arial');
            Screen('TextSize',win,50);
            DrawFormattedText(win,'TIE','center',ymid,[255 255 255]);

            flipandmark(win,feedbackMarkers(4,currentTrialType),useDataPixx);

            tie = 1;
            result = 0;
        end
        WaitSecs(1);
        bankrupt = 0;
        if pCredit <= 50
            pCredit = 500;
            bankrupt = bankrupt+1;
            Screen('TextFont',win,'Arial');
            Screen('TextSize',win,30);
            DrawFormattedText(win,'You went Bankrupt!','center',ymid-60,[255 255 255]);
            DrawFormattedText(win,'We will reset your pot but add one error to your record.','center',ymid,[255 255 255]);
            DrawFormattedText(win,sprintf('You now have: $ %d\n',pCredit),'center',ymid+360,[255 255 255]);
            Screen('Flip',win);
            WaitSecs(3)
        elseif oCredit <= 50
            oCredit = 500;
            bankrupt = bankrupt+1;
            Screen('TextFont',win,'Arial');
            Screen('TextSize',win,30);
            DrawFormattedText(win,'Other player went Bankrupt!','center',ymid-60,[255 255 255]);
                DrawFormattedText(win,'We will reset their pot but add one error to their record.','center',ymid,[255 255 255]);
            DrawFormattedText(win,sprintf('they now have: $ %d\n',oCredit),'center',ymid+360,[255 255 255]);
            Screen('Flip',win);
            WaitSecs(3)
        end
        behTrial(totalTrial,:) = [pNumber tables hands currentTrialType bet pCredit oCredit {mDisplay} {dDisplay} mHits dHits respTime dispTime invalidResponse respondedEarly respondedLate mScore dScore result mBust tie bankrupt]; %Records all behavioural data for this trial
    end
    blockEarnings = pCredit-bCredit;
    earningString = sprintf('In this block you earned: $%d',blockEarnings);
    pPotString = sprintf('You now have: $%d',pCredit);
    oPotString = sprintf('They now have: $%d',oCredit);
    Screen('TextFont',win,'Arial');
    Screen('TextSize',win,30);
    DrawFormattedText(win,earningString,'center',ymid-120,[255 255 255]);
    DrawFormattedText(win,pPotString,'center',ymid+60,[255 255 255]);
    DrawFormattedText(win,oPotString,'center',ymid+120,[255 255 255]);

    DrawFormattedText(win,'Press the green/red button to continue.','center',ymid+360,[255 255 255]);
    Screen('Flip',win);
    while 1
        [res] = getresponse(useDataPixx);
        if res == 'g'
            break
        end
        if res == 'r'
            break
        end
    end
    WaitSecs(1);

end
behData = cell2table(behTrial);
behData.Properties.VariableNames = [{'Participant'}, {'Tables'}, {'Hands'},{'Current Trial Type'}, {'Bet'}, {'Starting Player Credit'}, {'Starting Other Credit'},{'Player Cards'},{'Dealer Cards'},{'Player Hits'},{'Dealer Hits'},{'Response Time'},{'Display Time'},{'Invalid Trial'},{'Early Response'},{'Responded Late'},{'Player Score'},{'Dealer Score'},{'Win_Loss'},{'Bust'},{'Tie'},{'Bankrupt'}];
writetable(behData,fileName);
save(fileName,"behData");

x= table2array(behData(:,4));
selfTrials = [find(x==1) find(x==2)];
allWins = table2array(behData(:,19));
selfWins = sum(allWins(selfTrials(:,1)));
selfWins = selfWins+sum(allWins(selfTrials(:,2)));

moneyEarned = selfWins*0.15;

Screen('CloseAll')
Datapixx('Close');

disp(['The participant earned $' num2str(moneyEarned)]);