%

set(1,'Color','w');

%%plot U si T
figure(2)
set(2,'Color','w');
y1 = [];
y2 = [];
for i=1:size(networkData.nodeType)
y1 = [y1;abs(networkData.tetaVoltageArgument(i)-networkData2.tetaVoltageArgument(i))];
y2 = [y2;abs(networkData.relativeUnitsVoltage(i)-networkData2.relativeUnitsVoltage(i))];
end
y=[y1;y2];
indici=find(y);
x=1:size(indici);
bar(x,y(indici))
grid on;
ax=gca;
set(gca,'FontName','Times','FontSize',14)
ax.XTickLabel  = {'\Delta\Theta_1';'\Delta\Theta_2';'\Delta\Theta_3';'\DeltaU1';'\DeltaU3'};
figNAME='Erori_Xopt';
%hgsave(2,figNAME);


%plot P si Q
figure(3)
set(3,'Color','w');
y1=[];
y2=[];
for i=1:size(networkData.nodeType)
y1 = [y1;abs(networkData.solutionActivePower(i)-networkData2.solutionActivePower(i))];
y2 = [y2;abs(networkData.solutionReactivePower(i)-networkData2.solutionReactivePower(i))];
end
y=[y1;y2];
indici=find(y);
x=[1:size(indici)];
bar(x,y)
grid on;
ax=gca;
set(gca,'FontName','Times','FontSize',14)
ax.XTickLabel  = {'\DeltaP1';'\DeltaP2';'\DeltaP3';'\DeltaP4';...
                 '\DeltaQ1';'\DeltaQ2';'\DeltaQ3';'\DeltaQ4'};
figNAME='Erori_P_Q';
%hgsave(3,figNAME);

% hgexport(2,figNAME)