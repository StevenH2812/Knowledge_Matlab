function [ y ] = constructY( corners,x,pars,TSmodel )
%CONSTRUCTY This function gives a certain "y" value for a certain "x"
%location, once the membership functions are fully defined (information
%contained in corners) and the Takagi-Sugeno model has been determined
%using the least squares operation (information contained in pars)


y=0;

parcounter = 1;
for i = 1:length(corners)
    gammai = evaluateGamma(i,corners,x);
    parsi = pars(parcounter:parcounter+length(TSmodel)-1);
    temp = gammai.*parsi;
    y = y + subs(sum(temp.*TSmodel),x);
    parcounter = parcounter +length(TSmodel);
end

end

