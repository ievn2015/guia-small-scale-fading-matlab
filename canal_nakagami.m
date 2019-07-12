function [simbolosRX]= canal_nakagami(datos,k,m,snr)
    datos=awgn(datos,snr,'measured');
    %desviacion estandar para rician
    omega=0.25;
    %desviacion estandar para rayleigh
    beta=0.5;
    %se generan un vector de longitud igual a la de los datos y tiene
    %valores con distribucion Rayleigh
    distribucion_ray=random('Rayleigh',beta,1,length (datos));
    %la envolvente de Rayleigh se obtiene multiplicando los datos por los
    %datos que siguen una distribucion Rayleigh pero normalizados
    %se normaliza dividiendo para el elemento mayor del vector
    envol_ray=(distribucion_ray/max(distribucion_ray)).*datos;
    %se generan un vector de longitud igual a la de los datos y tiene
    %valores con distribucion Rician
    distribucion_ric=random('Rician',k,omega,1,length(datos));
    %la envolvente de Rician se obtiene multiplicando los datos por los
    %datos que siguen una distribucion Rician pero normalizados
    %se normaliza dividiendo para el elemento mayor del vector
    envol_ric=(distribucion_ric/max(distribucion_ric)).*datos;
    %Se calcula la envolvente Nakagami aplicando la formula
    simbolosRX=(envol_ray*exp(1-m))+(envol_ric*(1-exp(1-m)));
end