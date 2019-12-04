function mutationChildren = MUT_fun(parents, options, nvars, FitnessFcn, state, thisScore, thisPopulation)

mutationChildren=thisPopulation(parents,:);

varmut=round(rand(size(parents))*(nvars-1)+1);

for i=1:size(parents,2)
mutationChildren(i,varmut(i))=rand*(options.PopInitRange(2,varmut(i))-options.PopInitRange(1,varmut(i)))+options.PopInitRange(1,varmut(i));
end

if ~isempty(state.Best)
    indbest=thisPopulation(find(thisScore==state.Best(state.Generation-1),1),:);
    
    for i=1:nvars
        mutationChildren(i,:)=indbest;
        mutationChildren(i,i)= mutationChildren(i,i)+0.1*rand*(options.PopInitRange(2,i)-options.PopInitRange(1,i))+options.PopInitRange(1,i);
    end
    
end

% if state.Generation==10
%     mutationChildren(1,1:4)=[2 105 50 0];
% end

end