function [deck,hand,base,score,dstRects,cardTextures,bust] = hitCard(deck,hits,hand,base,win,imageRect,xmid,ymid,dstRects,cardTextures,cardDir,player,condition,useDataPixx)
% Deals one card to existing hand, similiar to dealCards but in this case
% its can be used by player or dealer.
bust = 0;
dealtCard = randi(height(deck)); % Randomly select card

hand(2+hits) = deck.Label(dealtCard); % Place new card name on top of hand

base = [base deck.PointValue(dealtCard)];  % Repeat with card value
score = sum(base); % Sum up the score
[hand, base, score] = aceCorrection(hand,base,score); % Re-correct for Aces to prevent unneccesary busts

tableSize = size(cardTextures,2); % Determine how many cards are on the table

% Draw the image for the new card
[cardImage, ~, alpha] = imread(char(fullfile(cardDir,deck.Var5(dealtCard))));
cardImage(:,:,4) = alpha;
cardTextures(:,tableSize+1) = Screen('MakeTexture', win, cardImage);

% Now we have to determine how to space the cards
if hits > 1
    spacer = linspace(xmid-(imageRect(3)*hits/1.5),xmid+(imageRect(3)*hits/1.5),length(hand)); %Make space from left side of first card to right side of last card
else
    spacer = linspace(xmid-(imageRect(3)),xmid+(imageRect(3)),length(hand)); %Make space from left side of first card to right side of last card
end
if player
    dstRects(:,1) = CenterRectOnPointd(imageRect, spacer(1), ymid+200); %Redraw card 1
    dstRects(:,2) = CenterRectOnPointd(imageRect, spacer(2), ymid+200); %Redraw card 2
    for extra = 1:hits
        dstRects(:,4+extra) = CenterRectOnPointd(imageRect, spacer(2+extra), ymid+200);
    end
else
    dstRects(:,3) = CenterRectOnPointd(imageRect, spacer(1), ymid-200);
    dstRects(:,4) = CenterRectOnPointd(imageRect, spacer(2), ymid-200);

    spaceT = tableSize-4-hits+1; % Finds the size of the table for base cards + player hits without needing input
    for extra = 1:hits
        dstRects(:,4+extra+spaceT) = CenterRectOnPointd(imageRect, spacer(2+extra), ymid-200);
    end
end

% Draw Hands
Screen('DrawTextures', win, cardTextures, [], dstRects);
Screen(win,'TextSize',35);
DrawFormattedText(win,'+','center','center',[0 0 0]);
Screen(win,'TextSize',25);
if condition ~=3 || condition ~=4
    DrawFormattedText(win,'Press the red button to HIT.',xmid+500,ymid+500,[255 255 255]);
    DrawFormattedText(win,'Press the green button to STAY.',xmid-800,ymid+500,[255 255 255]);
end
flipandmark(win,60,useDataPixx);


deck(dealtCard,:) = []; % Remove card from deck

if score > 21
    bust = 1;
end
