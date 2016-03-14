proportional = readfis('proportional.fis');
derivative = readfis('derivative.fis');

simout = sim('Sim_model.mdl');
t = out(:,1);
insig = out(:,2);
modelout = out(:,3);

figure;
hold on;
plot(t,insig);
plot(t,modelout);
legend('input','model output');