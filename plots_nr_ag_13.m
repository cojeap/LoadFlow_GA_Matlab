d_theta = abs(abs(stateAlgGA_t2.data.tetaVoltageArgument)   -   abs(REZ_NR_nod(:,4 )));
d_u = abs(abs(stateAlgGA_t2.data.relativeUnitsVoltage)  -   abs(REZ_NR_nod(:,2)));
d_p = abs(abs(stateAlgGA_t2.data.solutionActivePower)   -   abs(REZ_NR_nod(:,6)));
d_q = abs(abs(stateAlgGA_t2.data.solutionReactivePower) -    abs(REZ_NR_nod(:,8)));
%d_theta(3) = d_theta(3)-2*pi;

set(1,'Color','w');

figure(2)
set(2,'Color','w');
bar(d_theta)
ax=gca;
set(gca,'FontName','Times','FontSize',18)
ax.XTickLabel  = {'\Delta\Theta_1';'\Delta\Theta_2';'\Delta\Theta_3';'\Delta\Theta_4';'\Delta\Theta_5';...
    '\Delta\Theta_6';'\Delta\Theta_7';'\Delta\Theta_8';'\Delta\Theta_9';'\Delta\Theta_{10}';...
    '\Delta\Theta_{11}';'\Delta\Theta_{12}';'\Delta\Theta_{13}';};


figure(3)
bar(d_u)
set(3,'Color','w');
ax=gca;
set(gca,'FontName','Times','FontSize',18)
ax.XTickLabel  = {'\DeltaU_1';'\DeltaU_2';'\DeltaU_3';'\DeltaU_4';'\DeltaU_5';...
    '\DeltaU_6';'\DeltaU_7';'\DeltaU_8';'\DeltaU_9';'\DeltaU_{10}';...
    '\DeltaU_{11}';'\DeltaU_{12}';'\DeltaU_{13}';};

figure(4)
bar(d_p)
ax=gca;
set(gca,'FontName','Times','FontSize',18)
ax.XTickLabel  = {'\DeltaP_1';'\DeltaP_2';'\DeltaP_3';'\DeltaP_4';'\DeltaP_5';...
    '\DeltaP_6';'\DeltaP_7';'\DeltaP_8';'\DeltaP_9';'\DeltaP_{10}';...
    '\DeltaP_{11}';'\DeltaP_{12}';'\DeltaP_{13}';};


figure(5)
bar(d_q)
ax=gca;
set(gca,'FontName','Times','FontSize',18)
ax.XTickLabel  = {'\DeltaQ_1';'\DeltaQ_2';'\DeltaQ_3';'\DeltaQ_4';'\DeltaQ_5';...
    '\DeltaQ_6';'\DeltaQ_7';'\DeltaQ_8';'\DeltaQ_9';'\DeltaQ_{10}';...
    '\DeltaQ_{11}';'\DeltaQ_{12}';'\DeltaQ_{13}';};
