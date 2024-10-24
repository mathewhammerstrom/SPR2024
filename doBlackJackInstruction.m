function doBlackJackInstruction(win, ymid, xmid, deck,numHands, numTables,cardDir,imageRect, useDataPixx)

textSize = 30;

Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'Welcome to the experiment.','center',ymid-120,[255 255 255]);
DrawFormattedText(win,'Today you will be playing a modified version of Blackjack.','center',ymid-60,[255 255 255]);
DrawFormattedText(win,'First, we will show you how to play the Blackjack and give you some practice.','center',ymid,[255 255 255]);
Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'Press the green/red button to continue','center',ymid+150,[255 255 255]);
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

Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'In Blackjack, your goal is to score higher than the dealer, or score a 21.','center',ymid-120,[255 255 255]);
DrawFormattedText(win,'You will be dealt two cards with different point values based on their numbers, and face cards are worth 10.','center',ymid-60,[255 255 255]);
DrawFormattedText(win,'Aces can be 1 or 10, depending on which works best with the rest of your hand.','center',ymid,[255 255 255]);
Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'Press the green/red button to continue','center',ymid+150,[255 255 255]);
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
Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'For example, these two cards are worth 2 and 10, so your score would be 12.','center',ymid-120,[255 255 255]);
[cardImage, ~, alpha] = imread(char(fullfile(cardDir,deck.Var5(15))));
cardImage(:,:,4) = alpha;
cardTextures(:,1) = Screen('MakeTexture', win, cardImage);
[cardImage, ~, alpha] = imread(char(fullfile(cardDir,deck.Var5(12))));
cardImage(:,:,4) = alpha;
cardTextures(:,2) = Screen('MakeTexture', win, cardImage);

dstRects(:,1) = CenterRectOnPointd(imageRect, xmid-100, ymid+100);
dstRects(:,2) = CenterRectOnPointd(imageRect, xmid+100, ymid+100);

Screen('DrawTextures', win, cardTextures, [], dstRects);

Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'Press the green/red button to continue','center',ymid+400,[255 255 255]);
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

Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'After you are dealt two cards, you can decide to "Hit" to be dealt another card, or "Stay" with your current hand.','center',ymid-60,[255 255 255]);
DrawFormattedText(win,'After you finalize your hand, the dealer will also decide to hit or stay. You will not see their decision','center',ymid,[255 255 255]);
DrawFormattedText(win,'Finally, you will be told if you won, lost, or if it was a tie.','center',ymid+60,[255 255 255]);
Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'Press the green/red button to continue','center',ymid+150,[255 255 255]);
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

Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'When making your decision, please wait for the cross in the center to turn black.','center',ymid-120,[255 255 255]);
DrawFormattedText(win,'If you respond before this, the hand will not count.','center',ymid-60,[255 255 255]);
DrawFormattedText(win,'Do not press a button that does not correspond to one of your choices.','center',ymid,[255 255 255]);
DrawFormattedText(win,'If you press the wrong button, the hand will not count.','center',ymid+60,[255 255 255]);
Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'Press the green/red button to continue','center',ymid+150,[255 255 255]);
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

Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'Careful! If you score above 21, you will "Bust" and lose.','center',ymid-60,[255 255 255]);
DrawFormattedText(win,'If the dealer scores above 21, they will also "Bust" and you will win.','center',ymid,[255 255 255]);
Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'Press the green/red button to continue','center',ymid+150,[255 255 255]);
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

% Screen('TextFont',win,'Arial');
% Screen('TextSize',win,textSize);
% DrawFormattedText(win,'At the beginning of the game, you will be given $1000 credit to bet with.','center',ymid-120,[255 255 255]);
% DrawFormattedText(win,'Each hand will be worth $50.','center',ymid-60,[255 255 255]);
% DrawFormattedText(win,'If you win the hand, you will earn the money from the bet. If you lose, the money will be removed from your credit.','center',ymid,[255 255 255]);
% Screen('TextFont',win,'Arial');
% Screen('TextSize',win,textSize);
% DrawFormattedText(win,'Press the green/red button to continue','center',ymid+150,[255 255 255]);
% Screen('Flip',win);
% 
% while 1
%     [res] = getresponse(useDataPixx);
%     if res == 'g'
%         break
%     end
%     if res == 'r'
%         break
%     end
% end
% WaitSecs(0.5);


Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'Before we start, we will give you some practice trials.', 'center',ymid,[255 255 255]);
Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
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


