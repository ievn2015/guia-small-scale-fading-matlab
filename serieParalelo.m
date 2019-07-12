function [paralelo]=serieParalelo(serie,columnas)
%columnas es el numero de columnas que va a tener la matriz
l=length(serie);
serie(l+1:ceil(l/columnas)*columnas)=0;
for ii=1:ceil(l/columnas)
    paralelo(ii,:)=serie(((ii-1)*columnas)+1:((ii-1)*columnas)+columnas);
end