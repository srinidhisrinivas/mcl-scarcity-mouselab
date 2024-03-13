function [] = select_scarcity_models(filename, condition)
    warning('off','all')
    output = struct;

    file_split = split(filename, '/');
    file_name_split = split(file_split(end), ".");
    save_file_name_spec = "comp_results/%s.xml";
    save_file_name = sprintf(save_file_name_spec, file_name_split(1));

    % Read bic table
    bicall_orig = readtable(filename);
    bicall = table2array(bicall_orig(1:end,2:end));

    % Get model names
    mc = bicall_orig.Properties.VariableNames(2:end);
    models = strings(size(mc));
    [models{:}] = mc{:};

    % Individual model selection
    BMS_results = struct;
    [alpha,exp_r,xp,pxp,bor] = spm_BMS(bicall);
    
    BMS_results.exp_r = exp_r;
    BMS_results.xp = xp;
    BMS_results.models = models;
    
    output.bms = BMS_results;

    % Defining models based on their features (for division into families)
    model_features = [0 0 0 0 0 0 ;
        0 1 0 0 0 0 ;
        0 0 0 0 1 0 ;
        0 0 1 1 0 0 ;
        0 1 0 2 0 0 ;
        0 0 0 2 0 0 ;
        0 0 0 1 0 0 ;
        1 0 0 0 0 0 ;
        1 1 0 0 0 0 ;
        1 0 0 0 1 0 ;
        1 0 1 1 0 0 ;
        1 1 0 2 0 0 ;
        1 0 0 2 0 0 ;
        1 0 0 1 0 0 ;
        0 0 0 0 0 1 ;
        0 1 0 0 0 1 ;
        0 0 0 0 1 1 ;
        0 0 1 1 0 1 ;
        0 1 0 2 0 1 ;
        0 0 0 2 0 1 ;
        0 0 0 1 0 1 ;
        1 0 0 0 0 1 ;
        1 1 0 0 0 1 ;
        1 0 0 0 1 1 ;
        1 0 1 1 0 1 ;
        1 1 0 2 0 1 ;
        1 0 0 2 0 1 ;
        1 0 0 1 0 1 ;
    ];
    
    % Family comparison #1 - Fixing of initial weights
    data = struct;
    relevant_feature_idx = 1;
    family_names = {"No Fix", "Fix"};
        
    data.partition = create_binary_partition(models, model_features, relevant_feature_idx);
    data.names = family_names;
    data.infer = "RFX";
    
    [family, model] = spm_compare_families(bicall, data);
    
    comp_1 = struct;
    comp_1.names = [family_names{:}];
    comp_1.exp_r = family.exp_r;
    comp_1.xp = family.xp;
    output.comp_1 = comp_1;
    
    
    % Family comparison #2 - Unrewarded as zero
    data = struct;
    relevant_feature_idx = 2;
    family_names = {"None", "Zero"};
        
    data.partition = create_binary_partition(models, model_features, relevant_feature_idx);
    data.names = family_names;
    data.infer = "RFX";
    
    [family, model] = spm_compare_families(bicall, data);
    
    comp_2 = struct;
    comp_2.names = [family_names{:}];
    comp_2.exp_r = family.exp_r;
    comp_2.xp = family.xp;
    output.comp_2 = comp_2;
    
    % Family comparison #3 - Use OL Reward
    data = struct;
    relevant_feature_idx = 3;
    family_names = {"Use OL", "Ignore OL"};
        
    data.partition = create_binary_partition(models, model_features, relevant_feature_idx);
    data.names = family_names;
    data.infer = "RFX";
    
    [family, model] = spm_compare_families(bicall, data);
    
    comp_3 = struct;
    comp_3.names = [family_names{:}];
    comp_3.exp_r = family.exp_r;
    comp_3.xp = family.xp;
    output.comp_3 = comp_3;
    
    % Family comparison #4 - Use Pseudo reward
    data = struct;
    relevant_feature_idx = 6;
    family_names = {"No PR", "PR"};
        
    data.partition = create_binary_partition(models, model_features, relevant_feature_idx);
    data.names = family_names;
    data.infer = "RFX";
    
    [family, model] = spm_compare_families(bicall, data);
    
    comp_4 = struct;
    comp_4.names = [family_names{:}];
    comp_4.exp_r = family.exp_r;
    comp_4.xp = family.xp;
    output.comp_4 = comp_4;
    
    % Family comparison #5 - Whether expected score is used
    data = struct;
    relevant_feature_idx = 4;
    family_names = {"No ES", "ES"};

    partition = zeros(size(models));
    if strcmp(condition, "control") == 1
        for i=1:1:size(models,2)
            % If it never uses expected reward (i.e., only OL reward)
            if model_features(i,4) == 0
                partition(i) = 1;
            elseif model_features(i,3) == 1
                % Only expected rewarded
                partition(i) = 2;
            elseif model_features(i,4) == 1
                % Expected reward only when OL absent
                partition(i) = 1;
            elseif model_features(i,4) == 2
                % Combination of Expected Reward even when OL present
                partition(i) = 2;
            end
        end
    else
        partition = create_binary_partition(models, model_features, relevant_feature_idx);
    end
        
    data.partition = partition;
    data.names = family_names;
    data.infer = "RFX";
    
    [family, model] = spm_compare_families(bicall, data);
    
    comp_5 = struct;
    comp_5.names = [family_names{:}];
    comp_5.exp_r = family.exp_r;
    comp_5.xp = family.xp;
    output.comp_5 = comp_5;
    
    % Family comparison #6 - exclusive use of each signal
    data = struct;
    family_names = {"Only OL", "Only ER", "Both"};
    
    partition = zeros(size(models));
    for i=1:1:size(models,2)
        % If it never uses expected reward (i.e., only OL reward)
        if model_features(i,4) == 0
            partition(i) = 1;
        elseif model_features(i,3) == 1
            % Only expected rewarded
            partition(i) = 2;
        else
            % Some combination of both
            partition(i) = 3;
        end
    end

    data.partition = partition;
    data.names = family_names;
    data.infer = "RFX";
    
    [family, model] = spm_compare_families(bicall, data);
    
    comp_6 = struct;
    comp_6.names = [family_names{:}];
    comp_6.exp_r = family.exp_r;
    comp_6.xp = family.xp;
    output.comp_6 = comp_6;

    % Family comparison #7 - How do people use the expected reward?
    data = struct;
    family_names = {};
    partition = zeros(size(models));
    if strcmp(condition, "control") == 1
        for i=1:1:size(models,2)
            % If it never uses expected reward (i.e., only OL reward)
            if model_features(i,4) == 0
                partition(i) = 1;
            elseif model_features(i,3) == 1
                % Only expected rewarded
                partition(i) = 2;
            elseif model_features(i,4) == 1
              
                % OL never absent in control condition, so behaves like model
                % that always uses OL
                partition(i) = 1;
            elseif model_features(i,4) == 2
              
                % Control condition has only 3 partitions
                partition(i) = 3;
        
            end
        end
        family_names = {"Only OL", "Only ER", "Some ER Always"};
    else
        for i=1:1:size(models,2)
            % If it never uses expected reward (i.e., only OL reward)
            if model_features(i,4) == 0
                partition(i) = 1;
            elseif model_features(i,3) == 1
                % Only expected rewarded
                partition(i) = 2;
            elseif model_features(i,4) == 1
                % Expected reward only when OL absent
                partition(i) = 3;
        
            elseif model_features(i,4) == 2
                % Combination of Expected Reward even when OL present
                partition(i) = 4;
                
            end
        end
        family_names = {"Only OL", "Only ER", "ER only when no OL", "Some ER Always"};
    end
    
    data.partition = partition;
    data.names = family_names;
    data.infer = "RFX";
    
    [family, model] = spm_compare_families(bicall, data);
    
    comp_7 = struct;
    comp_7.names = [family_names{:}];
    comp_7.exp_r = family.exp_r;
    comp_7.xp = family.xp;
    output.comp_7 = comp_7;

    % Save the data for this analysis into an xml file
    writestruct(output, save_file_name)   
end

function partition = create_binary_partition(models, model_features, relevant_feature_idx)
partition = zeros(size(models));
for i = 1:1:size(models,2)
    if model_features(i,relevant_feature_idx) > 0
        partition(i) = 2;
    else
        partition(i) = 1;
    end
end
end
