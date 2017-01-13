function possibleSolution = bulls_and_cows(varargin)
if ~nargin
    % For the first run all 4-digit number are possible solutions
    possibleSolution = 1000:1:9999;

    % Remove number with repeating digits e.g 1417
    K = length(possibleSolution);
    deletionMask = true(K,1);
    for k=1:K
        if length(unique(num2str(possibleSolution(k)))) < 4
            deletionMask(k) = false;
        end
    end
    possibleSolution = possibleSolution(deletionMask);
else
    % Take remaining possible solution from previous runs
    possibleSolution = varargin{1};
end

% User input
enteredCode = input('Entered Code: ');
B = input('Bulls: ');
C = input('Cows: ');

% Loop over all possible solution and compare number of bulls and cows
K = length(possibleSolution);    
deletionMask = true(K,1);
for k=1:K
    [cows, bulls] = getResponse(enteredCode, possibleSolution(k));
    if any([cows, bulls] ~= [C, B])
        deletionMask(k) = false;
    end
end
possibleSolution = possibleSolution(deletionMask);

% Suggest a number from remaining possible solutions as a next guess
K = length(possibleSolution);
maxN = 0;
for k=1:K
    N = 0;
    for m=1:K
        [cows, bulls] = getResponse(possibleSolution(m), possibleSolution(k));
        if any([cows, bulls] ~= [C, B])
            N = N + 1;
        end
    end
    if N > maxN
        bestGuess = possibleSolution(k);
        maxN = N;
    end
end

fprintf('Suggested Guess: %g\n', bestGuess);
end

function [cows, bulls] = getResponse(enteredCode, realSolution)
% Convert number to strings
s_Code = num2str(enteredCode);
s_Solution = num2str(realSolution);

% Bulls
bulls = sum(s_Code == s_Solution);

% Cows
u_Code = unique(s_Code);
cows = 0;
for k=1:length(u_Code)
    t_Code = repmat(u_Code(k), [1 4]);
    cows = cows + sum(s_Solution == t_Code);
end
cows = cows - bulls;
end