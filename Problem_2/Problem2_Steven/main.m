% Fuzzy Supervisory Control - Problem 2
%
% Fuzzy inference model sets the proportional and differential gain of the
% controller using direct and differential output error.
%   
% @author:  Nikhil Potdar and Steven van der Helm
% @date:    28/03/2016    
% @subject: KBCS SC4081 MATLAB

proportional = readfis('proportional.fis');
derivative = readfis('derivative.fis');

% Fuzzy supervisory control ruleviewer will open but wait for results
disp('Running Fuzzy Supervisory Controller ...');
simout = sim('Sim_model.mdl');
t = out(:,1);
insig = out(:,2);
modelout = out(:,3);

figure;
hold on;
plot(t,insig);
plot(t,modelout);
xlabel('Time [s]');
ylabel('Response [-]');
legend('Reference','Model Output','location','southeast');
grid on
