function output_array = tortuosity_wrapper(graph_mat_dir)
    %%Script to wrap all tortuosity operations by loading the already
    %%graphed vascularities.
    
    % Example path:
    % '/home/lars/Desktop/thr_graph_testing/run_environment/*/3D_TOF/graph3D_of_skeleton.mat'
    
    %%
    % Initializing.
    all_files = dir(graph_mat_dir);
    
    n_files = length(all_files);
    
    disp(['The number of files are: ' num2str(n_files)]);
    
    output_array = zeros(n_files,5);
    
    for i = 1:n_files
        disp('------------');
        
        %%
        % Extract current ID.
        split_id_string = split(all_files(i).folder,"/");
        cell_id_string = split_id_string(end-1,1); %Specifically chosen/hardcoded wrt BIDS.
        current_ID_string_iter = cell_id_string{1}; %To be paired or "fullfiled" with manual_dir.
        disp(['The current ID is: ' current_ID_string_iter]);
        disp(['Number: ' string(i) ' of ' string(n_files)]);
        
        %%
        % Complete path.
        full_file_path = fullfile(all_files(i).folder,all_files(i).name);
        disp(['Full path is: ' full_file_path])
        
        %%
        % Loading necessary files stored from the graphing protocol.
        load(full_file_path,'link_i','node_i','T_size');
        
        %%
        % Handling exceptions and calculating if everything is ok.
        check_link = exist('link_i','var');
        check_node = exist('node_i','var');
        both_nl = (check_link && check_node);
        
        disp(['Original image dimensions: ' num2str(T_size(1)) ' x ' num2str(T_size(2)) ' x ' num2str(T_size(3))])
        
        DM_current = -1;
        Arc_current = -1;
        SOAM_current = -1;
        SOTM_current = -1;
        
        if both_nl
            disp('Calculating tortuosities.')
            [DM_current,Arc_current] = measure_DM(link_i,node_i,T_size,0); %No smoothing.
            SOAM_current = measure_SOAM(link_i,T_size,1); %To be smoothed.
            SOTM_current = measure_SOTM(link_i,T_size,1); %To be smoothed.
        else
            disp('The link and/or nodes did not exist, or did not load properly.')
        end
        
        %%
        % Cleaning up.
        clear link_i
        clear node_i
        clear T_size
        
        %%
        % Collecting for output.
        output_array(i,1) = str2double(current_ID_string_iter);
        output_array(i,2) = DM_current;
        output_array(i,3) = SOAM_current;
        output_array(i,4) = SOTM_current;
        output_array(i,5) = Arc_current;
        
    end
    
    
end