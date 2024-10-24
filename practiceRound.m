function practiceRound(win,xmid,ymid,cards,cardDir,cardImageRect,practiceRounds,colourCodes, conditionGrid, earnerImage, earnerImageRect, playerImage, squarePosition, playerImageRect, SRE,useDataPixx)

for hands = 1:practiceRounds

    credit = 1000;
    if credit <= 50
        credit = 1000;
        Screen('TextFont',win,'Arial');
        Screen('TextSize',win,30);
        DrawFormattedText(win,'Bankrupt! We will reset your pot but add one error to your record.','center',ymid,[255 255 255]);
        DrawFormattedText(win,sprintf('You now have: $ %d\n',credit),'center',ymid+360,[255 255 255]);
        Screen('Flip',win);
        WaitSecs(3)
    end
    %% Betting Phase
    deck = cards; % Reset each hand from the deck of cards
    result = 0;

    bPhase = 0;
    bet = 50;
    while bPhase
        [credit,bet, bPhase] = betScreen(win, ymid, xmid, credit, useDataPixx, bPhase);
    end
    %
    % WaitSecs(2);
    currentTrialType = randi(4);
    %% Dealing Phase

    if SRE
        % Show Perceptual Grating
        fixationInterval = rand()*.4 + .3;
        showgrating(win,200,fixationInterval,2,1);


        % Show earning cue
        currentEarner = conditionGrid(currentTrialType,1);

        Screen('FrameRect', win, colourCodes(currentEarner,:),squarePosition,10);
        Screen('DrawTexture', win, earnerImage, [], earnerImageRect);
        Screen('Flip',win);
        WaitSecs(1.5);

        % Show Perceptual Grating
        fixationInterval = rand()*.4 + .3;
        showgrating(win,200,fixationInterval,3,1);

        % Show playing cue
        currentPlayer = conditionGrid(currentTrialType,2);
        Screen('FrameRect', win, colourCodes(currentPlayer,:),squarePosition,10);
        Screen('DrawTexture', win, playerImage, [], playerImageRect);
        Screen('Flip',win);
        WaitSecs(1.5);

    else


        Screen(win,'TextSize',35);
        DrawFormattedText(win,'+','center','center',[255 255 255]);
        Screen('Flip',win);
        fixation_interval = rand()*.2 + .3;
        WaitSecs(fixation_interval);
    end

    [deck,mHand,mBase,mScore,dHand,dBase,dScore,cardTextures,dstRects,~] = dealCards(deck,cardDir,win,cardImageRect,xmid,ymid,useDataPixx); % Deal cards to player and dealer
        mHits = 0; %Initialize hit counter
        mBust = 0;
        respondedEarly = 0;
        invalidResponse = 0;

    if currentTrialType == 1 || currentTrialType == 3 || ~SRE % If the participant is playing:
        startTime = GetSecs();
        respTime = 0;

        tstart = tic;
        while toc(tstart) < 1
            if ischar(getresponse(useDataPixx))
                respondedEarly = 1;
            end
        end

        tstart = tic;
        while toc(tstart) < 1
            if ischar(getresponse(useDataPixx))
                respondedEarly = 1;
            end
        end

        mHits = 0; %Initialize hit counter
        mBust = 0;
        if ~respondedEarly

            Screen('DrawTextures', win, cardTextures, [], dstRects);
            Screen(win,'TextSize',35);
            DrawFormattedText(win,'+','center','center',[0 0 0]);
            Screen(win,'TextSize',25);
            DrawFormattedText(win,'Press the red button to HIT.',xmid+500,ymid+500,[255 255 255]);
            DrawFormattedText(win,'Press the green button to STAY.',xmid-800,ymid+500,[255 255 255]);
            Screen('Flip',win);

            while respTime <10
                [res] = getresponse(useDataPixx);

                if res == 'r' % If they hit,
                    mHits = mHits+1;  % Add one to hit counter
                    [deck,mHand,mBase,mScore,dstRects,cardTextures,mBust] = hitCard(deck,mHits,mHand,mBase,win,cardImageRect,xmid,ymid,dstRects,cardTextures,cardDir,1,currentTrialType,useDataPixx); % Give player additional card
                    invalidResponse = 0;
                    mDisplay = join([mHand{:}]); % Make label for new hand
                elseif res == 'g' % If they Stay, continue
                    invalidResponse = 0;
                    break
                elseif res == 'b' || res =='w' || res == 'y'
                    invalidResponse = 1;
                end
                respTime = GetSecs()-startTime;

            end
            if respTime >=10 
                invalidResponse = 1;
            end
        elseif respondedEarly
            Screen('Flip',win);
        elseif invalidResponse
            Screen('Flip',win);
        end
        % Now Dealer will hit
        dHits = 0;
    else

        WaitSecs(1)

        Screen('DrawTextures', win, cardTextures, [], dstRects);
        Screen(win,'TextSize',35);
        DrawFormattedText(win,'+','center','center',[0 0 0]);
        Screen('Flip',win);

        respTime = rand()*.4 + .5; %Create an artificial delay in response time
        WaitSecs(respTime);


        while mScore <= 16 % Other hits on anything under 16; this hit logic is the same as when the participant plays

            %                 if mHits >= 1 %Add another deicison delay for every subsequent hit
            %                     respTime = rand()*.4 + .5; %Create an artificial delay in response time
            %                     WaitSecs(respTime);
            %                 end
            mHits = mHits+1;  % Add one to hit counter
            [deck,mHand,mBase,mScore,dstRects,cardTextures,mBust] = hitCard(deck,mHits,mHand,mBase,win,cardImageRect,xmid,ymid,dstRects,cardTextures,cardDir,1,currentTrialType,useDataPixx); % Give player additional card

            if mBust || mScore == 21 % If they bust or blackjack, play stops
                WaitSecs(1)
                break;
            end

            %Wait to make another decision
            respTime = rand()*.4 + .7; %Create an artificial delay in response time
            WaitSecs(respTime);
        end
    end
    dHits =0;
