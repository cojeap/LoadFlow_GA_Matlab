%%load data from an xls file,in an object

classdef NetworkData <handle
    properties
        nodeType
        nominalVoltage
        activePower
        reactivePower
        consumedActivePower
        consumedReactivePower
        imposedVoltage
        minimumReactivePower
        maximumReactivePower
        imposedActivePower
        imposedReactivePower
        %%%%
        relativeUnitsVoltage
        tetaVoltageArgument
        solutionActivePower
        solutionReactivePower
    end
    methods
        function obj = NetworkData(fileName,fsheet,xlRange)
            %{
            if isempty(fileName)
                msgID = 'NetworkData:FileErr';
                msgText = 'File name is invalid!';
                MExcept = MException(msgID,msgText);
                throw(MExcept);
            end
            if exist(fileName,'file')==0
                msgID = 'NetworkData:FileErr';
                msgText = 'File does not exist or it has a wrong name!';
                MExcept = MException(msgID,msgText);
                throw(MExcept);
            end
            if isnan(sheet) || sheet == 0
                msgID = 'NetworkData:Sheet';
                msgText = 'Incorrect sheet number';
                MExcept = MException(msgID,msgText);
                throw(MExcept);
            end
            %}
            temp = xlsread(fileName,fsheet,xlRange,'basic');
            [row,~] = size(temp);
            obj.nodeType = [];
            for i = 1:row
                if(temp(i,1)==2)%1
                    obj.nodeType = [obj.nodeType;'Q'] ;
                elseif(temp(i,1)==1)%2
                    obj.nodeType = [obj.nodeType;'U'] ;
                elseif(temp(i,1)==0)%3
                    obj.nodeType = [obj.nodeType;'E'] ;
                end
            end
            for i = 1:row
                obj.nominalVoltage(i) = temp(i,2) ;
                obj.activePower(i) = temp(i,3) ;
                obj.reactivePower(i) = temp(i,4) ;
                obj.consumedActivePower(i) = temp(i,5) ;
                obj.consumedReactivePower(i) = temp(i,6) ;
                obj.imposedVoltage(i) = temp(i,7) ;
                obj.minimumReactivePower(i) = temp(i,8) ;
                obj.maximumReactivePower(i) = temp(i,9) ;
            end
            
            obj.solutionActivePower = [];
            obj.solutionReactivePower = [];
            
            obj = SetRemainingData(obj);
            obj = TransposeData(obj);
        end
    end
    methods (Hidden = true)
        function obj = SetRemainingData(obj)
            [~,col] = size(obj.nominalVoltage);
            for i =1:col
                obj.imposedActivePower(i) = 0;
                obj.imposedReactivePower(i) = 0;
                obj.relativeUnitsVoltage(i) = 0;
                obj.tetaVoltageArgument(i) = 0;
            end
        end
        function obj = TransposeData(obj) % due to xlread -> change from [~,col] to [row,~]
            obj.nominalVoltage = obj.nominalVoltage';
            obj.activePower = obj.activePower';
            obj.reactivePower = obj.reactivePower';
            obj.consumedActivePower = obj.consumedActivePower';
            obj.consumedReactivePower = obj.consumedReactivePower';
            obj.imposedVoltage = obj.imposedVoltage';
            obj.minimumReactivePower = obj.minimumReactivePower';
            obj.maximumReactivePower = obj.maximumReactivePower';
            obj.imposedActivePower = obj.imposedActivePower';
            obj.imposedReactivePower = obj.imposedReactivePower';
            obj.relativeUnitsVoltage = obj.relativeUnitsVoltage';
            obj.tetaVoltageArgument = obj.tetaVoltageArgument';
        end
    end
end


%%end load data function