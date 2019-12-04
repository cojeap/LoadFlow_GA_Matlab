%%main
% node type
% PQ = Q
% PU = U
% Slack  = E
%

%{
fileName = 'dateRetea.xlsx';

fileSheet = 1;
fileXlRange = 'A1:I5';
networkData = NetworkData(fileName,fileSheet,fileXlRange);
%networkData2 = NetworkData(fileName,fileSheet,fileXlRange);

%fileSheet = 2;
%fileXlRange = 'A1:I4';
%lineData =  NetworkLineData(fileName,fileSheet,fileXlRange);

%fileSheet = 3;
%fileXlRange = 'A1:J4';
%transformerData = x();

maticeAdmitante = load('matriceAdmitante.mat');

%stateAlg = StateAlgorithms(networkData,maticeAdmitante.Ynn);
%stateAlgMNR = stateAlg.NR_Algorithm(maticeAdmitante.Ynn);

%stateAlg2 = StateAlgorithms(networkData2,maticeAdmitante.Ynn);
%stateAlgGA = stateAlg2.GA_Algorithm();

%}


%
fileName = 'date_TEST2_FIN2.xlsx';

fileSheet = 2;
fileXlRange = 'A1:I14';

%networkData_t2 = NetworkData(fileName,fileSheet,fileXlRange);
networkData2_t2 = NetworkData(fileName,fileSheet,fileXlRange);



matriceAdmitanteTest2 = load('YNNN.mat');
load('NR_13 NODURI.mat');

%stateAlg_t2 = StateAlgorithms(networkData_t2,matriceAdmitanteTest2.matriceAdmitanteTest2.Ynn);
%stateAlgMNR_t2 = stateAlg_t2.NR_Algorithm(matriceAdmitanteTest2.matriceAdmitanteTest2.Ynn);

%stateAlg2_t2 = StateAlgorithms(networkData2_t2,matriceAdmitanteTest2.matriceAdmitanteTest2.Ynn);
%stateAlgGA_t2 = stateAlg2_t2.GA_Algorithm();
%}


%{
fileName = 'test2_11.xlsx';

fileSheet = 2;
fileXlRange = 'B2:J12';

%networkData_t3 = NetworkData(fileName,fileSheet,fileXlRange);
networkData2_t3 = NetworkData(fileName,fileSheet,fileXlRange);



matriceAdmitanteTest3 = load('Y_11.mat');


%stateAlg_t3 = StateAlgorithms(networkData_t3,matriceAdmitanteTest3.matriceAdmitanteTest3.Ynn);
%stateAlgMNR_t3 = stateAlg_t3.NR_Algorithm(matriceAdmitanteTest3.matriceAdmitanteTest3.Ynn);

stateAlg2_t3 = StateAlgorithms(networkData2_t3,matriceAdmitanteTest3.matriceAdmitanteTest3.Ynn);
stateAlgGA_t3 = stateAlg2_t3.GA_Algorithm();
%}


%{
fileName = 'date_IEEE9.xlsx';

fileSheet = 1;
fileXlRange = 'B2:J10';

matriceAdmitanteTest4 = load('matriceAdmitanteTest4.mat');

%networkData_t3 = NetworkData(fileName,fileSheet,fileXlRange);

networkData2_t4 = NetworkData(fileName,fileSheet,fileXlRange);

stateAlg2_t4 = StateAlgorithms(networkData2_t4,matriceAdmitanteTest4.matriceAdmitanteTest4.Ynn);
stateAlgGA_t4 = stateAlg2_t4.GA_Algorithm();
%}


%plot_U
%%end main