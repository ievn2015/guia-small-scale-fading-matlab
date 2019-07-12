function [simbolosRx] = canal_rayleigh(datos,snr,ts,fd,Tao,Pdb)
    canal = rayleighchan(ts,fd,Tao,Pdb);
    simbolos_sin_ruido = filter(canal,datos);
    simbolosRx = awgn(simbolos_sin_ruido,snr,'measured');
end