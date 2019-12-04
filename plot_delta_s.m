
%set(1,'Color','w');
%{
figure(2)
y1 = stateAlgGA_t2.data.solutionActivePower - stateAlgGA_t2.data.imposedActivePower;
y2 = stateAlgGA_t2.data.solutionReactivePower - stateAlgGA_t2.data.imposedReactivePower;

nPU=find((networkData2_t2.nodeType)=='U');
nPQ=find((networkData2_t2.nodeType)=='Q');

nPUPQ = sort([nPU;nPQ]);
bar(y1(nPUPQ))
figure(3)
bar(y2(nPQ))
%}



figure(8)
y1_9 = stateAlgGA_t4.data.solutionActivePower - stateAlgGA_t4.data.imposedActivePower;
y2_9 = stateAlgGA_t4.data.solutionReactivePower - stateAlgGA_t4.data.imposedReactivePower;

nPU_9=find((networkData2_t4.nodeType)=='U');
nPQ_9=find((networkData2_t4.nodeType)=='Q');

nPUPQ_9 = sort([nPU_9;nPQ_9]);
bar(y1_9(nPUPQ_9))
figure(9)
bar(y2_9(nPQ_9))

%}

%{
figure(6)
y1_13 = stateAlgGA_t4.data.solutionActivePower - stateAlgGA_t4.data.imposedActivePower;
y2_13 = stateAlgGA_t4.data.solutionReactivePower - stateAlgGA_t4.data.imposedReactivePower;

nPU_9=find((networkData2_t4.nodeType)=='U');
nPQ_9=find((networkData2_t4.nodeType)=='Q');

nPUPQ_13 = sort([nPU_13;nPQ_13]);
bar(y1_13(nPUPQ_13))
figure(7)
bar(y2_13(nPQ_13))
%}