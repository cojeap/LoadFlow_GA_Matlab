function mutationChildren = MUT_fun_v2(parents, options, nvars, FitnessFcn, state, thisScore, thisPopulation)

mutationChildren=thisPopulation(parents,:);

varmut=round(rand(size(parents))*(nvars-1)+1);
semn1=sign(rand(size(parents))-0.5);
for i=1:size(parents,2)
    mutationChildren(i,varmut(i))= mutationChildren(i,varmut(i))+0.1*semn1(i)*...
        rand*(options.PopInitRange(2,varmut(i))-options.PopInitRange(1,varmut(i)))+options.PopInitRange(1,varmut(i));
end

if ~isempty(state.Best)
    indbest=thisPopulation(find(thisScore==state.Best(state.Generation-1),1),:);
    N1=10;
    factor=0.2./(1:N1);
    semn=sign(rand(N1,nvars)-0.5);
    
    for kk=1:N1
        Cantitate=rand(1,nvars).*(options.PopInitRange(2,:)-options.PopInitRange(1,:))+options.PopInitRange(1,:);
        for i=1:12
            j=kk*i;
            mutationChildren(j,:)=indbest;
            mutationChildren(j,i)= mutationChildren(i,i)+0.1*semn(kk,i)*factor(kk)*Cantitate(i);
        end
        for i=13:nvars
            mutationChildren(j,:)=indbest;
            mutationChildren(j,i)= mutationChildren(i,i)+semn(kk,i)*factor(kk)*Cantitate(i);
        end
    end
end

% if state.Generation==10
%     mutationChildren(1,1:4)=[2 105 50 0];
% end

end