%     if ~respondedEarly && ~invalidResponse && dScore <= 16 && ~mBust %Dealer hits on anything under 16
%         dHits = dHits +1;
%         [~,~,~,dScore,~,~,~] = hitCard(deck,dHits,dHand,dBase,win,cardImageRect,xmid,ymid,dstRects,cardTextures,cardDir,0,useDataPixx); % Give dealer an additional card
%         WaitSecs(1);
%     end
    Screen(win,'TextSize',35);

    DrawFormattedText(win,'+','center','center',[255 255 255]);
    Screen('Flip',win);
    fixation_interval = rand()*.2 + .5;
    WaitSecs(fixation_interval);

    %% Feedback Phase
    chance = rand();
    tie = 0;

    % Now that dealing is done, lets see who won.
    if respondedEarly

        Screen('TextFont',win,'Arial');
        Screen('TextSize',win,30);
        DrawFormattedText(win,'Too Early!','center','center',[255 255 255]);
        Screen('Flip',win);
    elseif invalidResponse

        Screen('TextFont',win,'Arial');
        Screen('TextSize',win,30);
        DrawFormattedText(win,'Invalid Response!','center','center',[255 255 255]);
        Screen('Flip',win);

    elseif ~mBust && chance > 0.5 || mScore == 21 || dScore>21 % If player score is higher than dealer score and they didnt bust,
        credit = credit + bet; % Add bet to credit pool

        Screen('TextFont',win,'Arial');
        Screen('TextSize',win,50);
        DrawFormattedText(win,'WIN','center','center',[255 255 255]);
        Screen('Flip',win);

    elseif  ~mBust && chance < 0.5 % If they have less points 
        credit = credit - bet; % Remove bet from credit pool

        Screen('TextFont',win,'Arial');
        Screen('TextSize',win,50);
        DrawFormattedText(win,'LOSS','center','center',[255 255 255]);
        Screen('Flip',win);

    elseif mBust
        Screen('TextFont',win,'Arial');
        Screen('TextSize',win,50);
        DrawFormattedText(win,'BUST','center','center',[255 255 255]);
        Screen('Flip',win);

    end
    WaitSecs(2);
end