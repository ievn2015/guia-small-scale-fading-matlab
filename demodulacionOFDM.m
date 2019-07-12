function [simbolos]=demodulacionOFDM(signal,PC,Nd)
    %se quita el prefijo ciclico
    signal_sinPC=signal(PC+1:end);
    
    %Paso al dominio de la frecuecia - fft
    fft_matriz=fft(signal_sinPC);
    
    %Extraccion de dc,nulas y pilotos
    simbolos=zeros(Nd,1); 
    simbolos(1:5)=fft_matriz(39:43); 
    simbolos(6:18)=fft_matriz(45:57);
    simbolos(19:24)=fft_matriz(59:64); 
    simbolos(25:30)=fft_matriz(2:7);
    simbolos(31:43)=fft_matriz(9:21);
    simbolos(44:48)=fft_matriz(23:27);
end

