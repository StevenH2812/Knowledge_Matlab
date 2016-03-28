% Takagi-Sugeno fuzzy model - Problem 1
%
% SISO static Takagi=Sugeno system with trapezoidal/singleton antecedent  
% membership functions and affine linear consequent functions. MORE HERE
%   
% @author:  Steven van der Helm and Nikhil Potdar
% @date:    28/03/2016    
% @subject: KBCS SC4081 MATLAB
%
syms x;


%% Define the fuzzy model and ask for which function to approximate

%----------DEFINE THE CONSEQUENT MODEL HERE USING x AS VARIABLE------%
%SINGLETON MODEL WOULD JUST BE [1]
%LINEAR TAKAGI SUGENO WOULD BE [x,1]
%ANY OTHER MODEL (OF ANY ORDER) IS ALLOWED AS WELL (E.G. [sin(x),x^2,1])

TSmodel = [x,1];


%-------INTERACTION TO DEFINE THE REST OF THE FUZZY PROBLEM----------%
disp('Hello, in this set of questions you can define the Fuzzy problem');
cornerdef = input('Would you like to automatically generate membership functions? [y/n]: ','s');
n = input('How many membership functions should there be? [2-n]: ');
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

%target function to approximate
fun = input('Please specify the function to approximate using x as variable: ');
fun = simplify(sym(fun));
disp('Computing the fuzzy approximation to the function...');



%% 

%enter the required datapoints and the xrange
datapoints = 100;
xrange = [low,up];

xpoints=xrange(1):(xrange(2)-xrange(1))/(datapoints-1):xrange(2);


g = matlabFunction(fun);

%generate data
data = zeros(datapoints,2);

ypoints = g(xpoints);

syms x;

A = regressionMatrix(datapoints,corners,TSmodel,xpoints,ypoints);

pars = (A\ypoints')';

yapprox = zeros(1,datapoints);

for i = 1:datapoints
    yapprox(i) = constructY(corners,xpoints(i),pars,TSmodel);
end

figure;
hold on;
plot(xpoints,yapprox,'b');
plot(xpoints,ypoints,'r--');
legend('Takagi-Sugeno approximation','Function');



            
            