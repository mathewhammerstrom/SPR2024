%% The BlackJack Game
clear all;
close all;
clc;

%% Set-up
rng('shuffle'); % Shuffle random generator

credit = 1000; % Start with $1000 to play with

cards = readtable('cardValues.xlsx'); % Read in a table with a deck of cards
cards.Properties.VariableNames = {'CardNumber', 'PointValue', 'Label','Suit'}; 
% Card Number lets us pick from the deck, 
% Point value lets us score each card, 
% Label helps tell the player what card they have
% Suit helps us draw cards on the screen.

% Display welcome screen 
disp('Welcome to Blackjack') 
disp(['You have: $' num2str(credit) ' to play with.'])
WaitSecs(2);
pNumber = 1;

%% Screen Setup
% These are basic functions for setting up a psychtoolbox screen. 
% For testing, I recommend using 100 100 1000 800 as screen dimensions.
% Leave empty for full screen. 

% Set up a PTB window
Screen('Preference', 'SkipSyncTests', 1);
[win, rec] = Screen('OpenWindow', 0, [64 64 64], [100 100 1000 800], 32, 2);

%Set middle points, helps for centering text and photos. 
xmid = rec(3)/2; ymid = rec(4)/2;

for hands = 1:3
    %% Betting Phase
    deck = cards; % Reset each hand from the deck of cards

    bet = 50; % Assume a minimum bet of $50 
    disp('First Hand.')
    disp('-')
    disp('-')
    disp('-')
    disp('-')

    WaitSecs(1);
    while 1
        action = input("Raise(R), Lower(L), or Place(C) Bet: ",'s'); % Prompt player to take betting action
        if strcmp(action,'R') % If player wants to raise,
            bet = bet+50; % Add $50 to bet
            disp(['Current bet: $' num2str(bet)]) % Display current bet
        elseif strcmp(action,'L') % If they want to lower,
            bet = bet-50; % Remove $50 from bet
            if bet < 50 % If they have gone below the betting minimum, 
                disp('Below minimum bet!') % Tell player they can't go lower
                WaitSecs(2); 
                bet = 50; % Reset bet to $50
                disp(['Current bet: $' num2str(bet)]) % Display current bet
            else
                disp(['Current bet: $' num2str(bet)])
            end
        elseif strcmp(action,'C') % Place bet and continue
            break
        end
    end

    WaitSecs(2);
    disp('-')
    disp('-')
    disp('-')

    disp(['You have bet: $' num2str(bet)]) % Display bet they have made
    disp('Good Luck you degenerate scum!')
    disp('-')
    disp('-')
    disp('-')

    WaitSecs(2);
    disp('Dealing....')
    disp('-')
    disp('-')
    disp('-')
    WaitSecs(2);
    %% Dealing Phase
    [deck,mHand,mBase,mScore,dHand,dBase,dScore] = dealCards(deck); % Deal cards to player and dealer

    disp(['Your Current Cards are ' mHand{1} ' and ' mHand{2}]) % Display starting cards
    disp(['The Dealers Card is ' dHand{1}]) % Display the dealer's first card

    WaitSecs(2);
    mDisplay = join([mHand{:}]); % Make label for new hand

    % Player can hit or stay now
    
    mHits = 0; %Initialize hit counter 
    while 1
        action = input("Hit(H) or Stay(S): ",'s'); % Prompt player to hit or stay
        if strcmp(action,'H') % If they hit, 
           
            mHits = mHits+1;  % Add one to hit counter 
            [deck,mHand,mBase,mScore] = hitCard(deck,mHits,mHand,mBase); % Give player additional card
            
            mDisplay = join([mHand{:}]); % Make label for new hand

            if mScore > 21 % If they have now gone above 21, its a bust
                disp(string(join(['Your Current Cards are ' mDisplay]))) % Show players why they busted
                disp('Bust!') % Display bust
                break
            else
                disp(string(join(['Your Current Cards are' mDisplay]))) %Otherwise, show cards
            end

        elseif strcmp(action,'S') % If they Stay, continue
            break
        end
    end
    
    % Now Dealer will hit
    dHits = 0;
    while 1
        if dScore <= 16 %Dealer hits on anything under 16
            dHits = dHits +1;
            [deck,dHand,dBase,dScore] = hitCard(deck,dHits,dHand,dBase); % Give dealer an additional card
            if dScore > 21 % If they have now gone above 21, its a bust
                disp('Dealer Bust!') % Display bust
                break
            end
        else
            break
        end
    end
    WaitSecs(2);

    %% Feedback Phase 
    % Now that dealing is done, lets see who won. 

    dDisplay = join([dHand{:}]); % Make a label for dealer's cards
    disp(['The Dealer has: ' dDisplay]) % Show the hidden dealer cards

    WaitSecs(2);
    tie = 0;
    if mScore > dScore && mScore <=21 || dScore > 21 % If player score is higher than dealer score and they didnt bust,
        disp('Win!') % Display win
        credit = credit + bet; % Add bet to credit pool 
        disp(['You now have: $' num2str(credit) '.']); %Display what's left
        result = 1;
    elseif mScore < dScore || mScore > 21 % If they have less points or busted,
        disp('Loss!') % Display loss 
        credit = credit - bet; % Remove bet from credit pool
        disp(['You now have: $' num2str(credit) '.']); % Display credit pool
        result = 0;
    elseif mScore == dScore % If there is a tie (i.e. a Push)
        disp('Push!') % Display push
        disp(['You now have: $' num2str(credit) '.']); % Display credit unchanged by bet
        tie = 1;
    end
    this_data_line(hands,:) = [pNumber credit bet {mDisplay} {dDisplay} mHits dHits mScore dScore result tie]; %Records all behavioural data for this trial

end
disp(['You now have: $' num2str(credit) '.']);
