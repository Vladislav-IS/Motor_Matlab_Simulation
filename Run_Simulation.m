subPath = fullfile(basePath, [motor_name, ' Un-', num2str(Un), ' Vdc-' num2str(Vdc)]);
subPath_1 = fullfile(subPath, 'no_fault');
subPath_2 = fullfile(subPath, 'short_circuit');
subPath_3 = fullfile(subPath, 'broken_bars');
if ~exist(subPath, 'dir')
    mkdir(subPath);
end
if ~exist(subPath_1, 'dir')
    mkdir(subPath_1);
end
if ~exist(subPath_2, 'dir')
    mkdir(subPath_2);
end
if ~exist(subPath_3, 'dir')
    mkdir(subPath_3);
end
myStruct = struct();
myStruct.Un = Un;
myStruct.Vdc = Vdc;
myStruct.P = P;
myStruct.Power = Power;
myStruct.eta = eta;
myStruct.nn = nn;
myStruct.cosfi = cosfi;
myStruct.mk = mk;
myStruct.Ikn = Ikn;
json_str = jsonencode(myStruct);
fid = fopen(fullfile(subPath, 'config.json'), 'w');
fprintf(fid, json_str);
fclose(fid);
err_file = fullfile(subPath, 'error.txt');

try
    Run_Healthy_Simulation;
catch err
    err_file_id = fopen(err_file, 'a');
    fprintf(err_file_id, [err.message, '\n']);
    fclose(err_file_id);
end
nturns_phase = round(Un / 4.44 / fb / kw / Bmax);
for fscnturns = 2:nturns_phase
    try
        Run_Short_Circuit_Simulation;
    catch err 
        err_file_id = fopen(err_file, 'a');
        fprintf(err_file_id, [err.message, '. fscnturns=', num2str(fscnturns), '\n']);
        fclose(err_file_id);
    end
end
for Nbars = 3:28
    max_nbroken = floor(Nbars/3);
    if max_nbroken >= Nbars/3
        continue;
    end
    for nbroken = 1:max_nbroken
        try
            Run_Broken_Rods_Simulation;
        catch err
            err_file_id = fopen(err_file, 'a');
            fprintf(err_file_id, [err.message, '. Nbars=', num2str(Nbars), ' nbroken=', num2str(nbroken), '\n']);
            fclose(err_file_id);
        end
    end
end