function [Rs_f, Rr_f, Ls_f, Lr_f] = Broken_Bars(Rs, Rr, Ls, Lr, Nbars, nbroken)
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