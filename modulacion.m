function [simbolosTX] = modulacion(bits,m)
    bitsMatrix = reshape(bits,length(bits)/m,m);   
    bitsSimbolos = bi2de(bitsMatrix);
    if m==4||m==6
        simbolosTX = qammod(bitsSimbolos,2^m);
    end
    if m==2
        simbolosTX = pskmod (bitsSimbolos,2^m);
    end
end

