function SOAM_sum = measure_SOAM(links,im_dim,smoothing)
    %%Function that only calculates the Sum of angles metric.
    
    num_links = length(links);
    
    Total_length = 0;
    SOAM_sum = 0;
    
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
        % SOAM measurement (accumulating for global measurement).
        % Combine by summation. (Bullitt 2003)
        
        link_length = 0;
        link_SOAM = 0;
        
        if num_points_in_link_i > 3
            
            initial_k = 2; %Procedure require a k-1 element.
            last_k = num_points_in_link_i - 1; %Procedure require a k+1 element with SOAM.
            
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
                
                T1 = p_k - p_k_m1;
                T2 = p_k_p1 - p_k;
                
                %cos(angle)|v1||v2| = dot(v1,v2)
                norm_T1 = T1/norm(T1,2);
                norm_T2 = T2/norm(T2,2);
                dot_prod_T1_T2 = dot(norm_T1,norm_T2);
                
                %Curvature measure the failure of a curve to be a line.
                %Therefore the span of T1 and T2 must be a plane to be
                %non-zero.
                matrix_T1T2 = [T1;T2];
                rank_matrix_T1T2 = rank(matrix_T1T2);
                
                if rank_matrix_T1T2 == 2
                    %If a plane is spanned, do:
                    SOAM_k = abs(safeAcos(dot_prod_T1_T2));
                else
                    %If a line is spanned, do:
                    SOAM_k = 0;
                end
                
                if isnan(SOAM_k)
                   disp('-------------------------------- SOAM_k NAN!') 
                end
                
                link_SOAM = link_SOAM + SOAM_k;
            end
        else
            disp('Small segment skipped... [SOAM]')
            link_SOAM = 0;
            link_length = 1;
            %Segment too small to calculate any SOAM. So we do nothing.
        end
        
        SOAM_sum = SOAM_sum + link_SOAM/link_length;
        
    end
    
    if isnan(SOAM_sum)
       disp('-------------------------------- SOAM SUM PRE NAN!') 
    end
    
    if num_links == 1
        %Do nothing. i.e. no correction for multiple segments/links.
    else
        SOAM_sum = SOAM_sum/Total_length;
        
        if isnan(SOAM_sum)
            disp('-------------------------------- SOAM SUM POST NAN!') 
        end
    end
    
    
end