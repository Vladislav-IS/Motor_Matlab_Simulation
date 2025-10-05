Calculate_Basic;

function [Rs_f, Rr_f, Ls_f, Lr_f] = broken_bars(Rs, Rr, Ls, Lr, Nbars, nbroken)
kL = 0.2;
if nbroken < 0 || nbroken ~= round(nbroken)
    error('nbroken must be a nonnegative integer.');
end
if Nbars <= 0 || Nbars ~= round(Nbars)
    error('Nbars must be a positive integer.');
end
if nbroken == 0
    Rs_f = Rs; Rr_f = Rr; Ls_f = Ls; Lr_f = Lr; return;
end
if nbroken >= Nbars/3
    error('nbroken must be < Nbars/3 to keep the empirical formula valid (denominator N-3n > 0).');
end
Rr_f = Rr * (Nbars - 2*nbroken) / (Nbars - 3*nbroken);
Rs_f = Rs;
Ls_f = Ls;
Lr_f = Lr * (1 - kL * (nbroken / Nbars));
end

[Rs, Rr, Ls, Lr] = broken_bars(Rs, Rr, Ls, Lr, Nbars, nbroken);
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