function [deck,mHand,mBase,mScore,dHand,dBase,dScore,cardTextures,dstRects,hiddenText] = dealCards(deck,cardDir,win,imageRect,xmid,ymid,useDataPixx)
% Deals two cards each to player and dealer, in alternating order

for counter = 1:2
    % Deal card to player first
    dealtCard = randi(height(deck)); % Randomly select card from deck

    mHand(counter) = deck.Label(dealtCard); % Store the name of the player card
    mBase(counter) = deck.PointValue(dealtCard); % Store the value of the player card

    [cardImage, ~, alpha] = imread(char(fullfile(cardDir,deck.Var5(dealtCard))));
    cardImage(:,:,4) = alpha;
    cardTextures(:,counter) = Screen('MakeTexture', win, cardImage);


    deck(dealtCard,:) = []; % Remove this card from the deck


    mScore = sum(mBase); % Tally the score of the hand

    [mHand, mBase, mScore] = aceCorrection(mHand,mBase,mScore); % Determine if there is an ace, and if its high or low

    % Repeat for dealer
    dealtCard = randi(height(deck));

    dHand(counter) = deck.Label(dealtCard);
    dBase(counter) = deck.PointValue(dealtCard);
    hiddenText = imread(char(fullfile(cardDir,deck.Var5(dealtCard)))); % Save the hidden card texture for later
    deck(dealtCard,:) = [];

    dScore = sum(dBase);

    [dHand, dBase, dScore] = aceCorrection(dHand,dBase,dScore);
end
dstRects(:,1) = CenterRectOnPointd(imageRect, xmid-100, ymid+200);
dstRects(:,2) = CenterRectOnPointd(imageRect, xmid+100, ymid+200);
dstRects(:,3) = CenterRectOnPointd(imageRect, xmid-100, ymid-200);
dstRects(:,4) = CenterRectOnPointd(imageRect, xmid+100, ymid-200);

% Draw the image for the back of the dealer's cards
[cardImage, ~, alpha] = imread(char(fullfile(cardDir,"Cover_Cards.png")));
cardImage(:,:,4) = alpha;
cardTextures(:,3) = Screen('MakeTexture', win, cardImage);
cardTextures(:,4) = Screen('MakeTexture', win, cardImage);

% Draw Hands
Screen('FillRect', win, 127.5);
Screen('DrawTextures', win, cardTextures, [], dstRects);
Screen(win,'TextSize',35);
DrawFormattedText(win,'+','center','center',[255 255 255]);
flipandmark(win,50,useDataPixx);



