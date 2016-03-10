n = 3; %number of membership functions

syms x

%Define corner points of the membership functions
%--------NOTE: Manual construction is bugged atm--------%
cornerdef = input('Would you like to automatically generate membership functions? [y/n]: ','s');
n = input('How many membership functions should there be? [0-n]: ');
corners = {};
if cornerdef=='n'
    low = input('Please specify the lower domain bound as a number: ');
    up = input('Please specify the upper domain bound as a number: ');
    disp('The membership functions will be trapezoidal in shape');
    disp('Please specify the four corner points of the trapezoid');
    for member = 1:n
        message = char(strcat('Please specify member',{' '},int2str(member),{' '},'corner 1 as a number:',{' '}));
        corners{member}.one = input(message);
        message = char(strcat('Please specify member',{' '},int2str(member),{' '},'corner 2 as a number:',{' '}));
        corners{member}.two = input(message);
        message = char(strcat('Please specify member',{' '},int2str(member),{' '},'corner 3 as a number:',{' '}));
        corners{member}.three = input(message);
        message = char(strcat('Please specify member',{' '},int2str(member),{' '},'corner 4 as a number:',{' '}));
        corners{member}.four = input(message);        
    end
else
    low = input('Please specify the lower domain bound as a number: ');
    up = input('Please specify the upper domain bound as a number: ');
    corners = constructMembershipFunctions(n,low,up);
end



%enter the required datapoints and the xrange
datapoints = 400;
xrange = [low,up];

xpoints=xrange(1):(xrange(2)-xrange(1))/(datapoints-1):xrange(2);

%target function
%fun = sin(x)^2+2;
fun = input('Please specify the function to approximate using x as variable: ');
fun = simplify(sym(fun));



%generate data
data = zeros(datapoints,2);
ypoints = zeros(1,length(xpoints));

for i = 1:length(xpoints)
    x = xpoints(i);
    ypoints(i)=eval(fun);
end

syms x;

%Create Takagi-Sugeno model structure using variable x
TSmodel = [x,1];

A = regressionMatrix(datapoints,corners,TSmodel,xpoints,ypoints);

%pars = ((A'*A)^-1)*A'*ypoints';

pars = (A\ypoints')';

yapprox = zeros(1,datapoints);

for i = 1:datapoints
    yapprox(i) = constructY(corners,xpoints(i),pars);

end

figure;
hold on;
plot(xpoints,ypoints);
plot(xpoints,yapprox);
legend('Function','Takagi-Sugeno approximation');



            
            