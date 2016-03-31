function [ A ] = regressionMatrix( datapoints,corners,TSmodel,xpoints,ypoints )
%REGRESSIONMATRIX This function fills in the regression matrix for the
%least squares computation 
%   This function works with whatever consequent function is specified in
%   the main.m and whatever membership functions are specified by the user
%   in the interaction with main.m
syms x;
A = zeros(datapoints,length(TSmodel)*length(corners));
counter = 1;
for rows = 1:datapoints
    counter = 1;
    for cols = 1:length(TSmodel):length(TSmodel)*length(corners) 
        x = xpoints(rows);
        A(rows,cols:cols+length(TSmodel)-1) = subs(evaluateGamma(counter,...
            corners,xpoints(rows))*TSmodel,x);
        counter = counter +1;
    end
end
    
end

