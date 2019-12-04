function [Y] = ftnfc2(x,Ynn,objNetworkData)

%load('networkData2');

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

Pc = zeros(t,1);
Qc = zeros(u,1);
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

% for i = 1:t
%     if strcmpi(objNetworkData.nodeType(i),'Q')
%         
%         objNetworkData.tetaVoltageArgument(i) = x(i)
%         objNetworkData.relativeUnitsVoltage(i) = x(i+t-u)
%        % u=u+1;
%     end
%     if strcmpi(objNetworkData.nodeType(i),'U')
%         
%         objNetworkData.tetaVoltageArgument(i) = x(i)
%     end
% end
% %
%
%relative units voltage !!!!!!!!!!!!!!!
%imposed voltage !!!!!!!!!!!!!!!!!
%
%
%
u=0; %reused
for i =1:t
    if strcmpi(objNetworkData.nodeType(i),'Q')
        u=u+1;
        Pc(i) = objNetworkData.relativeUnitsVoltage(i).*sum(objNetworkData.relativeUnitsVoltage(:)'.*...
            (real(Ynn(i,:)).*cos(objNetworkData.tetaVoltageArgument(i)-objNetworkData.tetaVoltageArgument(:))'+...
            imag(Ynn(i,:)).*sin(objNetworkData.tetaVoltageArgument(i)-objNetworkData.tetaVoltageArgument(:))'));
        Qc(u) = -objNetworkData.relativeUnitsVoltage(i).*sum(objNetworkData.relativeUnitsVoltage(:)'.*...
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
for i = 1:t
    if strcmpi(objNetworkData.nodeType(i),'Q')
        u=u+1;
        results = results + (Pc(i) - objNetworkData.imposedActivePower(i)).^2 + (Qc(u) - objNetworkData.imposedReactivePower(i)).^2;
    end
    if strcmpi(objNetworkData.nodeType(i),'U')
        results = results + (Pc(i) - objNetworkData.imposedActivePower(i)).^2;
    end
end

Y = results;
end







