function y_status = alpha_graphing_protocol_3(working_BIDS_dir)
    
    %y_status = 0;
    
    %%
    % Get the files' location.
    all_files = dir(working_BIDS_dir);    
    % Example path: (!!!skull stripped TOF image!!!)
    % '/home/lars/Desktop/thr_graph_testing/run_environment/*/3D_TOF/3d_tof_brain.nii.gz'
    
    n_files = length(all_files);
    
    disp(n_files);
    
    %%
    % Constants and filenames.
    kernel_sphere_radi = 2; %Erosion filter. No higher, or just remove.
    
    percentile_raw_info = 95; %0-100 percentile thresholding.
    
    minimum_voxel_size_object = 2500;
    
    step_size_seq_1_100 = 0.5; %Max 100. Smaller values increase computation time.
    
    minimum_graph_length = 9;
    
    image_skullstrip_3D_tof_path = '3d_tof_brain_N4.nii.gz'; %Expected input filename
    
    %To be used when sform is somehow (ANTs) removed from our data.
    image_skullstrip_sform_meta_path = '3d_tof_brain.nii.gz'; %Meta information with sform, since N4 in ants removes sform.
    
    image_binarized_ss_3D_tof_path = '3d_tof_brain_cs_gauss07_binada_ero2_rem5000_dil2_fill';
    image_skeletonized_ss_3D_tof_path = '3d_tof_brain_skeletonized';
    
    node_image_path = 'node_only_image';
    
    save_object_base_path = 'graph3D_of_skeleton.mat';
    %%
    % Cell array for storing information.
    %save_cell = cell(n_files,4);
    
    %%
    % Iterate either with for or parfor, depending.
    
    for i = 1:n_files
        disp('------------');
        
        %%
        %Extract current ID.
        split_id_string = split(all_files(i).folder,"/");
        cell_id_string = split_id_string(end-1,1); %Specifically chosen/hardcoded!
        current_ID_string = cell_id_string{1}; %To be paired or "fullfiled" with manual_dir.
        disp(['The current ID is: ' current_ID_string]);
        disp(['Number: ' string(i) ' of ' string(n_files)]);
        
        %%
        % Load in skullstripped 3D TOF image and its meta information.
        disp('Loading NIFTI image and header information...')
        ss_3D_TOF_path_i = string(fullfile(all_files(i).folder,image_skullstrip_3D_tof_path));
        disp(ss_3D_TOF_path_i)
        
        ss_3D_TOF_image_i = niftiread(ss_3D_TOF_path_i);
        
        ss_3D_TOF_meta_path_i = string(fullfile(all_files(i).folder,image_skullstrip_sform_meta_path));
        disp(ss_3D_TOF_meta_path_i)
        ss_3D_TOF_meta_i = niftiinfo(ss_3D_TOF_meta_path_i);
        
        whos ss_3D_TOF_image_i
        whos ss_3D_TOF_meta_i
        
        %%
        % Binarizing, general built in adaptive thresholding by MatLab.
        disp('Initial thresholding #1...')
        ss_3D_TOF_image_binary_i = imbinarize(ss_3D_TOF_image_i,'adaptive');
        
        whos ss_3D_TOF_image_binary_i
        
        %%
        % Naive thresholding (require normalization).
        disp('Initial thresholding #2...')
        ss_3D_TOF_image_binary_i(ss_3D_TOF_image_i < prctile(ss_3D_TOF_image_i(:),percentile_raw_info)) = 0; %Possible to tune percentile 0-100 - Better
        
        %%
        % Binarizing, adaptive thresholding by matrix. (Possibly weakest
        % link due to midpoint dependence...)
        
        T_local_array = ss_3D_TOF_image_i;
        T_local_array(:,:,:) = 0; %Zeroing out.
        
        T_size = size(T_local_array);
        
        T_centerpont = round(T_size/2); %Coordinates has to be exact to exist.
        
        ss_3D_TOF_image_i_sorted_vector = sort(ss_3D_TOF_image_i(:),'ascend');
        length_sorted_vector = length(ss_3D_TOF_image_i_sorted_vector);
        
        %Specifying local thresholds, ball (3D gradient) shape.
        disp('Starting large loop for creating ball filter...')
        for x_it = 1:T_size(1)
            
            for y_it = 1:T_size(2)
                
                for z_it = 1:T_size(3)
                    xyz_it = [x_it y_it z_it];
                    
                    current_distance = norm(xyz_it - T_centerpont);
                    
                    prc_xyz_it = 1-2/(exp(0.006*current_distance)+1); %tanh(x) with modified slope. Smaller than 0.025, 0.010, and no smaller 0.005.
                    %0.006 ok? Fit to data sized 696 768 232 and centered.
                    
                    vector_xyz = round(length_sorted_vector*(prc_xyz_it),0);
                    vector_xyz = min(vector_xyz,length_sorted_vector);
                    vector_xyz = max(vector_xyz,1);
                    
                    T_local_array(x_it,y_it,z_it) = ss_3D_TOF_image_i_sorted_vector(vector_xyz);
                end
                
            end
            
        end
        disp('Ending large loop...')
        
        ss_3D_TOF_image_binary_i_local = imbinarize(ss_3D_TOF_image_i,T_local_array);
        
        ss_3D_TOF_image_binary_i = immultiply(ss_3D_TOF_image_binary_i,ss_3D_TOF_image_binary_i_local);
        
        disp('Finished with ball filtering...')
        
        %%
        % Erode, crude but important
        disp('Eroding...')
        se_ball11 = strel('sphere',kernel_sphere_radi);
        ss_3D_TOF_image_binary_i = imerode(ss_3D_TOF_image_binary_i,se_ball11);
        
        %%
        % Remove small objects
        ss_3D_TOF_image_binary_i = bwareaopen(ss_3D_TOF_image_binary_i,minimum_voxel_size_object); %Possible to tune smallest object.
        %Does not make sense to increase without detaching noise from main
        %vasculature.
        
        %%
        % Fill gaps for voxels that are surrounded by all 6 voxels.
        disp('Filling...')
        ss_3D_TOF_image_binary_i = bwmorph3(ss_3D_TOF_image_binary_i,'fill'); %Only after R2018a
        
        %%
        %Attempt to add parts that were removed. 
        %(This part assumes that the image has little to no noise at all. 
        % Because if not, then the 100 percentiles will take larger steps than with a cleaned up distribution.)
        
        disp('Mending broken connectivities...')
        
        re_raw_ss_3D_TOF_image_i = immultiply(ss_3D_TOF_image_i,ss_3D_TOF_image_binary_i);
        
        %Remove zeros, for a clean histogram with relevant values.
        re_raw_ss_3D_TOF_vector_i = re_raw_ss_3D_TOF_image_i(:);
        re_raw_ss_3D_TOF_vector_i = re_raw_ss_3D_TOF_vector_i(re_raw_ss_3D_TOF_vector_i ~= 0);
        
        prc_max = 100;
        prc_min = 1;
        
        seq_prc = prc_min:step_size_seq_1_100:prc_max;
        n_seq_prc = length(seq_prc);
        
        lower_intensity_vasc = prctile(re_raw_ss_3D_TOF_vector_i,seq_prc); %This is the operation of importance.
        
        store_conn_num = zeros(1,n_seq_prc);
        store_intensity = zeros(1,n_seq_prc);
        
        for j = 1:n_seq_prc
            test_image = ss_3D_TOF_image_binary_i;
            
            current_intensity = lower_intensity_vasc(j);
            test_image(ss_3D_TOF_image_i > current_intensity) = 1;
            
            test_image = bwareaopen(test_image,minimum_voxel_size_object);
            
            conn_obj = bwconncomp(test_image,6);
            
            store_conn_num(j) = conn_obj.NumObjects;
            
            store_intensity(j) = current_intensity;
        end
        
        %Apply (circa) optimum threshold.
        minimum_objects = min(store_conn_num);
        
        use_intensity = min(store_intensity(store_conn_num == minimum_objects)); %Must be "min" or else it can omit certain connections.
        
        ss_3D_TOF_image_binary_i(ss_3D_TOF_image_i >= use_intensity) = 1;
        ss_3D_TOF_image_binary_i(ss_3D_TOF_image_i < use_intensity) = 0;
        
        %Remove small objects again.
        ss_3D_TOF_image_binary_i = bwareaopen(ss_3D_TOF_image_binary_i,minimum_voxel_size_object); %Possible to tune smallest object.
        
        %%
        % Convert to proper class to match meta-info-header. 
        % (A step such as this is repeated later as well without notice.)
        
        ss_3D_TOF_image_single_i = im2single(ss_3D_TOF_image_binary_i);
        
        whos ss_3D_TOF_image_cs_gauss_binary_i
        
        %%
        % Write "fixed" binary map.
        disp('Last part...')
        
        ith_ss_3D_TOF_image_bin_output_fullfile = string(fullfile(all_files(i).folder,image_binarized_ss_3D_tof_path));
        disp(ith_ss_3D_TOF_image_bin_output_fullfile);
        
        disp('Saving binary image...')
        niftiwrite(ss_3D_TOF_image_single_i,ith_ss_3D_TOF_image_bin_output_fullfile,ss_3D_TOF_meta_i);
        
        %%
        % Skeletonize and write it.
        disp('Skeletonising...')
        ss_3D_TOF_skeleton_i = bwskel(ss_3D_TOF_image_binary_i,'MinBranchLength',minimum_graph_length); %Only after R2018a
        
        ss_3D_TOF_skeleton_single_i = im2single(ss_3D_TOF_skeleton_i);
        
        ith_ss_3D_TOF_skeleton_single_output_fullfile = string(fullfile(all_files(i).folder,image_skeletonized_ss_3D_tof_path));
        disp(ith_ss_3D_TOF_skeleton_single_output_fullfile);
        
        disp('Saving skeletonised image...')
        niftiwrite(ss_3D_TOF_skeleton_single_i,ith_ss_3D_TOF_skeleton_single_output_fullfile,ss_3D_TOF_meta_i);
        
        %%
        % SKEL2GRAPH3D (skel,THR)
        disp('Graphing...')
        [A_i,node_i,link_i] = Skel2Graph3D(ss_3D_TOF_skeleton_i,minimum_graph_length); %#ok<ASGLU>
        
        disp('Saving graph structure as .mat file, assumes BIDS...')
        save_object_path_i = string(fullfile(all_files(i).folder,save_object_base_path));
        save(save_object_path_i,'current_ID_string','A_i','node_i','link_i','T_size');
        
        %%
        % Write a node plot. For testing purposes only.
        disp('Ready and write node plot for visual purposes...')
        
        node_image_i = ss_3D_TOF_image_binary_i;
        node_image_i(:,:,:) = 0;
        
        for j = 1:length(node_i)
            
            node_comx = round(node_i(j).comx);
            node_comy = round(node_i(j).comy);
            node_comz = round(node_i(j).comz);
            
            node_image_i(node_comx,node_comy,node_comz) = 1;
        end
        
        se_extra_cube = strel('cube',5);
        node_image_i = imdilate(node_image_i,se_extra_cube);
        
        node_image_single_i = im2single(node_image_i);
        
        node_image_single_i_output_full_file = string(fullfile(all_files(i).folder,node_image_path));
        disp(node_image_single_i_output_full_file);
        
        disp('Saving node image...')
        niftiwrite(node_image_single_i,node_image_single_i_output_full_file,ss_3D_TOF_meta_i);
    end
    
    disp('Everything is finished...')
    y_status = 1;
end