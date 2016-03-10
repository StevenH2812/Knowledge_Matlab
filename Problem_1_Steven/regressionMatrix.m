function [ A ] = regressionMatrix( datapoints,corners,TSmodel,xpoints,ypoints )
%REGRESSIONMATRIX Summary of this function goes here
%   Detailed explanation goes here
syms x;
A = zeros(datapoints,length(TSmodel)*length(corners));
counter = 1;
for rows = 1:datapoints
    counter = 1;
    for cols = 1:length(TSmodel):length(TSmodel)*length(corners) 
        x = xpoints(rows);
        A(rows,cols:cols+length(TSmodel)-1) = eval(evaluateGamma(counter,corners,xpoints(rows))*TSmodel);
        counter = counter +1;
    end
end
    
end

