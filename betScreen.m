function [scredit,credit,bet, bPhase] = betScreen(win, ymid, xmid, credit, useDataPixx, bPhase)

scredit = credit;
bet = 50; % Assume a minimum bet of $50
while 1
    dispCredit = scredit-bet;
    Screen('TextFont',win,'Arial');
    Screen('TextSize',win,30);
    DrawFormattedText(win,'Place your bet.','center',ymid-120,[255 255 255]);
    DrawFormattedText(win,sprintf('Credit:$ %d\n',dispCredit),'center',ymid-60,[255 255 255]);

    DrawFormattedText(win,sprintf('$ %d\n',bet),'center',ymid,[255 255 255]);


    Screen('TextFont',win,'Arial');
    Screen('TextSize',win,20);
    DrawFormattedText(win,'To increase your bet, press the red button.','center',ymid+120,[255 255 255]);
    DrawFormattedText(win,'To decrease your bet, press the green button.','center',ymid+180,[255 255 255]);
    DrawFormattedText(win,'To place your bet, press the blue button.','center',ymid+240,[255 255 255]);
    Screen('Flip',win);

    [res] = getresponse(useDataPixx);
    if res == 'r'

        if bet < scredit % If they have gone above their credit,
            bet = bet+50;
            credit = credit-50;
        end

    elseif res == 'g'
        if bet <= 50 % If they have gone below the betting minimum,
            bet = 50;
        else
            bet = bet-50; % Remove $50 from bet
            credit = credit+50;
        end

    elseif res == 'b' % Place bet and continue
        break
    end

end

Screen('TextFont',win,'Arial');
Screen('TextSize',win,30);
DrawFormattedText(win,sprintf('You have bet: $ %d\n',bet),'center',ymid,[255 255 255]);
DrawFormattedText(win,'To continue, press the red button. To replace your bet, press the green button.','center',ymid+120,[255 255 255]);
Screen('Flip',win);
while 1
    [res] = getresponse(useDataPixx);
    if res == 'r'
        bPhase = 0;
        break

    elseif res == 'g'
        credit = scredit;
        break
    end
end
