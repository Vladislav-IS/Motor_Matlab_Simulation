function out = Suggest_z2(P_kw, n_nom_rpm, p, f_hz)
% Empirical parameterization for selecting the rotor bar count Z2
%
% INPUT:
%   P_kw       — power, kW
%   n_nom_rpm  — nominal speed, rpm
%   p          — number of pole pairs
%   f_hz       — mains frequency, Hz (default 50)
%
% OUTPUT (struct):
%   out.Z1                 — estimated stator slot count
%   out.q                  — slots per phase per pole (3-phase machine)
%   out.ns_rpm             — synchronous speed
%   out.s_est              — estimated slip
%   out.Z2_star            — rough (real-valued) estimate of Z2
%   out.candidates         — vector of Z2 candidates (2–4 values, even)
%   out.candidate_notes    — notes for each candidate

    if nargin < 4 || isempty(f_hz), f_hz = 50; 
    end

    % Estimate synchronous speed and slip
    ns_rpm = 60 * f_hz / p;
    s_est  = max(0.02, 1 - n_nom_rpm / ns_rpm);

    % Estimate q and stator slot count Z1 = 6*p*q (3-phase machine)
    q_raw = 2.5 + 0.25*log(P_kw) + 0.4*( (3000/ns_rpm)^(0.4) ); % empirical formula
    q     = clip(round(q_raw), 2, 4);        % q in [2..4]
    Z1    = 6 * p * q;                       % typically 36, 48, 60, etc.

    % Coefficient dependent on pole pairs and machine power
    kappa = kappa_by_p(p);
    kappa = kappa * (1 + 0.03*(P_kw^(1/6) - 1));

    Z2_star = kappa * Z1;

    % Build a set of even feasible values for Z2
    Z2_even0 = make_even(round(Z2_star));
    span = -6:2:6;                            % search span (even)
    pool = Z2_even0 + span;
    pool = pool(pool > 0);                    % only positive
    
    % Remove duplicates and invalid options
    pool = unique(pool);
    good  = true(size(pool));
    notes = strings(size(pool)); % array with an assessment of each option

    for i = 1:numel(pool)
        z2 = pool(i);
        % Exclude cases: Z2 = Z1, Z1/2, 2*Z1
        if is_forbidden_combo(Z1, z2)
            good(i)  = false;
            notes(i) = "forbidden combination (equalities with Z1)";
            continue;
        end
        % Preferably: gcd(Z1, Z2) not divisible by p (less slotting beats)
        g = gcd(Z1, z2);
        if mod(g, p) == 0
            notes(i) = "tooth vibrations are possible (gcd is a multiple of p)";
        else
            notes(i) = "ok";
        end
    end

    pool  = pool(good);
    notes = notes(good);

    % Sort by proximity to Z2_star
    cost  = abs(pool - Z2_star);
    % bonus for "ok" (lower cost)
    cost = cost + 0.2 * (notes ~= "ок");

    [~, idx] = sort(cost);
    pool  = pool(idx);
    notes = notes(idx);

    % Common/typical values depending on the number of pole pairs
    anchors = [];
    if p == 2
        anchors = [40 44];
    elseif p == 1
        anchors = [28 34 40];    % typical for 2-pole
    elseif p == 3
        anchors = [44 48 56];
    elseif p >= 4
        anchors = [48 56 64];
    end
    for a = anchors(:).'
        if a > 0 && mod(a,2)==0 && ~any(pool==a)
            if ~is_forbidden_combo(Z1,a)
                pool  = [a, pool]; %#ok<AGROW>
                % anchor tag (priority)
                notes = ["standard anchor", notes]; %#ok<AGROW>
            end
        end
    end

    % Keep 2–4 best candidates
    max_keep = 4;
    keep = min(max_keep, max(2, numel(pool)));
    pool  = pool(1:keep);
    notes = notes(1:keep);

    % Output
    out = struct();
    out.Z1              = Z1;
    out.q               = q;
    out.ns_rpm          = ns_rpm;
    out.s_est           = s_est;
    out.Z2_star         = Z2_star;
    out.candidates      = pool(:).';
    out.candidate_notes = notes(:).';
end


function y = clip(x, a, b)
    y = min(max(x, a), b);
end

function z = make_even(x)
    % Round to the nearest even number
    z = 2 * round(x/2);
    if z <= 0, z = 2; end
end

function tf = is_forbidden_combo(Z1, Z2)
    tf = (Z2 == Z1) || (2*Z2 == Z1) || (Z2 == 2*Z1);
end

function k = kappa_by_p(p)
    % Base coefficient by pole pairs (empirical)
    switch true
        case p == 1    % 2-pole (3000 rpm at 50 Hz)
            k = 0.90;
        case p == 2    % 4-pole (1500)
            k = 1.15;
        case p == 3    % 6-pole (1000)
            k = 1.02;
        otherwise      % 8+ poles (750 and below)
            k = 0.95;
    end
end