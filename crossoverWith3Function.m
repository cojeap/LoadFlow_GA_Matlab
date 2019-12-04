function xoverKids = crossoverWith3Function(parents,options,GenomeLength,~,thisScore,thisPopulation,ratio)
%crossover function for ga that makes use of 3 methods:
%-heuristic
%-arithmetic
%-scattered
%in the above order
%for nkids = 0:1/3, 1/3:2/3 and 2/3:end
%%%...shuffle...???

if nargin < 7 || isempty(ratio)
    ratio = 1.2;
end

% How many children am I being asked to produce?
nKids = length(parents)/2;

nKidsHeur = floor(length(parents)/3)/2;
nKidsArith = floor(length(parents)*2/3)/2;

% Extract information about linear constraints, if any
linCon = options.LinearConstr;

% Allocate space for the kids
xoverKids = zeros(nKids,GenomeLength);

index = 1;

%heuristic
for i=1:nKidsHeur
    parent1 = thisPopulation(parents(index),:);
    score1 = thisScore(parents(index));
    index = index + 1;
    parent2 = thisPopulation(parents(index),:);
    score2 = thisScore(parents(index));
    index = index + 1;
    if(score1 < score2) % parent1 is the better of the pair
        xoverKids(i,:) = parent2 + ratio .* (parent1 - parent2);
    else % parent2 is the better one
        xoverKids(i,:) = parent1 + ratio .* (parent2 - parent1);
    end
end

%scattered
r1=0;
r2=0;
for i=nKidsHeur+1:nKidsArith
    r1 = parents(index);
    index = index + 1;
    r2 = parents(index);
    index = index + 1;
    for j = 1:GenomeLength
        if(rand > 0.5)
            xoverKids(i,j) = thisPopulation(r1,j);
        else
            xoverKids(i,j) = thisPopulation(r2,j);
        end
    end
end
%aritm

r1=0;
r2=0;
for i=nKidsArith+1:nKids
    r1 = parents(index);
    index = index + 1;
    r2 = parents(index);
    index = index + 1;
    % Children are arithmetic mean of two parents
    alpha = rand;
    xoverKids(i,:) = alpha*thisPopulation(r1,:) + (1-alpha)*thisPopulation(r2,:);
end

%end function
end