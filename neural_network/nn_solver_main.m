% Black-box data-driven modelling - Problem 3
%
% MATLAB NARX NEURAL NETWORK. The model uses a NARX neural network as
% implemented in MATLAB. The NN is training using a training set and the 
% performance is evaluated using a validation set.  
%   
% @author:  Nikhil Potdar and Steven van der Helm
% @date:    28/03/2016    
% @subject: KBCS SC4081 MATLAB
%

clear all; close all; clc; 
set(0,'DefaultAxesFontSize',12)

%%     
% NEURAL NETWORK DEFNIITION

% Number of delays to use / 1:2 means x(t-1) and x(t-2) is used to 
% estimate y(t) for series-parallel NARX
inputDelays = 1:3; 

% Number of feedback delays to use / 1:2 means y(t-1) and y(t-2)
% is used to estimate y(t) for series-parallel NARX
feedbackDelays = 1:3; 

% Number of NN hidden layers
hiddenLayersize = 3;        

% DATA SET 
% Percentage of id data set for training, remaining for 
% MATLAB validation of overfitting
trainfactor = 0.8;         

% S/W PERFORMANCE BOOST
% 'yes': Possibly faster for higher number of layers/delays / 'no': disable
USE_PARALLEL = 'no';        


%% DO NOT EDIT BELOW THIS LINE 

%%
disp(' ');
disp(' Neural Network Dynamic Time Series Analysis');
disp(' ');

% Load external identification and validation data
load iddata-05.mat

% PREPARE DATA FOR NN TOOLBOX

% Training data set
id_u = iddata.u;
id_y = (iddata.y);
id_ts = iddata.Ts;

% Testing data set (validation data set)
test_u = valdata.u;
test_y = valdata.y;
test_ts = valdata.Ts;

% Combine data set and use index splitting later
inputData = [id_u; test_u].';
outputData = [id_y; test_y].';

%% 
% CREATE NARX NEURAL NETWORK
% Uses input and output history values for dynamic system. This create a 
% series-parallel network which uses value of the input x and provided 
% output values upto specified delays to predict the NN output

net = narxnet(inputDelays,feedbackDelays,hiddenLayersize);

% Set network sample time

net.sampleTime = id_ts;

% Preparation of the data for the neural network

[data_in, data_instate, data_layerstate, data_out, ~, data_shift] = ...
    preparets(net,num2cell(inputData),{},num2cell(outputData));

% Divide the data into training, MATLAB validation, and testing. The test data is
% only used for testing the neural network's performance

% Determine indices 

ind_train_up = numel(id_u)*trainfactor;		% Training data upper bound index
ind_val_low = ind_train_up+1;				% MATLAB Validation data lower bound index
ind_val_up = numel(id_u);					% MATLAB Validation data upper bound index
ind_test_low = ind_val_up+1;				% Testing data lower bound index
ind_test_up = ind_val_up + numel(test_u);	% Testing data upper bound index

% Divide data for NN by index
net.divideFcn = 'divideind'; 

[net.divideParam.trainInd, net.divideParam.valInd, net.divideParam.testInd] ...
    = divideind(numel(outputData) , 1:ind_train_up , ...
    ind_val_low:ind_val_up , ind_test_low:ind_test_up );

%% 
% # Network training
% returns trained network and training including number of iterations 
% and performance MSE

[net, trainrecord] = train(net, data_in, data_out, data_instate, ...
    data_layerstate,'useParallel',USE_PARALLEL);

% Save trained network to other variable

net_org = net;

%%
% # Simulation and One step ahead Network

for i = 1:2
    
% Create simulation then one-step ahead rms and plots
if i==2
    disp('One Step Ahead');
    net = removedelay(net_org);         % Sets to one-step ahead predicition 
    net.name = [net.name ' - Predict One Step Ahead'];
    modifier = 1;
else
    disp('Simulation');
    net = closeloop(net_org);
    net.name = [net.name ' - Simulation'];  
    modifier = 0;
end


% Preparation of the data for neural network train data and NN 
[train_in, train_instate, train_layerstate, train_out, ~, train_shift] = ...
    preparets(net,num2cell(id_u.'),{},num2cell(id_y.'));
train_net_out = net(train_in, train_instate, train_layerstate);
train_rms = rms(cell2mat(gsubtract(train_out(1:(end-modifier)), ...
    train_net_out(1:(end-modifier)))));

disp(['Root-mean square error of train data set: ', num2str(train_rms)]);

% Preparation of the data for the neural network testing and NN
[test_in, test_instate, test_layerstate, test_out, ~, test_shift] = ...
    preparets(net,num2cell(test_u.'),{},num2cell(test_y.'));
test_net_out = net(test_in, test_instate, test_layerstate);
test_rms = rms(cell2mat(gsubtract(test_out(1:(end-modifier)), ...
    test_net_out(1:(end-modifier)))));

disp(['Root-mean square error of test data set: ', num2str(test_rms)]);

% PLOTTING TIME RESPONSE
% Moving time-series based on number of Delays included 

train_time_series = (train_shift:(numel(train_out)+train_shift-1))*id_ts;    
test_time_series = (test_shift:(numel(test_out)+test_shift-1))*test_ts;    

% Training and neural network output plot

fig1 = figure(1);
p1 = plot(train_time_series, cell2mat(train_out), ':', ...
    train_time_series, cell2mat(train_net_out));
p1(1).LineWidth = 1.5; 
ylabel('Output [-]');
xlabel('Time [s]');
legend('Train data','Neural Network output', 'location', 'southwest');
grid on

print(fig1,strcat('fig_train',num2str(i)),'-depsc');

% Testing and neural network output plot

fig2 = figure(2);
p1 = plot(test_time_series, cell2mat(test_out), ':', ...
    test_time_series, cell2mat(test_net_out));
p1(1).LineWidth = 1.5; 
ylabel('Output [-]');
xlabel('Time [s]');
legend('Test data','Neural Network output','location','southeast');
grid on

print(fig2,strcat('fig_test',num2str(i)),'-depsc');

pause
end
