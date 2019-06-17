function [DM_sum,Total_path_length] = measure_DM(links,nodes,im_dim,smoothing)
    %%Function that only calculates Distance Metric (DM) and also returns
    %%the total path/arc length of the segment/system.
    
    num_links = length(links);
    
    Total_euclidian_length = 0;
    Total_path_length = 0;
    DM_sum = 0;
    
    for i=1:num_links
        
        %%
        % Retrieving centerpoints. (Assume raw data from Skel2Graph3D.m)
        % (Kollmannsberger 2017)
        
        node_1 = links(i).n1;
        node_2 = links(i).n2;
        
        comx_1 = nodes(node_1).comx;
        comy_1 = nodes(node_1).comy;
        comz_1 = nodes(node_1).comz;
        
        comx_2 = nodes(node_2).comx;
        comy_2 = nodes(node_2).comy;
        comz_2 = nodes(node_2).comz;
        
        point_xyz_1 = [comx_1,comy_1,comz_1];
        point_xyz_2 = [comx_2,comy_2,comz_2];
        
        %%
        % Retrieving link points. (Assume raw data from Skel2Graph3D.m)
        % (Kollmannsberger 2017)
        
        link_points_i = links(i).point;
        
        [link_points_i_x,link_points_i_y,link_points_i_z] = ind2sub(im_dim,link_points_i);
        
        if smoothing == 1
            link_points_i_x = smoothdata(link_points_i_x,'rloess');
            link_points_i_y = smoothdata(link_points_i_y,'rloess');
            link_points_i_z = smoothdata(link_points_i_z,'rloess');
        end
        
        
        num_points_in_link_i = length(link_points_i_x); %Assume equal length of x,y and z.
        
        voxel_path_i = 0;
        
        for k = 2:num_points_in_link_i
                
                p_k_m1  = [link_points_i_x(k-1),link_points_i_y(k-1),link_points_i_z(k-1)];
                p_k     = [link_points_i_x(k),link_points_i_y(k),link_points_i_z(k)];
                
                diff_p_k_p_k_m1 = p_k - p_k_m1;
                
                norm_diff_p_k = norm(diff_p_k_p_k_m1,2);
                
                voxel_path_i = voxel_path_i + norm_diff_p_k;
        end
        
        Total_path_length = Total_path_length + voxel_path_i;
        DM_sum = DM_sum + voxel_path_i;
        
        %Default 2-norm.
        euclidian_path_i = norm(point_xyz_1 - point_xyz_2,2); 
        
        Total_euclidian_length = Total_euclidian_length + euclidian_path_i;
        
    end
    
    DM_sum = DM_sum/Total_euclidian_length; %This correction is valid for any number of links.
end