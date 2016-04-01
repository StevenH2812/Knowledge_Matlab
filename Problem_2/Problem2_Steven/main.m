% Fuzzy Supervisory Control - Problem 2
%
% Fuzzy inference model sets the proportional and differential gain of the
% controller using direct and differential output error.
%   
% @author:  Nikhil Potdar and Steven van der Helm
% @date:    28/03/2016    
% @subject: KBCS SC4081 MATLAB

set(0,'DefaultAxesFontSize',12)
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

% Unsupervised system closed loop results
simout = sim('Sim_model_nosupervisor.mdl');
t_ns = simout2.Time;
insig_ns = simout2.Data(:,1);
modelout_ns = simout2.Data(:,2);

% Plotting
figure(1)
plot(t,insig, t, modelout);
xlabel('Time [s]');
ylabel('Response [-]');
legend('Reference','Model Output','location','southeast');
grid on

print -depsc fuzzy_supervisory

figure(2)
plot(t_ns,insig_ns, t_ns, modelout_ns);
xlabel('Time [s]');
ylabel('Response [-]');
legend('Reference','Model Output','location','southeast');
grid on

print -depsc non_supervised