function K = helix_curvature(x,y,z,smoothing)
    %%Function to numerically calculate the curvature of a helix segment. Works
    %%with strictly 3D curves that are parameterized along the Z axis.
    %%Finite difference.
    
    function ddy = fin_diff_1(y_ip1,y_i,h)
        ddy = (y_ip1 - y_i)/h;
    end
    
    function d2dy = fin_diff_2(y_ip1,y_i,y_im1,h)
        %Central implementation.
        d2dy = (y_ip1 - 2*y_i + y_im1)/(h*h);
    end
    
    function k_i = theo_curvature_helix(y_ip1,y_i,y_im1,x_ip1,x_i,x_im1,h)
        
        nominator = abs(fin_diff_2(y_ip1,y_i,y_im1,h)*fin_diff_1(x_ip1,x_i,h) - fin_diff_1(y_ip1,y_i,h)*fin_diff_2(x_ip1,x_i,x_im1,h));
        denominator = (fin_diff_1(x_ip1,x_i,h)^2 + fin_diff_1(y_ip1,y_i,h)^2)^(3/2);
        
        k_i = abs(nominator/denominator); %Ensuring accumulation.
    end
    
    function h = find_h(z_ip1,z_i,z_im1)
        %h should be equal to 1, but just in case.
        
        h_front_diff = abs(z_ip1 - z_i);
        h_back_diff = abs(z_i - z_im1);
        
        h = mean([h_front_diff h_back_diff]);
    end
    
    if smoothing == 1
        x = smoothdata(x,'rloess');
        y = smoothdata(y,'rloess');
        %z = smoothdata(z,'rloess');
    end
    
    len_y = length(y);
    K = 0; %Summation of curvature.
    
    start_i = 2;
    end_i = len_y - 1;
    for i=start_i:end_i
        
        x_im1 = x(i-1);
        x_i = x(i);
        x_ip1 = x(i+1);
        
        y_im1 = y(i-1);
        y_i = y(i);
        y_ip1 = y(i+1);
        
        z_im1 = z(i-1);
        z_i = z(i);
        z_ip1 = z(i+1);
        
        h = find_h(z_ip1,z_i,z_im1);
        
        k_i = theo_curvature_helix(y_ip1,y_i,y_im1,x_ip1,x_i,x_im1,h);
        K = K + k_i;
    end
    
    
end