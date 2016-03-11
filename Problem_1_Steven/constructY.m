function [ y ] = constructY( corners,x,pars,TSmodel )
%CONSTRUCTY Summary of this function goes here
%   Detailed explanation goes here
den = 0;
y=0;
%for i = 1:length(corners)
%    den = den + evaluateMembership(i,corners,x);
%end

parcounter = 1;
for i = 1:length(corners)
    gammai = evaluateGamma(i,corners,x);
    parsi = pars(parcounter:parcounter+length(TSmodel)-1);
    temp = gammai.*parsi;
    y = y + subs(sum(temp.*TSmodel),x);
%     y = y + evaluateMembership(i,corners,x)*(pars(parcounter)*x+pars(parcounter+1));
%     y = y/den;
    parcounter = parcounter +length(TSmodel);
end

end

