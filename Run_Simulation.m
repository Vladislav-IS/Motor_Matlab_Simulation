subPath = fullfile(basePath, [motor_name, ' Un-', num2str(Un)]);
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

err_file = fullfile(subPath, 'error.txt');

try
    Run_Healthy_Simulation;
catch err
    err_file_id = fopen(err_file, 'a');
    fprintf(err_file_id, [err.message, '\n']);
    fclose(err_file_id);
end
Save_Json_File;
nturns_phase = round(Un / 4.44 / fb / kw / Bmax);
for fscnturns = 1:5
    try
        Run_Short_Circuit_Simulation;
    catch err 
        err_file_id = fopen(err_file, 'a');
        fprintf(err_file_id, [err.message, '. fscnturns=', num2str(fscnturns), '\n']);
        fclose(err_file_id);
    end
end
out_Nbars = Suggest_z2(Power / 1000, nn, P, fb);
for Nbars = out_Nbars.candidates
    max_nbroken = min(3, floor(Nbars/3));
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