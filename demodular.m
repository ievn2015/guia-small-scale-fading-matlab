function [simbolosRX] = demodular(rxSignal,m)
    if m==4||m==6
        demo=qamdemod(rxSignal, 2^m);
    end
    if m==2
        demo=pskdemod(rxSignal, 2^m);
    end
    dataOutMatrix = de2bi(demo,m);
    simbolosRX = dataOutMatrix(:);
end

