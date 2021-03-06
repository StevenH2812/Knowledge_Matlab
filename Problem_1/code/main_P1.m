% Takagi-Sugeno fuzzy model - Problem 1
%
% SISO static Takagi=Sugeno system with trapezoidal or triangular antecedent  
% membership functions and affine consequent functions, including singleton
% consequent functions.
%   
% @author:  Steven van der Helm and Nikhil Potdar
% @date:    28/03/2016    
% @subject: KBCS SC4081 MATLAB
%

syms x;


%% Define the fuzzy model and ask for which function to approximate

%----------DEFINE THE CONSEQUENT FUNCTION HERE USING x AS A VARIABLE------%
%singleton consequent model would just be [1]
%------------------------------EXTRA 1---------------------------------%
%script works with any type of affine consequent function in x
%linear takagi sugeno would be [x,1]
%any other consequent function (of any order) is allowed as well (e.g. 
%[sin(x),x^2,1])
%it is recommended to keep the last "basis function" equal to 1 to
%accommodate for averages in the signal
%------------------------------EXTRA 2---------------------------------%
%The script can automatically generate triangular membership functions
%that are equally spread in the specified domain by the user


TSmodel = [sin(3*x),sin(x),x^2,1];


%-------INTERACTION TO DEFINE THE REST OF THE FUZZY PROBLEM----------%
disp('Hello, in this set of questions you can define the Fuzzy problem');
cornerdef = input('Automatically generate membership functions? [y/n]: ','s');
n = input('How many membership functions should there be? [2-n]: ');
corners = {};
if cornerdef=='n'
    low = input('Please specify the lower domain bound as a number: ');
    up = input('Please specify the upper domain bound as a number: ');
    pause(0.5);
    disp(' ');
    disp(' ');
    pause(0.5);
    disp('The membership functions will be trapezoidal in shape');
    pause(2);
    disp('Please specify the four corner points of the trapezoid');
    pause(2);
    disp('Note: stretch a corner to infinity using -Inf or Inf and NaN');
    disp('Example stretching membership to -infinity:');
    disp('Corner 1 is NaN, corner 2 is -Inf, corner 3 and 4 are real numbers');
    for member = 1:n
        message = char(strcat('Please specify member',{' '},int2str(member),...
            {' '},'corner 1 as a number:',{' '}));
        corners{member}.one = input(message);
        message = char(strcat('Please specify member',{' '},int2str(member),...
            {' '},'corner 2 as a number:',{' '}));
        corners{member}.two = input(message);
        message = char(strcat('Please specify member',{' '},int2str(member),...
            {' '},'corner 3 as a number:',{' '}));
        corners{member}.three = input(message);
        message = char(strcat('Please specify member',{' '},int2str(member),...
            {' '},'corner 4 as a number:',{' '}));
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

%perform the least squares approximation);
A = regressionMatrix(datapoints,corners,TSmodel,xpoints,ypoints);

pars = (A\ypoints')';

yapprox = zeros(1,datapoints);

%construct the Takagi-Sugeno model output for all the x locations
for i = 1:datapoints
    yapprox(i) = constructY(corners,xpoints(i),pars,TSmodel);
end

figure;
hold on;
set(gca,'fontsize', 20);
plot(xpoints,yapprox,'b');
plot(xpoints,ypoints,'ro');
xlabel('x');
ylabel('output');
legend('Takagi-Sugeno approximation','Function data');



            
            