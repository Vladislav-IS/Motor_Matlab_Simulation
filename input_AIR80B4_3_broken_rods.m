%% Parameters of the motor AIR 80B4
%
P = 2; % number of pole pairs
Power = 2*746; % W - motor power (1.5 kW)
Vph = 380/sqrt(3); % V - phase voltage
%Vdc = 460; % DC Voltage in the drive

Ts = 2e-5; % time step of the model
fb = 50; % Hz - base frequency
wb = 2*pi*fb; % rpm - Base speed

Rr = 1.274;             % Ohm - Rotor resistance
Rs = 3.523;             % Ohm - Stator resistance
Lls = 0.013;            % H - Stator inducatnce
Llr = 0.013;            % H - Rotor inductance
Lm = 0.401;            % H - Magnetizing Inductance
Ls = 0.414;             % H - Stator inducatnce
Lr = 0.414;             % H - Rotor inductance

%% Faulty mode. Short circuit of the stator winding
% specific magnetic loading (average flux density in air gap, in Tesla or Wb/m²)
%{
Bmax = 0.01; % Bmax - maximum flux per pole (Wb)
Kcdistf = 0.9; % Distribution factor
Kpitchf = 1; % Pitch factor
kw = Kcdistf*Kpitchf; % kw - winding factor (accounts for coil distribution and pitch)
nturns_phase = round(Vph*sqrt(3)/4.44/fb/kw/Bmax); % total number of winding turns
fscnturns = 2; % number of turns of the stator winding wherre there is a short circuit
Rs = Rs*((nturns_phase-fscnturns)/nturns_phase);
Rr = Rr*((nturns_phase-fscnturns)/nturns_phase)^2;
Ls = Ls*((nturns_phase-fscnturns)/nturns_phase)^2;
Lr = Lr*((nturns_phase-fscnturns)/nturns_phase)^2;
%}
%% Faulty mode. Broken rods of the rotor squirrel cage

Nbars   = 28;      % <-- set your rotor bar count here
nbroken = 0;       % e.g., two adjacent broken bars
[Rs, Rr, Ls, Lr] = broken_bars(Rs, Rr, Ls, Lr, Nbars, nbroken);

%% Calculation of other parameters

J = 0.0226;           % kg/m^2 - Moment of inertia

Tsimulation = 4000e-3+1000e-3; %s - total simulation time
Tswrite = 0.24e-3; %414e-3; %s - data saving frequency

out = sim('AC_motor_4');


%%
function [Rs_f, Rr_f, Ls_f, Lr_f] = broken_bars(Rs, Rr, Ls, Lr, Nbars, nbroken)
% Empirical update of equivalent-circuit parameters
% for an induction motor with broken rotor bars.
%
%   Rotor resistance increment:
%     ΔRr = (n / (N - 3n)) * Rr   ⇒   Rr_f = Rr * (N - 2n) / (N - 3n)
% Rs, Ls unchanged.
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

