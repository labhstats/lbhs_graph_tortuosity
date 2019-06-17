function [DM,SOAM,SOTM,LL,K_curv] = do_sine(Freq,Amp)
    %%Function to simplify the calculation and tortuosity measurements of a
    %%sine function with user defined Amplitude and Frequency.
    
    %Amp defines the amplitude of the sine.
    %Freq defines the frequency of the sine.
    %sampling_rate_manual defines how often a point in a link_i (between
    %nodes) should be sampled; minimum 1, and only integers.
    
    %Creating an impossible value to indicate that the segment broke.
    DM = -1;
	SOAM = -1;
    SOTM = -1;
    LL = -1;
    K_curv = -1;
    
    %%
    %Initializing
    length_axis_x = 2000;
    length_axis_y = 200;
    length_axis_z = 500;
    
    phantom_space = [length_axis_x,length_axis_y,length_axis_z];
    
    sine_image = zeros(phantom_space);
    
    center_y = length_axis_y/2;
    center_z = length_axis_z/2;
    
    xxx = 2:(length_axis_x-1);
    zzz = round(Amp*sin(2*pi*(xxx/length(xxx))*Freq));
    
    %Accurate insertion of points.
    z_adj = (zzz + center_z);
    for i=1:length(xxx)
       sine_image(xxx(i),center_y,z_adj(i)) = 1; 
        
    end
    
    %%
    %Calculations and exceptions.
    disp('Skel2Graph3D started...')
    [A_i,node_i,link_i] = Skel2Graph3D(sine_image,9); %#ok<ASGLU>
    clear sine_image
    
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
        %Sines cannot have Torsion, but it should be checked
        %regardless
        
        K_curv = sine_curvature(xxx,z_adj,1);
    else
        %Do nothing.
    end
    
    %%
    %Finalizing via visualizing. (Omit outside of debugging.)
    disp(['Sine: F' num2str(Freq) ' A' num2str(Amp)])
    disp(['DM: ' num2str(DM)])
    disp(['SOAM: ' num2str(SOAM)])
    disp(['SOAM_TP: ' num2str(SOTM)])
    disp(['Length: ' num2str(LL)])
    disp(['Numeric Curvature: ' num2str(K_curv)])
    
    graph_debugging(link_i,phantom_space,1,1)
    
end