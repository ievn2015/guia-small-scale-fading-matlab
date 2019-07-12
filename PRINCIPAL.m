%% ESCUELA POLIT�CNICA NACIONAL
%  Facultad de Ingenier�a El�ctrica y Electr�nica
%  Asignatura: Comunicaciones Inal�mbricas
%  Integrantes: B�ez Mayt�, Herrera Dar�o, Zum�rraga Felipe
%  Docente: PhD. Cecilia Paredes
%  Implementaci�n de canales multitrayecto con desvanecimiento a peque�a 
%  escala

%% Definici�n de variables y par�metros inciales
clc; clear all;
%N�mero total de repeticiones 
Ntrials = 2;
%N�mero de subportadoras de datos
Nd = 48; 
%N�mero total de subportadoras disponibles
N = 64; 
%N�mero de bits agrupados en cada s�mbolo 
%2=QPSK, 4=16QAM
m = 2;
%N�mero niveles de la se�al
M = 2^m;
%Para OFDM
%Tama�o del prefijo c�clico
PC = N/4;
%Valores de SNR para los canales
snr = 0:2:30;
BER_AWGN = [Ntrials,length(snr)];
BER_Rayleigh = [Ntrials,length(snr)];
BER_Rician = [Ntrials,length(snr)];
BER_Nakagami = [Ntrials,length(snr)];
% BER_Weibull = [Ntrials,length(snr)];

%Factor K para el canal Nakagami
%valores utilizados: 0, 4.45, 18.49
k=8;
%el valor de m de nakagami depende del valor de k
m1 =((k+1)^2)/(2*k+1);

fd=100;
ts=1/(fd*1000);
k=8;
Tao=[0,1.5,4];
Pdb=[0,-4,-8];

%% Desarrollo de la simulaci�n
for t=1:Ntrials

    %Generaci�n de bits aleatorios
    bitsTX = round(rand(Nd*m,1));
    
    %Modulaci�n de la cadena de bits
    simbolosTX = modulacion(bitsTX,m);
        
    %Conversi�n de los datos a paralelo
    simbolosTX_paralelo = serieParalelo(simbolosTX,Nd);
        
    %Modulaci�n OFDM
    simbolosTX_ofdm =modulacionOFDM(simbolosTX_paralelo,N,PC);
    
    %Conversi�n de los s�mbolos OFDM a serie
    simbolosTX_serie = paraleloSerie(simbolosTX_ofdm);
        
    for i=1:length(snr)
    %Paso de la se�al por los diferentes canales
    simbolos_AWGN = awgn(simbolosTX_serie,snr(i),'measured');
    simbolos_Ray = canal_rayleigh(simbolosTX_serie,snr(i),ts,fd,Tao,Pdb);
    simbolos_Ric = canal_rician(simbolosTX_serie,snr(i),ts,fd,Tao,Pdb,k);
    simbolos_Nak = canal_nakagami(simbolosTX_serie,k,m1,snr(i));
    
    %Transformar a paralelo QPSK
    simbolosRX_AWGN_paralelo = serieParalelo(simbolos_AWGN,N+PC);
    simbolosRX_Ray_paralelo = serieParalelo(simbolos_Ray,N+PC);
    simbolosRX_Ric_paralelo = serieParalelo(simbolos_Ric,N+PC);
    simbolosRX_Nak_paralelo = serieParalelo(simbolos_Nak,N+PC);
            
    %Demodulador OFDM QPSK
    simbolosRX_AWGN_noOFDM = demodulacionOFDM(simbolosRX_AWGN_paralelo,PC,Nd);
    simbolosRX_Ray_noOFDM = demodulacionOFDM(simbolosRX_Ray_paralelo,PC,Nd);
    simbolosRX_Ric_noOFDM = demodulacionOFDM(simbolosRX_Ric_paralelo,PC,Nd);
    simbolosRX_Nak_noOFDM = demodulacionOFDM(simbolosRX_Nak_paralelo,PC,Nd);
        
    %Transformar a serie QPSK
    simbolosRX_AWGN_serie = paraleloSerie(simbolosRX_AWGN_noOFDM);
    simbolosRX_Ray_serie = paraleloSerie(simbolosRX_Ray_noOFDM);
    simbolosRX_Ric_serie = paraleloSerie(simbolosRX_Ric_noOFDM);
    simbolosRX_Nak_serie = paraleloSerie(simbolosRX_Nak_noOFDM);
    
    %Demodular QPSK
    bitsRX_AWGN = demodular(simbolosRX_AWGN_serie,m);
    bitsRX_Ray = demodular(simbolosRX_Ray_serie,m);
    bitsRX_Ric = demodular(simbolosRX_Ric_serie,m);
    bitsRX_Nak = demodular(simbolosRX_Nak_serie,m);
    
    %Comparaci�n de los datos transimitidos y recibidos
    %BER AWGN
    [No,tasa] = biterr(bitsTX,bitsRX_AWGN);
    BER_AWGN(t,i) = tasa;
    %BER Rayleigh
    [No1,tasa1] = biterr(bitsTX,bitsRX_AWGN);
    BER_Rayleigh(t,i) = tasa1;
    %BER Rician
    [No2,tasa2] = biterr(bitsTX,bitsRX_AWGN);
    BER_Rician(t,i) = tasa2;
    %BER Nakagami
    [No3,tasa3] = biterr(bitsTX,bitsRX_AWGN);
    BER_Nakagami(t,i) = tasa3;
    end
    disp(t);
end

%% Obtenci�n de gr�ficas y resultados
%valor medio del BER QPSK
BERm_AWGN = mean(BER_AWGN,1); 
BERm_Ray = mean(BER_Rayleigh,1);
BERm_Ric = mean(BER_Rician,1);
BERm_Nak = mean(BER_Nakagami,1);
figure(1)
ylim([1e-3 1]);
grid on;
semilogy(snr,BERm_AWGN,'-ok','linewidth',2);
hold on;
semilogy(snr,BERm_Ray,'--sk','linewidth',2);
hold on;
semilogy(snr,BERm_Ric,':+k','linewidth',2);
hold on;
semilogy(snr,BERm_Nak,'-.*k','linewidth',2);
hold on;
xlabel('SNR [dB]','Fontname','Times New Roman');
ylabel('BER [dB]','Fontname','Times New Roman');
legend('AWGN','Rayleigh','Rician','Nakagami');
title('DESVANECIMIENTO A PEQUE�A ESCALA','Fontname','Times New Roman');
