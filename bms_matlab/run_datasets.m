function [] = run_datasets(starts,ends,condition,num_evals,spm_path)

    starts = str2num(starts);
    ends = str2num(ends);
    num_evals = str2num(num_evals);
    
    dataset_folder = "bic_datasets";
    file_name_spec = "%s_bic_%d_%d.csv";
    
    warning('off','all')
    wanted_files = [];
    
    addpath(spm_path);
    
    for i=starts:1:ends
        filename= sprintf(file_name_spec, condition, num_evals, i);
        wanted_files = [wanted_files, filename];
    end
    
    count = 1;
    
    for i=1:1:size(wanted_files,2)
        file = wanted_files(i);
        full_file = sprintf("%s/%s",dataset_folder, file);
        select_scarcity_models(full_file, condition);
        count = count + 1;
    end
end