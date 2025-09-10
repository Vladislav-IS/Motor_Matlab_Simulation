%% AIR80B4 parameters
P = 2; % number of pole pairs
Power = 2*746; % W - motor power (1.5 kW)
Vph = 380/sqrt(3); % V - phase voltage
Vdc = 460; % DC Voltage in the driver
Ts = 2e-5; % time step of the model
fb = 50; % Hz - base frequency
wb = 2*pi*fb; % rpm - Base speed
Rr = 1.274; % Ohm - Rotor resistance
Rs = 3.523; % Ohm - Stator resistance
Lls = 0.013; % H - Stator inducatnce
Llr = 0.013; % H - Rotor inductance
Lm = 0.401; % H - Magnetizing Inductance
Ls = 0.414; % H - Stator inducatnce
Lr = 0.414; % H - Rotor inductance

%% Other parameters
J = 0.0226; % kg/m^2 - Moment of inertia
Tsimulation = 6000e-3+1000e-3; %s - total simulation time
Tswrite = 0.24e-3; %414e-3; %s - data saving frequency
save_time_init = 3; % start saving data after 2 seconds of simulation (steady-state)
run_name = ['Noizz', num2str(Noizz), '_load100_']; % csv-files prefix

%% Simulation
out = sim('AC_motor_4');
idx = find(out.I_out_curr.time >= save_time_init, 1, 'first');
data_time_nf = out.I_out_curr.time(idx:end)-1;
data_current_nf_phA = out.I_out_curr.signals.values(idx:end,1);
data_current_nf_phB = out.I_out_curr.signals.values(idx:end,2);
data_current_nf_phC = out.I_out_curr.signals.values(idx:end,3);
M1_nf_1 = [(1:length(data_time_nf))', data_time_nf(:), data_current_nf_phA];
writematrix(M1_nf_1, [run_name, 'phaseA.csv']);
M1_nf_2 = [(1:length(data_time_nf))', data_time_nf, data_current_nf_phB];
writematrix(M1_nf_2, [run_name, 'phaseB.csv']);
M1_nf_3 = [(1:length(data_time_nf))', data_time_nf, data_current_nf_phC];
writematrix(M1_nf_3, [run_name, 'phaseC.csv']);