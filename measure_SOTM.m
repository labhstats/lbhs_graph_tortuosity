function SOTM_sum = measure_SOTM(links,im_dim,smoothing)
    
    
    num_links = length(links);
    
    Total_length = 0;
    SOTM_sum = 0;
    
    for i=1:num_links
        
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
        
        %%
        %Readying for Sum of Torsion Metric.
        
        link_length = 0;
        link_SOTM = 0;
        
        if num_points_in_link_i > 3
            
            initial_k = 2; %Procedure require a k-1 element.
            last_k = num_points_in_link_i - 2; %Procedure require a k+2 element with SOTM.
            
            %%
            %Denominator of SOAM.
            for k = initial_k:num_points_in_link_i
                
                p_k_m1  = [link_points_i_x(k-1),link_points_i_y(k-1),link_points_i_z(k-1)];
                p_k     = [link_points_i_x(k),link_points_i_y(k),link_points_i_z(k)];
                
                diff_p_k_p_k_m1 = p_k - p_k_m1;
                
                norm_diff_p_k = norm(diff_p_k_p_k_m1,2);
                
                link_length = link_length + norm_diff_p_k; %Corresponds to arc length.
                Total_length = Total_length + link_length; %Arc length of system.
            end
            
            %%
            %Nominator of SOAM
            for k = initial_k:last_k
                
                p_k_m1  = [link_points_i_x(k-1),link_points_i_y(k-1),link_points_i_z(k-1)];
                p_k     = [link_points_i_x(k),link_points_i_y(k),link_points_i_z(k)];
                p_k_p1  = [link_points_i_x(k+1),link_points_i_y(k+1),link_points_i_z(k+1)];
                p_k_p2  = [link_points_i_x(k+2),link_points_i_y(k+2),link_points_i_z(k+2)];
                
                T1 = p_k - p_k_m1;
                T2 = p_k_p1 - p_k;
                T3 = p_k_p2 - p_k_p1;
                
                %Catching non-zero vector product and division (0/0), which produces NaNs.
                cross_T1_T2 = cross(T1,T2);
                
                if isequal(cross_T1_T2,[0,0,0])
                    %Do nothing.
                else
                    cross_T1_T2 = cross(T1,T2)/norm(cross(T1,T2));
                end
                
                %Catching non-zero vector product and division (0/0), which produces NaNs.
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
                %Therefore the span of T1, T2 and T3 must be 3D (i.e. rank = 3) for torsion
                %to be non-zero.
                if rank_matrix_T1T2T3 == 3
                    SOTM_k = abs(safeAcos(T1T2T2T3_dot));
                else
                    SOTM_k = 0;
                end
                
                if isnan(SOTM_k)
                   disp('-------------------------------- SOTM NAN!') 
                end
                
                link_SOTM = link_SOTM + SOTM_k;
            end
        else
            disp('Small segment skipped... [SOTM]')
            %Segment too small to calculate any SOTM. So we do nothing.
            link_SOTM = 0;
            link_length = 1;
        end
        
        SOTM_sum = SOTM_sum + link_SOTM/link_length;
        
    end
    
    if isnan(SOTM_sum)
       disp('-------------------------------- SOTM SUM PRE NAN!') 
    end
    
    if num_links == 1
        %Do nothing. i.e. no correction for multiple segments/links.
    else
        SOTM_sum = SOTM_sum/Total_length;
        
        if isnan(SOTM_sum)
            disp('-------------------------------- SOTM SUM POST NAN!') 
        end
    end
    
end