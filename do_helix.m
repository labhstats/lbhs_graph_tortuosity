function [DM,SOAM,SOTM,LL,K_curv,K_curv_theo] = do_helix(Freq,Amp)
    %%Function to simplify the calculation and tortuosity measurements of a
    %%helix function with user defined Amplitude and Frequency.
    
    %Amp defines the amplitude of the helix.
    %Freq defines the frequency of the helix.
    
    %Creating an impossible value to indicate that the segment broke.
    DM = -1;
	SOAM = -1;
    SOTM = -1;
    LL = -1;
    K_curv = -1;
    K_curv_theo = -1;
    
    %%
    %Initializing
    length_axis_x = 500;
    length_axis_y = 500;
    length_axis_z = 2000;
    
    phantom_space = [length_axis_x,length_axis_y,length_axis_z];
    
    helix_image = zeros(phantom_space);
    
    center_x = length_axis_x/2;
    center_y = length_axis_y/2;
    
    zzz = 2:(length_axis_z-1);
    xxx = round(Amp*cos(2*pi*(zzz/length(zzz))*Freq));
    yyy = round(Amp*sin(2*pi*(zzz/length(zzz))*Freq)); 
    
    %Accurate insertion of points.
    x_adj = (xxx + center_x);
    y_adj = (yyy + center_y);
    for i=1:length(zzz)
       helix_image(x_adj(i),y_adj(i),zzz(i)) = 1; 
        
    end
    
    %%
    %Calculations and exceptions.
    disp('Skel2Graph3D started...')
    [A_i,node_i,link_i] = Skel2Graph3D(helix_image,9); %#ok<ASGLU>
    clear helix_image
    
    condition_met = 0;
    link_length = length(link_i);
    
    if link_length == 1
        disp('Only 1 link found, good!')
        condition_met = 1;
    else
        disp('There are multiple links, when it should only be 1...')
    end
    
    if condition_met
        [DM,LL] = measure_DM(link_i,node_i,phantom_space,0); %Do not require smoothing.
        SOAM = measure_SOAM(link_i,phantom_space,1); %Require smoothing.
        
        SOTM = measure_SOTM(link_i,phantom_space,1); 
        
        K_curv = helix_curvature(x_adj,y_adj,zzz,1);
        K_curv_theo = Amp/(Amp^2 + 1); %Theoretical helix curvature: a/(a^2 + b^2) [Johnson 2007]. Where b (pitch) is equal to 1.
        % The theoretical curvature does not agree with SOAM...
    else
        %Do nothing.
    end
    
    %%
    %Finalizing via visualizing. (Omit outside of debugging.)
    disp(['Helix: F' num2str(Freq) ' A' num2str(Amp)])
    disp(['DM: ' num2str(DM)])
    disp(['SOAM: ' num2str(SOAM)])
    disp(['SOAM_TP: ' num2str(SOTM)])
    disp(['Length: ' num2str(LL)])
    disp(['Numeric Curvature: ' num2str(K_curv)])
    disp(['Theoretic Curvature: ' num2str(K_curv_theo)])
    
    graph_debugging(link_i,phantom_space,1,1)
    
end