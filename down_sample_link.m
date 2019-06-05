function [rep_x,rep_y,rep_z]= down_sample_link(points_x,points_y,points_z,sample_rate_manual)
    %%Script to resample the 3D points for accurate measurements. Because
    %%there was an inherent issue using the the raw graph based on a
    %%skeleton with at least 1 or 2 connections in a 26-connectivity per voxel.
    
    sample_rate = sample_rate_manual; %This is used in a modulo operation to select each n'th point.
    
    n_x = length(points_x);
    
    vec_size = floor(n_x/sample_rate) + 2; %This is not correct for any "n_x" and "sample_rate".
    
    rep_x = zeros(1,vec_size);
    rep_y = zeros(1,vec_size);
    rep_z = zeros(1,vec_size);
    
    j = 1;
    for i=1:n_x
        
        if mod(i,sample_rate) == 0
            rep_x(j) = points_x(i);
            rep_y(j) = points_y(i);
            rep_z(j) = points_z(i);
            j = j + 1;
        elseif i == 1
            rep_x(j) = points_x(i);
            rep_y(j) = points_y(i);
            rep_z(j) = points_z(i);
            j = j + 1;
        elseif i == n_x
            rep_x(j) = points_x(i);
            rep_y(j) = points_y(i);
            rep_z(j) = points_z(i);
            j = j + 1;
        else
           %Skip. 
        end
        
        
    end
    
    
end