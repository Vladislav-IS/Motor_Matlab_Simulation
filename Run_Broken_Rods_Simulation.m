Calculate_Basic;

[Rs, Rr, Ls, Lr] = Broken_Bars(Rs, Rr, Ls, Lr, Nbars, nbroken);
out = sim(simulink_file);
brokenBarsPath = fullfile(subPath_3, ['Nbars-', num2str(Nbars), ' nbroken-', num2str(nbroken)]);
if ~exist(brokenBarsPath, 'dir')
    mkdir(brokenBarsPath);
end
idx = find(out.I_out_curr.time >= save_time_init, 1, 'first');
data_time_nf = out.I_out_curr.time(idx:end)-1;
data_current_nf_phA = out.I_out_curr.signals.values(idx:end,1);
data_current_nf_phB = out.I_out_curr.signals.values(idx:end,2);
data_current_nf_phC = out.I_out_curr.signals.values(idx:end,3);
M1_nf_1 = [(1:length(data_time_nf))', data_time_nf(:), data_current_nf_phA];
writematrix(M1_nf_1, fullfile(brokenBarsPath, 'brokenbars_load100_phaseA.csv'));
M1_nf_2 = [(1:length(data_time_nf))', data_time_nf, data_current_nf_phB];
writematrix(M1_nf_2, fullfile(brokenBarsPath, 'brokenbars_load100_phaseB.csv'));
M1_nf_3 = [(1:length(data_time_nf))', data_time_nf, data_current_nf_phC];
writematrix(M1_nf_3, fullfile(brokenBarsPath, 'brokenbars_load100_phaseC.csv'));