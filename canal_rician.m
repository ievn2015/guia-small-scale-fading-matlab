function [simbolosRx] = canal_rician(datos,snr,ts,fd,Tao,Pdb,k)
    canal = ricianchan(ts,fd,k,Tao,Pdb);
    simbolos_sin_ruido = filter(canal,datos);
    simbolosRx = awgn(simbolos_sin_ruido,snr,'measured');
end