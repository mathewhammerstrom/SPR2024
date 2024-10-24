function doSREBlackJackInstruction(win, ymid, xmid,playerImage, playerImageRect, earnerImage,earnerImageRect,squarePosition, colourCodes,currentColourNames,useDataPixx)

textSize = 30;

Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'In this version of Blackjack, you will also be playing with another individual.','center',ymid-120,[255 255 255]);
DrawFormattedText(win,'Sometimes you will gamble with your money, sometimes you will gamble with their money.','center',ymid-60,[255 255 255]);
DrawFormattedText(win,'Sometimes you will play, sometimes you will watch someone play.','center',ymid,[255 255 255]);
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
DrawFormattedText(win,'Before each hand, you will be shown cues to tell you who is playing, and who has money at stake.','center',ymid-120,[255 255 255]);
DrawFormattedText(win,'This cue will be delivered with a coloured square around a Dollar Sign ($) or a Playing Card.','center',ymid-60,[255 255 255]);
DrawFormattedText(win,'The Dollar Sign indicates who has money at stake, the Playing Card indicates who is playing the hand.','center',ymid,[255 255 255]);
DrawFormattedText(win,['Your colour will be ' currentColourNames{1,:} ', and the other player will be represented by ' currentColourNames{2,:} '.'],'center',ymid+60,[255 255 255]);
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
DrawFormattedText(win,'For example, here is what it will look like when your money is at stake.','center',ymid-240,[255 255 255]);
Screen('FrameRect', win, colourCodes(1,:),squarePosition,10);
Screen('DrawTexture', win, earnerImage, [], earnerImageRect);

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
DrawFormattedText(win,'Here is what it will look like when someone else''s money is at stake.','center',ymid-240,[255 255 255]);
Screen('FrameRect', win, colourCodes(2,:),squarePosition,10);
Screen('DrawTexture', win, earnerImage, [], earnerImageRect);

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
DrawFormattedText(win,'Here is what it will look like you are playing','center',ymid-240,[255 255 255]);
Screen('FrameRect', win, colourCodes(1,:),squarePosition,10);
Screen('DrawTexture', win, playerImage, [], playerImageRect);

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
DrawFormattedText(win,'Here is what it will look like when someone else is playing','center',ymid-240,[255 255 255]);
Screen('FrameRect', win, colourCodes(2,:),squarePosition,10);
Screen('DrawTexture', win, playerImage, [], playerImageRect);

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
DrawFormattedText(win,'Importantly, the other player is a real person who has previously participated in this experiment.','center',ymid-120,[255 255 255]);
DrawFormattedText(win,'When it is their turn to play, you will view hands of blackjack simulated based on their performance. ','center',ymid-60,[255 255 255]);
DrawFormattedText(win,'When their money is at stake, it will affect their earnings from the experiment.','center',ymid,[255 255 255]);
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
DrawFormattedText(win,'At the beginning of the game, you will be both given credit to bet with.','center',ymid-120,[255 255 255]);
DrawFormattedText(win,'You will start with $1000 and the other player will start with $1100, based on their previous performance.','center',ymid-60,[255 255 255]);
DrawFormattedText(win,'If the player wins the hand, the earner will earn the money from the bet.','center',ymid,[255 255 255]);
DrawFormattedText(win,'If the player loses the hand, the earner will lose the money from the bet.','center',ymid+60,[255 255 255]);
DrawFormattedText(win,'Each bet is worth $50.','center',ymid+120,[255 255 255]);
Screen('TextFont',win,'Arial');
Screen('TextSize',win,textSize);
DrawFormattedText(win,'Press the green/red button to continue','center',ymid+200,[255 255 255]);
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
DrawFormattedText(win,'Before we start, we will give you some practice trials with the new player/earner cues.', 'center',ymid,[255 255 255]);
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


