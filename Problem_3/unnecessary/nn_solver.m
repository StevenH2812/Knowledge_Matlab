% Neural Network NARX Tool Problem 3
%
% DESCRIPTION
%
% One very good description will eventually be given here!
% Check http://nl.mathworks.com/help/nnet/gs/neural-network-time-series-prediction-and-modeling.html
%   
% PROPERTIES
%
% @author:  Nikhil Potdar and Steven van der Helm
% @date:    11/03/2016    
% @subject: KBCS SC4081 MATLAB
%

clear all; close all; clc; 

%% 
% # USER CONFIGURATION

% Mode 
ota_p = true;               % true: One-step ahead predicition / false: simulation
    
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

% Identification data set

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

train_up = numel(id_u)*trainfactor;		% Training data upper bound index
val_low = train_up+1;					% MATLAB Validation data lower bound index
val_up = numel(id_u);					% MATLAB Validation data upper bound index
test_low = val_up+1;					% Testing data lower bound index
test_up = val_up + numel(val_u);		% Testing data upper bound index

% Divide data for NN by index
net.divideFcn = 'divideind'; 

[net.divideParam.trainInd, net.divideParam.valInd, net.divideParam.testInd] = divideind(numel(outputData) , 1:train_up , val_low:val_up , test_low:test_up );

%% 
% # Network training
% returns trained network and training including number of iterations 
% and performance MSE

[net, trainrecord] = train(net, data_in, data_out, data_instate, data_layerstate,'useParallel',USE_PARALLEL);

%%
% # Test the network and performance calculations
% fixme: CHECK THE INDICES FOR RMS CALCULATIONS


test_out = net(data_in, data_instate, data_layerstate);
test_performance = perform(net, data_out, test_out);

% Performance calculations 
test_diff_error = cell2mat(gsubtract(data_out, test_out));
test_rms = rms(test_diff_error(test_low:(end-modifier)));

disp(['Root-mean square error of test data set: ', num2str(test_rms)]);

% Plotting time-series response

% figure, plotresponse(targets,outputs)

data_out_plt = (cell2mat(data_out));
data_out_plt = data_out_plt(test_low:end);
test_out_plt = (cell2mat(test_out));
test_out_plt = test_out_plt(test_low:end);

time_series = ((numel(val_y)-numel(test_out_plt)+1):numel(val_y))*val_ts;    % Moving time-series based on number of Delays included as data set is shifted for initiation 


figure(1);
p1 = plot(time_series, data_out_plt,'--', time_series, test_out_plt);
p1(1).LineWidth = 1.5; 
title('Time-series Response of Test and Neural Network output');
ylabel('Output [-]');
xlabel('Time [s]');
legend('Test data','Neural Network output');
grid on


 