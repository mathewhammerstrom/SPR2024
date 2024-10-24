function [hand, base, score] = aceCorrection(hand,base,score)
% Determines if ace is high or low

for counter = 1:length(hand) % Search through hand
    if strcmp(hand(counter), 'Ace') % Find any aces 

        base(counter) = 10; % Assume its high and give it a value of 10
        score = sum(base); % Re-add the hand 
        if score > 21 % If there is a bust,
            base(counter) = 1; % Make the ace low and give it a value of 1
        end
    end
end

score = sum(base); % Reset the score accordingly