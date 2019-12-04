function xoverKids = crossover3Function(parents,options,GenomeLength,~,thisScore,thisPopulation,ratio)
%crossover function for ga that makes use of 3 methods:
%-heuristic
%-arithmetic
%-scattered
%in the above order
%for GenomeLength = 0:1/3, 1/3:2/3 and 2/3:end

if nargin < 7 || isempty(ratio)
    ratio = 1.2;
end

% How many children am I being asked to produce?
nKids = length(parents)/2;
% Extract information about linear constraints, if any
linCon = options.LinearConstr;

% Allocate space for the kids
xoverKids = zeros(nKids,GenomeLength);

index = 1;
sizeHeur = round(GenomeLength/3);
sizeArith = round(GenomeLength*2/3);

for i=1:nKids
    
    parent1 = thisPopulation(parents(index),:);
    score1 = thisScore(parents(index));
    r1 = parents(index);
    
    index = index + 1;
    
    parent2 = thisPopulation(parents(index),:);
    score2 = thisScore(parents(index));
    r2 = parents(index);
    
    index = index + 1;
    
    
    %heuristic
    
    if(score1 < score2) % parent1 is the better of the pair
        xoverKids(i,1:sizeHeur) = parent2(1:sizeHeur) + ratio .* (parent1(1:sizeHeur) - parent2(1:sizeHeur));
    else % parent2 is the better one
        xoverKids(i,1:sizeHeur) = parent1(1:sizeHeur) + ratio .* (parent2(1:sizeHeur) - parent1(1:sizeHeur));
    end
    
    %arithmetic
    
    alpha = rand;
    xoverKids(i,sizeHeur:sizeArith) = alpha*thisPopulation(r1,sizeHeur:sizeArith) + (1-alpha)*thisPopulation(r2,sizeHeur:sizeArith);
    
    %scattered
    for j=sizeArith:GenomeLength
        if(rand > 0.5)
            xoverKids(i,j) = thisPopulation(r1,j);
        else
            xoverKids(i,j) = thisPopulation(r2,j);
        end
    end
    %end methods

    %end for i:nkids
end
%end function
end
