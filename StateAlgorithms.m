%%Algorithms Class
classdef StateAlgorithms
    properties
        data = NetworkData.empty;
        Ynn;
        gaResults;
    end
    methods
        function obj = StateAlgorithms(networkData,Ynn)
            %{
            if ~networkData.isvalid()
                msgID = 'StateAlgorithms:DataErr';
                msgText = 'Data is invalid!';
                MExcept = MException(msgID,msgText);
                throw(MExcept);
            end
            %}
            if isempty(networkData)
                msgID = 'StateAlgorithms:DataErr';
                msgText = 'Data obj is empty!';
                MExcept = MException(msgID,msgText);
                throw(MExcept);
            end
            
            obj.Ynn = Ynn;
            
            obj.data = findobj(networkData);
            obj = obj.PrepareData();
        end
        function obj = NR_Algorithm(obj,Ynn)
            
            p = 0;
            nrNoduri = size(obj.data.nodeType)-1;
            nodeTypeNodNou = obj.data.nodeType;
            
            while (p < 50)
                p;
                %pas 3
                Pi = [];
                Qi = [];
                
                for i = 1:size(obj.data.nodeType)
                    Pi = [Pi;0]; %#ok<*AGROW>
                    Qi = [Qi;0];
                end
                for i = 1:size(obj.data.nodeType)
                    Pi(i) = 0;
                    Qi(i) = 0;
                    for k = 1:size(obj.data.nodeType)
                        Pi(i) = Pi(i) + obj.data.relativeUnitsVoltage(i)*obj.data.relativeUnitsVoltage(k)*(real(Ynn(i,k))*cos(obj.data.tetaVoltageArgument(i)-...
                            obj.data.tetaVoltageArgument(k))+imag(Ynn(i,k))*sin(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(k)));
                        Qi(i) = Qi(i) + obj.data.relativeUnitsVoltage(i)*obj.data.relativeUnitsVoltage(k)*(real(Ynn(i,k))*sin(obj.data.tetaVoltageArgument(i)-...
                            obj.data.tetaVoltageArgument(k))-imag(Ynn(i,k))*cos(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(k)));
                    end
                end
                %end pas 3
                %pas 4
                
                if(p > 2)
                    for i = 1:nrNoduri
                        strToCompare = nodeTypeNodNou(i);
                        if strcmpi(strToCompare,'U')
                            if (Qi(i) < obj.data.minimumReactivePower(i))
                                nodeTypeNodNou(i) = ['Q']; %#ok<*NBRAK>
                                obj.data.imposedReactivePower(i) = obj.data.minimumReactivePower(i);
                            end
                            if (Qi(i) > obj.data.maximumReactivePower(i))
                                nodeTypeNodNou(i) = ['Q'];
                                obj.data.imposedReactivePower(i) = obj.data.maximumReactivePower(i);
                            end
                        end
                    end
                end
                %end pas 4
                %pas 5
                
                deltaP = [];
                deltaQ = [];
                for i = 1:nrNoduri
                    strToCompare = nodeTypeNodNou(i); %#ok<*NASGU>
                    if strcmpi(strToCompare,'Q')
                        deltaP = [deltaP;(obj.data.imposedActivePower(i)-Pi(i))];
                        deltaQ = [deltaQ;(obj.data.imposedReactivePower(i)-Qi(i))];
                    end
                    if strcmpi(strToCompare,'U')
                        deltaP = [deltaP;(obj.data.imposedActivePower(i)-Pi(i))];
                    end
                end
                
                deltaP;
                deltaQ;
                
                %end pas 5
                %pas 6
                maxP = max(abs(deltaP));
                maxQ = max(abs(deltaQ));
                precizieCalcul = 10^(-3);
                
                if (maxP <= precizieCalcul) && (maxQ <= precizieCalcul)
                    disp('MetodaNewtonRaphson: status: iesire proces iterativ calcul');
                    break
                end
                %end pas 6
                %pas 7
 
                activePowerCalc = [];
                reactivePowerCalc = [];
                
                for i = 1:(nrNoduri)
                    activePowerCalc = [activePowerCalc;0];
                    reactivePowerCalc = [reactivePowerCalc;0];
                end
                
                for i =1:(nrNoduri)
                    reactivePowerCalc(i)=   -imag(Ynn(i,i)) * obj.data.relativeUnitsVoltage(i)^2 + Qi(i)  - obj.data.relativeUnitsVoltage(i)^2 * (real(Ynn(i,i)) * sin(obj.data.tetaVoltageArgument(i) -...
                        obj.data.tetaVoltageArgument(i)) - imag(Ynn(i,i)) * cos(obj.data.tetaVoltageArgument(i) - obj.data.tetaVoltageArgument(i)) );
                    activePowerCalc(i)  =    real(Ynn(i,i)) * obj.data.relativeUnitsVoltage(i)^2 + Pi(i)  - obj.data.relativeUnitsVoltage(i)^2 * (real(Ynn(i,i)) * cos(obj.data.tetaVoltageArgument(i) -...
                        obj.data.tetaVoltageArgument(i)) + imag(Ynn(i,i)) * sin(obj.data.tetaVoltageArgument(i) - obj.data.tetaVoltageArgument(i)) );
                end
                
                sizeP = size(deltaP);
                sizeTetaVoltageArgument = sizeP;
                sizeQ = size(deltaQ);
                sizeU = sizeQ;
                
                matriceJacobian = [];
                
                H = [];
                temporary = [];
                for i = 1:sizeP
                    temporary = [];
                    for k = 1:sizeTetaVoltageArgument
                        if i==k
                            temporary = [temporary,-(reactivePowerCalc(i)+imag(Ynn(i,i))*(obj.data.relativeUnitsVoltage(i)^2))];
                        else
                            temporary = [temporary,(obj.data.relativeUnitsVoltage(i)*obj.data.relativeUnitsVoltage(k)*(real(Ynn(i,k))*sin(obj.data.tetaVoltageArgument(i)-...
                                obj.data.tetaVoltageArgument(k))-imag(Ynn(i,k))*cos(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(k))))];
                        end
                    end
                    H = [H;temporary];
                end
                
                H; %#ok<*VUNUS>
                
                
                K = [];
                temporary = [];
                
                for i = 1:sizeP
                    temporary = [];
                    for k = 1:sizeU
                        if(strcmpi(nodeTypeNodNou(k),'U'))
                            k=k+1; %#ok<*FXSET>
                        end
                        if i==k
                            temporary = [temporary,(activePowerCalc(i)+real(Ynn(i,i))*(obj.data.relativeUnitsVoltage(i)^2))];
                        else
                            temporary = [temporary,(obj.data.relativeUnitsVoltage(i)*obj.data.relativeUnitsVoltage(k)*(real(Ynn(i,k))*cos(obj.data.tetaVoltageArgument(i)-...
                                obj.data.tetaVoltageArgument(k))+imag(Ynn(i,k))*sin(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(k))))];
                        end
                    end
                    K = [K;temporary];
                end
                
                K;
                
                M = [];
                temporary = [];
                
                for i = 1:sizeQ;
                    if(strcmpi(nodeTypeNodNou(i),'U'))
                        i=i+1;
                    end
                    temporary = [];
                    for k = 1:sizeTetaVoltageArgument
                        if i == k
                            temporary = [temporary,(activePowerCalc(i)-real(Ynn(i,i))*(obj.data.relativeUnitsVoltage(i)^2))];
                        else
                            temporary = [temporary,-(obj.data.relativeUnitsVoltage(i)*obj.data.relativeUnitsVoltage(k)*(real(Ynn(i,k))*cos(obj.data.tetaVoltageArgument(i)-...
                                obj.data.tetaVoltageArgument(k))+imag(Ynn(i,k))*sin(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(k))))];
                        end
                    end
                    M=[M;temporary];
                end
                
                M;
                
                L = [];
                temporary = [];
                
                for i = 1:sizeQ
                    if(strcmpi(nodeTypeNodNou(i),'U'))
                        i=i+1;
                    end
                    temporary = [];
                    for k = 1:sizeU
                        if(strcmpi(nodeTypeNodNou(k),'U'))
                            k=k+1;
                        end
                        if i == k
                            temporary = [temporary,(reactivePowerCalc(i)-imag(Ynn(i,i))*(obj.data.relativeUnitsVoltage(i)^2))];
                        else
                            temporary = [temporary,(obj.data.relativeUnitsVoltage(i)*obj.data.relativeUnitsVoltage(k)*(real(Ynn(i,k))*sin(obj.data.tetaVoltageArgument(i)-...
                                obj.data.tetaVoltageArgument(k))-imag(Ynn(i,k))*cos(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(k))))];
                        end
                    end
                    L = [L;temporary];
                end
                
                L;
                
                matriceJacobian = [H,K;M,L];
                
                %end pas 7
                %pas 8
                dateCalculate = [deltaP;deltaQ];
                
                valoriArgsiTensCalculate = inv(matriceJacobian)*dateCalculate; %#ok<*MINV> % \
                
                deltaTetaVoltageArgument = [];
                deltaU = [];
                for i = 1:sizeP
                    deltaTetaVoltageArgument = [deltaTetaVoltageArgument;valoriArgsiTensCalculate(i)];
                end
                temp = 0;
                for i=1:sizeP
                    if strcmpi(nodeTypeNodNou(i),'Q')
                        temp = temp + 1 ;
                        deltaU = [deltaU;valoriArgsiTensCalculate(nrNoduri(1) + temp)];
                    else
                        deltaU = [deltaU;0];
                    end
                end
                
                %end pas 8
                %pas 9
                for i = 1:nrNoduri
                    obj.data.tetaVoltageArgument(i) = obj.data.tetaVoltageArgument(i) + deltaTetaVoltageArgument(i);
                end
                
                for i = 1:nrNoduri
                    if (strcmpi(obj.data.nodeType(i),'Q'))
                        obj.data.relativeUnitsVoltage(i) = obj.data.relativeUnitsVoltage(i)*(1+deltaU(i));
                    end
                    if (strcmpi(obj.data.nodeType(i),'U')) && (strcmpi(nodeTypeNodNou(i),'Q'))
                        if ((obj.data.imposedReactivePower(i) == obj.data.minimumReactivePower(i)) && (obj.data.relativeUnitsVoltage(i) < (obj.data.imposedVoltage(i))))
                            nodeTypeNodNou(i) = 'U';
                            obj.data.relativeUnitsVoltage(i) = obj.data.imposedVoltage(i);
                        elseif ((obj.data.imposedReactivePower(i) == obj.data.maximumReactivePower(i)) && (obj.data.relativeUnitsVoltage(i) > (obj.data.imposedVoltage(i))))
                            nodeTypeNodNou(i) = 'U';
                            obj.data.relativeUnitsVoltage(i) = obj.data.imposedVoltage(i);
                        end
                    end
                end
                %end pas 9
                %pas 10
                %p=11;
                p = p+1;
                %endpas 10
            end
            %pas 11
            
            
            %end pas 11
            %return
            
            [L,~] = size(obj.data.nodeType);
            for i = 1:L
                if strcmpi(obj.data.nodeType(i),'Q')
                    obj.data.solutionActivePower(i) = activePowerCalc(i);
                    obj.data.solutionReactivePower(i) = reactivePowerCalc(i);
                end
                if strcmpi(obj.data.nodeType(i),'U')
                    obj.data.solutionActivePower(i) = activePowerCalc(i);
                    obj.data.solutionReactivePower(i) = -obj.data.relativeUnitsVoltage(i).*sum(obj.data.relativeUnitsVoltage(:)'.*...
                        (imag(obj.Ynn(i,:)).*cos(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'-...
                        real(obj.Ynn(i,:)).*sin(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'));
                end
                if strcmpi(obj.data.nodeType(i),'E')
                    obj.data.solutionActivePower(i) = obj.data.relativeUnitsVoltage(i).*sum(obj.data.relativeUnitsVoltage(:)'.*...
                        (real(obj.Ynn(i,:)).*cos(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'+...
                        imag(obj.Ynn(i,:)).*sin(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'));
                    obj.data.solutionReactivePower(i) = -obj.data.relativeUnitsVoltage(i).*sum(obj.data.relativeUnitsVoltage(:)'.*...
                        (imag(obj.Ynn(i,:)).*cos(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'-...
                        real(obj.Ynn(i,:)).*sin(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'));
                end
            end

            %end return
        end
        function obj = GA_Algorithm(obj)
            
            popSize = 1000;

            [L,~] = size(obj.data.nodeType);
            nvar = 0;
            ar=0;
            t=0;
            for i = 1:L
                if strcmpi(obj.data.nodeType(i),'Q')
                    nvar = nvar + 2;
                    ar=ar+2;
                end
                if strcmpi(obj.data.nodeType(i),'U')
                    nvar = nvar + 1;
                    t=t+1;
                end
            end
            
            LB = [];
            UB = [];
            for i=1:(ar/2+t)
                LB = [LB,-pi/2];
                UB = [UB,pi/2];
            end
            for i=1:(ar/2)
                LB = [LB,0.9];
                UB = [UB,1.1];
            end
             %UB(1:12)=0;
            %LB(1:12)= - 0.3;
            %}
            %LB = [-pi/2 -pi/2 -pi/2 -pi/2 -pi/2 -pi/2 -pi/2 -pi/2 0.9 0.9 0.9 0.9 0.9 0.9];
            %UB = [pi/2 pi/2 pi/2 pi/2 pi/2 pi/2 pi/2 pi/2 1.1 1.1 1.1 1.1 1.1 1.1];
   
            
            %pop(250,:) = [-0.135527697502345,-0.0500452776318404,-0.0846103199850519,-0.147648961048847,-0.115709415649732,-0.180365622660082,-0.140281479595383,-0.174696759432669,-0.189721474515134,-0.173258223298788,-0.0231635019127632,-0.0543530443138977,0.966180879709314,1.01911765449622,0.978881374592513,0.977620184139836,0.998184899838220,0.963577801439947,0.943720877571092,1.02847314819176];
         
           [pop] = obj.GenerateInitialPopulation(popSize,nvar,LB,UB);
           pop(14,:) = [zeros(1,(ar/2+t)),ones(1,ar/2)];
           
            varmut=round(rand(popSize/2)*(nvar-1)+1);
            semn1=sign(rand(popSize/2)-0.5);
            %for i=1:popSize/2
                %pop(i,varmut(i))= pop(14,varmut(i))+0.1*semn1(i)*rand;...                (options.PopInitRange(2,varmut(i))-options.PopInitRange(1,varmut(i)))+options.PopInitRange(1,varmut(i));
            %end
           
           f =@(x)ftnfc_v2(x,obj.Ynn,obj.data);
           %f =@(x)ftnfc_v3_warn(x,obj.Ynn,obj.data,1);
           
          
           %
           options = gaoptimset('PopulationSize',popSize,'Generations',5000,...
               'StallGenLimit',Inf,'StallTimeLimit',Inf,'TolFun',1e-6,...
               'PlotFcns',{@gaplotbestf , @gaplotbestindiv},...
               'CrossoverFraction',0.6,'UseParallel',1,'InitialPopulation',pop,'MutationFcn',{@MUT_fun},...
               'SelectionFcn',{@selectionroulette});
           
           gaResult = ga(f,nvar,[],[],[],[],LB,UB,[],options)';
           %}
           
           %{
          options = gaoptimset('PopulationSize',popSize,'Generations',2000,...
               'StallGenLimit',Inf,'StallTimeLimit',Inf,'TolFun',1e-6,...
               'PlotFcns',{@gaplotbestf , @gaplotbestindiv},...
               'CrossoverFraction',0.6,'UseParallel',1,'InitialPopulation',pop);
           
           gaResult = ga(f,nvar,[],[],[],[],LB,UB,[],options)';
           %}
           
           %{
           options = gaoptimset('Generations',100,'StallGenLimit',Inf,'StallTimeLimit',...
               Inf,'TolFun',1e-6,'PlotFcns',{@gaplotbestf , @gaplotbestindiv},...
               'CrossoverFraction',0.6,'UseParallel',1);
           
           gaResult = ga(f,nvar,[],[],[],[],[],[],[],options)';
           %}
           
           obj.gaResults = gaResult;
           [Y P Q] = ftnfc_ptSOL(gaResult,obj.Ynn,obj.data);
           
           [L,~] = size(obj.data.nodeType);
            t = 0;
            u = 0;
            e = 0;
            for i =1:L
                if strcmpi(obj.data.nodeType(i),'Q')
                    t = t+1;
                    u = u+1;
                end
                if strcmpi(obj.data.nodeType(i),'U')
                    t = t+1;
                end
                if strcmpi(obj.data.nodeType(i),'E')
                    e = e+1;
                end
            end
            
            nPU=[];nPQ=[];
            
            for i = 1:L
                if strcmpi(obj.data.nodeType(i),'Q')
                    nPQ=[nPQ i];
                end
                if strcmpi(obj.data.nodeType(i),'U')
                    nPU=[nPU i];
                end
            end
            
            nPUPQ=sort([nPQ nPU]);
            obj.data.tetaVoltageArgument(nPUPQ) = gaResult(1:t);
            obj.data.relativeUnitsVoltage(nPQ) = gaResult(t+1:end);
            
            %{
            for i = 1:L
                if strcmpi(obj.data.nodeType(i),'Q')
                    obj.data.solutionActivePower(i) = obj.data.relativeUnitsVoltage(i).*sum(obj.data.relativeUnitsVoltage(:)'.*...
                        (real(obj.Ynn(i,:)).*cos(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'+...
                        imag(obj.Ynn(i,:)).*sin(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'));
                    obj.data.solutionReactivePower(i) = -obj.data.relativeUnitsVoltage(i).*sum(obj.data.relativeUnitsVoltage(:)'.*...
                        (imag(obj.Ynn(i,:)).*cos(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'-...
                        real(obj.Ynn(i,:)).*sin(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'));
                end
                if strcmpi(obj.data.nodeType(i),'U')
                    obj.data.solutionActivePower(i) = obj.data.relativeUnitsVoltage(i).*sum(obj.data.relativeUnitsVoltage(:)'.*...
                        (real(obj.Ynn(i,:)).*cos(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'+...
                        imag(obj.Ynn(i,:)).*sin(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))')); 
                    obj.data.solutionReactivePower(i) = -obj.data.relativeUnitsVoltage(i).*sum(obj.data.relativeUnitsVoltage(:)'.*...
                        (imag(obj.Ynn(i,:)).*cos(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'-...
                        real(obj.Ynn(i,:)).*sin(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'));
                end
                if strcmpi(obj.data.nodeType(i),'E')
                    obj.data.solutionActivePower(i) = obj.data.relativeUnitsVoltage(i).*sum(obj.data.relativeUnitsVoltage(:)'.*...
                        (real(obj.Ynn(i,:)).*cos(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'+...
                        imag(obj.Ynn(i,:)).*sin(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'));
                    obj.data.solutionReactivePower(i) = -obj.data.relativeUnitsVoltage(i).*sum(obj.data.relativeUnitsVoltage(:)'.*...
                        (imag(obj.Ynn(i,:)).*cos(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'-...
                        real(obj.Ynn(i,:)).*sin(obj.data.tetaVoltageArgument(i)-obj.data.tetaVoltageArgument(:))'));
                end
            end
            %}

            
            
            
            obj.data.solutionActivePower = P;
            obj.data.solutionReactivePower = Q;
            
        end
    end
    methods (Hidden = true)
        function obj = PrepareData(obj)
            obj.data = findobj(obj.data);
            
            [row,~] = size(obj.data.activePower);
            for i=1:row
                if strcmpi(obj.data.nodeType(i),'Q')
                    obj.data.imposedActivePower(i) = obj.data.activePower(i)-obj.data.consumedActivePower(i);
                    obj.data.imposedReactivePower(i) = obj.data.reactivePower(i)-obj.data.consumedReactivePower(i);
                    obj.data.relativeUnitsVoltage(i) = 1;
                    obj.data.tetaVoltageArgument(i) = 0;
                elseif strcmpi(obj.data.nodeType(i),'U')
                    obj.data.imposedActivePower(i) = obj.data.activePower(i)-obj.data.consumedActivePower(i);
                    obj.data.minimumReactivePower(i) = obj.data.minimumReactivePower(i) - obj.data.consumedReactivePower(i);
                    obj.data.maximumReactivePower(i) = obj.data.maximumReactivePower(i) - obj.data.consumedReactivePower(i);
                    obj.data.relativeUnitsVoltage(i) = obj.data.imposedVoltage(i)/obj.data.nominalVoltage(i);
                    obj.data.tetaVoltageArgument(i) = 0;
                elseif strcmpi(obj.data.nodeType(i),'E')
                    obj.data.imposedActivePower(i) = obj.data.activePower(i)-obj.data.consumedActivePower(i);
                    obj.data.imposedReactivePower(i) = obj.data.reactivePower(i)-obj.data.consumedReactivePower(i);
                    obj.data.relativeUnitsVoltage(i) = obj.data.imposedVoltage(i)/obj.data.nominalVoltage(i);
                    obj.data.tetaVoltageArgument(i) = 0;
                end
            end
            
            Snb = 100; % standard
            [row,~] = size(obj.data.imposedActivePower);
            for i = 1:row
                obj.data.activePower(i) = obj.data.activePower(i)/Snb;
                obj.data.reactivePower(i) = obj.data.reactivePower(i)/Snb;
                obj.data.consumedActivePower(i) = obj.data.consumedActivePower(i)/Snb;
                obj.data.consumedReactivePower(i) = obj.data.consumedReactivePower(i)/Snb;
                obj.data.minimumReactivePower(i) = obj.data.minimumReactivePower(i)/Snb;
                obj.data.maximumReactivePower(i) = obj.data.maximumReactivePower(i)/Snb;
                obj.data.imposedActivePower(i) = obj.data.imposedActivePower(i)/Snb;
                obj.data.imposedReactivePower(i) = obj.data.imposedReactivePower(i)/Snb;
            end
            
        end
        function [genInitPopulation] = GenerateInitialPopulation(~,popSize,nvars,LB,UB)
            if popSize < 40
                msgID = 'StateAlgorithms:PopSize';
                msgText = 'popSize should be >= 40!';
                MExcept = MException(msgID,msgText);
                throw(MExcept);
            end
            [~,colLB] = size(LB);
            if colLB~=nvars
                msgID = 'StateAlgorithms:LB';
                msgText = 'Size of LB is not (1,nvars!)';
                MExcept = MException(msgID,msgText);
                throw(MExcept);
            end
            [~,colUB] = size(UB);
            if colUB~=nvars
                msgID = 'StateAlgorithms:UB';
                msgText = 'Size of UB is not (1,nvars)!';
                MExcept = MException(msgID,msgText);
                throw(MExcept);
            end
            
 
            for i=1:popSize
                genInitPopulation(i,:) = (UB-LB).*rand(1,nvars)+LB;
            end
            %genInitPopulation(1,:)(250,:) = [-0.135527697502345,-0.0500452776318404,-0.0846103199850519,-0.147648961048847,-0.115709415649732,-0.180365622660082,-0.140281479595383,-0.174696759432669,-0.189721474515134,-0.173258223298788,-0.0231635019127632,-0.0543530443138977,0.966180879709314,1.01911765449622,0.978881374592513,0.977620184139836,0.998184899838220,0.963577801439947,0.943720877571092,1.02847314819176];

            %genInitPopulation(1,:) = [zeros(1,12),ones(1,8)];
            
        end
    end
end
%%end Algorithms Class