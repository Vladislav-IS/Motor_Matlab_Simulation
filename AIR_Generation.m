Kcdistf = 0.9; 
Kpitchf = 1;
kw = Kcdistf*Kpitchf;
simulink_file = 'AC_motor_5.slx';
fb = 50;
save_time_init = 3; 
Ts = 2e-5;
wb = 2 * pi * fb;
C1 = 1.02;
J = 0.0226;          
Tsimulation = 100000e-3+1000e-3; 
Tswrite = 0.24e-3;
Bmax = 0.01; 
csv_file = 'AIR_Series.csv';
basePath = 'Simulations_2';
data = readtable(csv_file, 'Delimiter', ',', 'VariableNamingRule', 'preserve');
for i = 1:height(data)
    motor_name = strrep(data{i, 1}{1}, '/', '_');
    P = data{i, 2} / 2; % poles pairs count
    Power = data{i, 5} * 1000; % rated power, W
    nn = data{i, 7};
    eta = data{i, 8};
    cosfi = data{i, 9};              
    mk = data{i, 11}; % M_start / M_n 
    Ikn = data{i, 12}; 
    Un_parts = strsplit(data{i, 4}{1}, '/');
    for Un_part = Un_parts
        Un = str2double(Un_part); % rated voltage, V
        Vph = Un / sqrt(3);
        Run_Simulation;
    end
end