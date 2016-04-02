% Fuzzy Supervisory Control - Problem 2
%
% Fuzzy inference model sets the proportional and differential gain of the
% controller using direct and differential output error.
%   
% @author:  Nikhil Potdar and Steven van der Helm
% @date:    28/03/2016    
% @subject: KBCS SC4081 MATLAB


% Include fis files for Fuzzy Controller
proportional = readfis('proportional.fis');
derivative = readfis('derivative.fis');

% Fuzzy supervisory control ruleviewer will open but wait for results
disp('Running Fuzzy Supervisory Controller ...');

% Obtain simulation ouputs for plotting
simout = sim('Sim_model.mdl');
t = out(:,1);
insig = out(:,2);
modelout = out(:,3);
upbound = [];
lowbound = [];
upbound(1)=insig(1)+0.5*0.1;
lowbound(1)=insig(1)-0.5*0.1;

%This code is here to plot the error bands around the signal
inarray = [1 1 .5 .5 2 2 1.5 1.5 3 3 2.5 2.5 4 4];
intime = [0 15 15.5 30 30.5 45 45.5 60 60.5 75 75.5 90 91.5 111];
counter = 1;
firstchange = 1;
errorband = 0.1;

for i = 2:length(insig)
    dif = insig(i)-insig(i-1);
    if(dif==0 && firstchange==0)
        firstchange = 1;
        counter = counter+2;
        bigdif = abs(inarray(counter)-inarray(counter-2));
        upbound(i)=insig(i)+bigdif*errorband;
        lowbound(i) = insig(i)-bigdif*errorband;
    elseif(dif==0 && firstchange~=0)
        upbound(i)=upbound(i-1);
        lowbound(i)=lowbound(i-1);
    else
         firstchange = 0;
         upbound(i)=insig(i);
         lowbound(i)=insig(i);
    end
        
end
% Plotting
figure;
hold on;
plot(t,insig);
plot(t,modelout);
plot(t,upbound,'black--');
plot(t,lowbound,'black--');
xlabel('Time [s]');
ylabel('Response [-]');
legend('Reference','Model Output','location','southeast');
set(gca,'XTick',0:10:120);
set(gca,'FontSize',22);
grid on