function [Y] = ftnfc_v2(x,Ynn,objNetworkData)

%load('networkData2');
%load('YNNN'); %% Ynn
%Ynn = matriceAdmitanteTest2.Ynn;

[L,~] = size(objNetworkData.nodeType);
t = 0;
u = 0;
e = 0;
for i =1:L
    if strcmpi(objNetworkData.nodeType(i),'Q')
        t = t+1;
        u = u+1;
    end
    if strcmpi(objNetworkData.nodeType(i),'U')
        t = t+1;
    end
    if strcmpi(objNetworkData.nodeType(i),'E')
        e = e+1;
    end
end

Pc = zeros(L,1);
Qc = zeros(L,1);

nPU=[];nPQ=[];
for i = 1:L
    if strcmpi(objNetworkData.nodeType(i),'Q')
        nPQ=[nPQ i];
    end
    if strcmpi(objNetworkData.nodeType(i),'U')
        nPU=[nPU i];
    end
end

nPUPQ=sort([nPQ nPU]);
objNetworkData.tetaVoltageArgument(nPUPQ) = x(1:t);
objNetworkData.relativeUnitsVoltage(nPQ) = x(t+1:end);

u=0; %reused
for i =1:L
    if strcmpi(objNetworkData.nodeType(i),'Q')
        Pc(i) = objNetworkData.relativeUnitsVoltage(i).*sum(objNetworkData.relativeUnitsVoltage(:)'.*...
            (real(Ynn(i,:)).*cos(objNetworkData.tetaVoltageArgument(i)-objNetworkData.tetaVoltageArgument(:))'+...
            imag(Ynn(i,:)).*sin(objNetworkData.tetaVoltageArgument(i)-objNetworkData.tetaVoltageArgument(:))'));
        Qc(i) = -objNetworkData.relativeUnitsVoltage(i).*sum(objNetworkData.relativeUnitsVoltage(:)'.*...
            (imag(Ynn(i,:)).*cos(objNetworkData.tetaVoltageArgument(i)-objNetworkData.tetaVoltageArgument(:))'-...
            real(Ynn(i,:)).*sin(objNetworkData.tetaVoltageArgument(i)-objNetworkData.tetaVoltageArgument(:))'));
        
        %Y = Y + ((Pc - networkData2.imposedActivePower(i)).^2 + (Qc - networkData2.imposedReactivePower(i)).^2);
    end
    if strcmpi(objNetworkData.nodeType(i),'U')
        %         u=u+1;
        Pc(i) = objNetworkData.relativeUnitsVoltage(i).*sum(objNetworkData.relativeUnitsVoltage(:)'.*...
            (real(Ynn(i,:)).*cos(objNetworkData.tetaVoltageArgument(i)-objNetworkData.tetaVoltageArgument(:))'+...
            imag(Ynn(i,:)).*sin(objNetworkData.tetaVoltageArgument(i)-objNetworkData.tetaVoltageArgument(:))'));
    end
end


u=0;
results = 0;
for i = 1:L
    if strcmpi(objNetworkData.nodeType(i),'Q')
        results = results + (Pc(i) - objNetworkData.imposedActivePower(i)).^2 + (Qc(i) - objNetworkData.imposedReactivePower(i)).^2;
    end
    if strcmpi(objNetworkData.nodeType(i),'U')
        results = results + (Pc(i) - objNetworkData.imposedActivePower(i)).^2;
    end
end

Y = results;
end







