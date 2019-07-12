function [matrizOFDM] = modulacionOFDM(signal,N,PC)
   %Se crea la matriz de subportadoras  
    matriz=zeros(N,1);
   %Se inserta los pilotos en las posiciones -21,-7,21,7
   %La posicion del valor DC queda con valor 0
    matriz(8)=1;  
    matriz(22)=1;
    matriz(44)=-1;
    matriz(58)=1;
   %Se agregan los datos en la matriz 
    matriz(2:7)=signal(25:30);  
    matriz(9:21)=signal(31:43);
    matriz(23:27)=signal(44:48); 
    matriz(39:43)=signal(1:5); 
    matriz(45:57)=signal(6:18); 
    matriz(59:64)=signal(19:24);
 
    %Se pasa al dominio del tiempo - ifft
    ifft_matriz=ifft(matriz,N);  
 
    %Inserción del Prefijo Cíclico
    prefijo=ifft_matriz(N-PC+1:end); % Se toma la parte final del símbolo 
    matrizOFDM=[prefijo;ifft_matriz];  % y se lo coloca al inicio del mismo 
end