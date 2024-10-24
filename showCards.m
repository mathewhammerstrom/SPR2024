function  showCards(win,dstRects,cardTextures,hiddenText)


cardTextures(:,4) = Screen('MakeTexture', win, hiddenText);
Screen('DrawTextures', win, cardTextures, [], dstRects);
DrawFormattedText(win,'+','center','center',[128 128 128]);
Screen(win,'TextSize',25);
Screen('Flip',win);
WaitSecs(2);