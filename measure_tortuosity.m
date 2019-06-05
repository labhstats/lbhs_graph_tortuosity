function [global_DM,global_SOAM_IP,global_SOAM_TP,global_length] = measure_tortuosity(A_i,link_i,node_i,im_dim,sampling_rate_manual)
    %%Function to calculate Distance Measure (DM) and Sum of Angles metric (SOAM).
    
    num_links = length(link_i);
%     disp('Num links:')
%     disp(num_links);
    
    global_voxel_path = 0;
    global_euclidian_path = 0;
    
    global_SOAM_IP = 0;
    global_SOAM_TP = 0;
    
    %Iterate over all links.
    for i=1:num_links
        
        %%
        % Retrieving centerpoints. (Assume raw data from Skel2Graph3D.m)
        % (Kollmannsberger 2017)
        
        node_1 = link_i(i).n1;
        node_2 = link_i(i).n2;
        
        comx_1 = node_i(node_1).comx;
        comy_1 = node_i(node_1).comy;
        comz_1 = node_i(node_1).comz;
        
        comx_2 = node_i(node_2).comx;
        comy_2 = node_i(node_2).comy;
        comz_2 = node_i(node_2).comz;
        
        point_xyz_1 = [comx_1,comy_1,comz_1];
        point_xyz_2 = [comx_2,comy_2,comz_2];
        
        %%
        % Retrieving link points. (Assume raw data from Skel2Graph3D.m)
        % (Kollmannsberger 2017)
        
        link_points_i = link_i(i).point;
        
        [link_points_i_x,link_points_i_y,link_points_i_z] = ind2sub(im_dim,link_points_i);
        
        %Resampling link points --- comment out if problematic.
        [link_points_i_x,link_points_i_y,link_points_i_z] = down_sample_link(link_points_i_x,link_points_i_y,link_points_i_z,sampling_rate_manual);
        
        num_points_in_link_i = length(link_points_i_x); %Assume equal length of x,y and z.
        
        %%
        % DM measurement (accumulating for global measurement).
        % Combine by summating the denominator and nominator separately and
        % calculate ratio in the end. (Bullitt 2003)
        
        %voxel_path_i = A_i(node_1,node_2); %Inaccurate A from Skel2Graph3D...
        
        voxel_path_i = 0;
        
        for k = 2:num_points_in_link_i
                
                p_k_m1  = [link_points_i_x(k-1),link_points_i_y(k-1),link_points_i_z(k-1)];
                p_k     = [link_points_i_x(k),link_points_i_y(k),link_points_i_z(k)];
                
                diff_p_k_p_k_m1 = p_k - p_k_m1;
                
                norm_diff_p_k = norm(diff_p_k_p_k_m1);
                
                voxel_path_i = voxel_path_i + norm_diff_p_k;
        end
        
        global_voxel_path = global_voxel_path + voxel_path_i;
        
        %Default 2-norm.
        euclidian_path_i = norm(point_xyz_1 - point_xyz_2); 
        
        global_euclidian_path = global_euclidian_path + euclidian_path_i;
        
        %%
        % SOAM measurement (accumulating for global measurement).
        % Combine by summation. (Bullitt 2003)
        
        local_accumulate_norm_pk = 0;
        local_accumulate_IP_k = 0;
        local_accumulate_TP_k = 0;
        
        if num_points_in_link_i > 3
            
            initial_k = 2; %Procedure require a k-1 element.
            last_k = num_points_in_link_i - 2; %Procedure require a k+2 element.
            
            %Denominator of SOAM.
            for k = initial_k:num_points_in_link_i
                
                p_k_m1  = [link_points_i_x(k-1),link_points_i_y(k-1),link_points_i_z(k-1)];
                p_k     = [link_points_i_x(k),link_points_i_y(k),link_points_i_z(k)];
                
                diff_p_k_p_k_m1 = p_k - p_k_m1;
                
                norm_diff_p_k = norm(diff_p_k_p_k_m1);
                
                local_accumulate_norm_pk = local_accumulate_norm_pk + norm_diff_p_k;
            end
            
            %CP_k
            for k = initial_k:last_k
                
                p_k_m1  = [link_points_i_x(k-1),link_points_i_y(k-1),link_points_i_z(k-1)];
                p_k     = [link_points_i_x(k),link_points_i_y(k),link_points_i_z(k)];
                p_k_p1  = [link_points_i_x(k+1),link_points_i_y(k+1),link_points_i_z(k+1)];
                p_k_p2  = [link_points_i_x(k+2),link_points_i_y(k+2),link_points_i_z(k+2)];
                
                T1 = p_k - p_k_m1;
                T2 = p_k_p1 - p_k;
                T3 = p_k_p2 - p_k_p1;
                
                %T1_rev = p_k_m1 - p_k;
                
                %cos(angle)|v1||v2| = dot(v1,v2)
                norm_T1 = T1/norm(T1);
                %norm_T1 = T1_rev/norm(T1_rev);
                norm_T2 = T2/norm(T2);
                dot_prod_T1_T2 = dot(norm_T1,norm_T2);
                
                matrix_T1T2 = [T1;T2];
                rank_matrix_T1T2 = rank(matrix_T1T2);
                
                %Curvature measure the failure of a curve to be a line.
                %Therefore the span of T1 and T2 must be in a plane to be
                %non-zero.
                if rank_matrix_T1T2 == 2
                    %IP_k = pi - safeAcos(dot_prod_T1_T2);
                    IP_k = abs(safeAcos(dot_prod_T1_T2)*180/pi);
                else
                    IP_k = 0;
                end
                

                %%
                %Ensuring non-zero vector product and division (0/0), which produces NaNs.
                cross_T1_T2 = cross(T1,T2);
                
                if isequal(cross_T1_T2,[0,0,0])
                    %Do nothing.
                else
                    cross_T1_T2 = cross(T1,T2)/norm(cross(T1,T2));
                end
                
                if isnan(cross_T1_T2)
                    disp('Failure at SOAM cross_T2_T3.')
                end
                
                %%
                % Sine based angle - double check.
                %IP_k_sine = asin(cross_T1_T2/(norm_T1*norm_T2));
                
                
                
                %%
                %Ensuring non-zero vector product and division (0/0), which produces NaNs.
                cross_T2_T3 = cross(T2,T3);
                
                if isequal(cross_T2_T3,[0,0,0])
                    %Do nothing.
                else
                    cross_T2_T3 = cross(T2,T3)/norm(cross(T2,T3)); 
                end
                
                T1T2T2T3_dot = dot(cross_T1_T2,cross_T2_T3);
                
                %Special case where TP_k is 180 degrees.
                if T1T2T2T3_dot < -1 + eps
                    T1T2T2T3_dot = 1;
                end
                
                matrix_T1T2T3 = [T1;T2;T3];
                rank_matrix_T1T2T3 = rank(matrix_T1T2T3);
                
                %Torsion measures the failure of a curve to be planar.
                %Therefore the span of T1, T2 and T3 must be 3D for torsion
                %to be non-zero. 
                if rank_matrix_T1T2T3 == 3
                    TP_k = abs(safeAcos(T1T2T2T3_dot)*180/pi);
                else
                    TP_k = 0;
                end
                
                
                %%These are obviously radians in [0,pi] (scalars), so why
                %%cross product in original formula? Raw code just uses dot
                %%product.
                
                local_accumulate_IP_k = local_accumulate_IP_k + IP_k;
                local_accumulate_TP_k = local_accumulate_TP_k + TP_k;
            end
            
            link_IP_soam_i = sum(local_accumulate_IP_k)/sum(local_accumulate_norm_pk);
            link_TP_soam_i = sum(local_accumulate_TP_k)/sum(local_accumulate_norm_pk);
            
            global_SOAM_IP = global_SOAM_IP + link_IP_soam_i;
            global_SOAM_TP = global_SOAM_TP + link_TP_soam_i;
        else
            disp('Small segment skipped...')
            %Segment too small to calculate any SOAM. So we do nothing.
        end
        
        
    end
    
    %%
    % Finalizing global measurments of DM and SOAM.
    
    global_DM = global_voxel_path/global_euclidian_path;
    
    if num_links == 1
        disp('No global SOAM (IP/TP) correction applied...')
        %Do not apply global estimate correction.
    else
        global_SOAM_IP = global_SOAM_IP/global_voxel_path;
        global_SOAM_TP = global_SOAM_TP/global_voxel_path;
    end
    
    global_length = global_voxel_path;
    
    disp('Finished with tortuosity measurements...')
end