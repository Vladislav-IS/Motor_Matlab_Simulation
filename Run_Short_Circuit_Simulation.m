Calculate_Basic;

Rs = Rs*((nturns_phase-fscnturns)/nturns_phase);
Rr = Rr*((nturns_phase-fscnturns)/nturns_phase)^2;
Ls = Ls*((nturns_phase-fscnturns)/nturns_phase)^2;
Lr = Lr*((nturns_phase-fscnturns)/nturns_phase)^2;
out = sim(simulink_file);
shortCircuitPath = fullfile(subPath_2, ['fscnturns-', num2str(fscnturns)]);
if ~exist(shortCircuitPath, 'dir')
    mkdir(shortCircuitPath);
end
idx = find(out.I_out_curr.time >= save_time_init, 1, 'first');
data_time_nf = out.I_out_curr.time(idx:end)-1;
data_current_nf_phA = out.I_out_curr.signals.values(idx:end,1);
data_current_nf_phB = out.I_out_curr.signals.values(idx:end,2);
data_current_nf_phC = out.I_out_curr.signals.values(idx:end,3);
M1_nf_1 = [(1:length(data_time_nf))', data_time_nf(:), data_current_nf_phA];
writematrix(M1_nf_1, fullfile(shortCircuitPath, 'shortcircuit_load100_phaseA.csv'));
M1_nf_2 = [(1:length(data_time_nf))', data_time_nf, data_current_nf_phB];
writematrix(M1_nf_2, fullfile(shortCircuitPath, 'shortcircuit_load100_phaseB.csv'));
M1_nf_3 = [(1:length(data_time_nf))', data_time_nf, data_current_nf_phC];
writematrix(M1_nf_3, fullfile(shortCircuitPath, 'shortcircuit_load100_phaseC.csv'));
