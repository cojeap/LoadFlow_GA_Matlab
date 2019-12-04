classdef NetworkLineData
    properties
        fromNode
        toNode
        nominalvoltage
        length
        resistance0
        reactance0
        conductance0
        susceptance0
        impedance
        admittance
        isDouble
    end
    methods
        function obj = NetworkLineData(fileName,sheet,xlRange)
            if isempty(fileName)
                msgID = 'NetworkLineData:FileErr';
                msgText = 'File name is invalid!';
                MExcept = MException(msgID,msgText);
                throw(MExcept);
            end
            if exist(fileName,'file')==0
                msgID = 'NetworkLineData:FileErr';
                msgText = 'File does not exist or it has a wrong name!';
                MExcept = MException(msgID,msgText);
                throw(MExcept);
            end
            if isnan(sheet) || sheet == 0
                msgID = 'NetworkLineData:Sheet';
                msgText = 'Incorrect sheet number';
                MExcept = MException(msgID,msgText);
                throw(MExcept);
            end
            
            temp = xlsread(fileName,sheet,xlRange);
            [row,~] = size(temp);
            for i=1:row
                obj.fromNode(i) = temp(i,1);
                obj.toNode(i) = temp(i,2);
                obj.nominalvoltage(i) = temp(i,3);
                obj.length(i) = temp(i,4);
                obj.resistance0(i) = temp(i,5);
                obj.reactance0(i) = temp(i,6);
                obj.conductance0(i) = temp(i,7);
                obj.susceptance0(i) = temp(i,8);
                obj.isDouble(i) = temp(i,9);
            end
            
            obj = obj.PrepareData();
            obj = obj.TransposeData();
        end
    end
    methods (Hidden = true)
        function obj = PrepareData(obj)
            [~,col] = size(obj.fromNode);
            for i=1:col;
                obj.impedance(i) = obj.length(i)*(obj.resistance0(i)+1i*obj.reactance0(i));
                obj.admittance(i) = obj.length(i)*(obj.conductance0(i)+1i*obj.susceptance0(i));
            end
        end
        function obj = TransposeData(obj)
            obj.fromNode = obj.fromNode';
            obj.toNode = obj.toNode';
            obj.nominalvoltage = obj.nominalvoltage';
            obj.length = obj.length';
            obj.resistance0 = obj.resistance0';
            obj.reactance0 = obj.reactance0';
            obj.conductance0 = obj.conductance0';
            obj.susceptance0 = obj.susceptance0';
            obj.impedance = obj.impedance';
            obj.admittance = obj.admittance';
        end
    end
end