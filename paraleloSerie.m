function [serie]=paraleloSerie(paralelo)
[m,n]=size(paralelo);
for i=1:m
   serie((i-1)*n+1:i*n,1)=paralelo(i,:);
end
end
