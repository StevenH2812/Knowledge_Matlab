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

%% 
% # USER CONFIGURATION

% Mode 
ota_p = false;               % true: One-step ahead predicition / false: simulation
    
% Neural Network
inputDelays = 1:2;          % Number of delays to use / 1:2 means x(t-1) and x(t-2) is used to estimate y(t) for series-parallel NARX
feedbackDelays = 1:2;       % Number of feedback delays to use / 1:2 means y(t-1) and y(t-2) is used to estimate y(t) for series-parallel NARX
hiddenLayersize = 1;        % Number of NN hidden layers

% Data set 
trainfactor = 0.8;          % Percentage of id data set for training, remaining for MATLAB validation of overfitting

% S/W Performance Boost
USE_PARALLEL = 'no';        % 'yes': Possibly faster for higher number of layers/delays / 'no': disable


%% DO NOT EDIT BELOW THIS LINE 

%%
disp(' ');
disp(' Neural Network Dynamic Time Series Analysis');
disp(' ');


load iddata-05.mat

% # Prepare data for neural network toolbox

% Training data set

id_u = iddata.u;
id_y = (iddata.y); %+(rand(numel(iddata.y),1));
id_ts = iddata.Ts;

% Validation data set

val_u = valdata.u; %.*(rand(numel(valdata.u),1).*5) %NOISE;
val_y = valdata.y;
val_ts = valdata.Ts;

% Combine data set and use index splitting later

inputData = [id_u; val_u].';
outputData = [id_y; val_y].';

%% 
% # Create NARX neural network 
% Uses input and output history values for dynamic system. This create a 
% series-parallel network which uses value of the input x and provided 
% output values upto specified delays to predict the NN output

net = narxnet(inputDelays,feedbackDelays,hiddenLayersize);

modifier = 0;
if ota_p
    net = removedelay(net);         % Sets to one-step ahead predicition 
    net.name = [net.name ' - Predict One Step Ahead'];
    modifier = 1;
end

%net = init(net);            % Initialises the neural net

% Set network sample time

net.sampleTime = id_ts;

% Preparation of the data for the neural network

[data_in, data_instate, data_layerstate, data_out, ~, data_shift] = preparets(net,num2cell(inputData),{},num2cell(outputData));

% # Divide the data into training and testing/validation, the test data is
% only used for testing the neural network's performance

% Determine indices 

ind_train_up = numel(id_u)*trainfactor;		% Training data upper bound index
ind_val_low = ind_train_up+1;					% MATLAB Validation data lower bound index
ind_val_up = numel(id_u);					% MATLAB Validation data upper bound index
ind_test_low = ind_val_up+1;					% Testing data lower bound index
ind_test_up = ind_val_up + numel(val_u);		% Testing data upper bound index

% Divide data for NN by index
net.divideFcn = 'divideind'; 

[net.divideParam.trainInd, net.divideParam.valInd, net.divideParam.testInd] = divideind(numel(outputData) , 1:ind_train_up , ind_val_low:ind_val_up , ind_test_low:ind_test_up );

%% 
% # Network training
% returns trained network and training including number of iterations 
% and performance MSE

[net, trainrecord] = train(net, data_in, data_out, data_instate, data_layerstate,'useParallel',USE_PARALLEL);

%%
% # Test the network and performance calculations
% fixme: CHECK THE INDICES FOR RMS CALCULATIONS

% Preparation of the data for the neural network testing
[val_in, val_instate, val_layerstate, val_out, ~, val_shift] = preparets(net,num2cell(val_u.'),{},num2cell(val_y.'));

test_out = net(val_in, val_instate, val_layerstate);
test_performance = perform(net, val_out, test_out);

% Performance calculations 
test_rms = rms(cell2mat(gsubtract(val_out, test_out)));

disp(['Root-mean square error of test data set: ', num2str(test_rms)]);

% Plotting time-series response

% figure, plotresponse(targets,outputs)

val_out_plt = cell2mat(val_out);
test_out_plt = cell2mat(test_out);

time_series = (val_shift:(numel(val_out)+val_shift-1))*val_ts;    % Moving time-series based on number of Delays included as data set is shifted for initiation 


figure(1);
p1 = plot(time_series, val_out_plt,'--', time_series, test_out_plt);
p1(1).LineWidth = 1.5; 
title('Time-series Response of Test and Neural Network output');
ylabel('Output [-]');
xlabel('Time [s]');
legend('Test data','Neural Network output');
grid on


 