function output_example = phantom_vessel_example(sampling_rate_manual)
    %%Example to test outmeasure_tortuosity.m and fix its kinks.
    
    length_axis_x = 2000;
    length_axis_y = 200;
    length_axis_z = 500;
    
    phantom_space = [length_axis_x,length_axis_y,length_axis_z];
    
    image_3D_template = zeros(phantom_space);
    
     %%
    % Straight line.
    straight_space = image_3D_template;
    
    center_z = length_axis_z/2;
    center_y = length_axis_y/2;
    
    straight_space(2:(length_axis_x-1),center_y,center_z) = 1; %Straight line phantom.
    straight_space = logical(straight_space);
    
    disp('Skel2Graph3D started...')
    [s_A,s_node,s_link] = Skel2Graph3D(straight_space,9);
    
    s_length = length(s_link);
    if s_length ~= 1
        disp('There are multiple links, when it should only be 1...')
    else
        disp('Only 1 link found, good!')
    end
    
    %disp('Length (sparse matrix):')
    %disp(s_A)
    
    [s_DM,s_SOAM_IP,s_SOAM_TP,s_LL] = measure_tortuosity(s_A,s_link,s_node,phantom_space,sampling_rate_manual);
    
    disp('Straight line:')
    disp('DM')
    disp(s_DM)
    disp('SOAM_IP')
    disp(s_SOAM_IP)
    disp('SOAM_TP')
    disp(s_SOAM_TP)
    disp('Length')
    disp(s_LL)
    
    graph_debugging(s_link,phantom_space,sampling_rate_manual)
    
    %%
    % Sines of varying Frequency and Amplitude.
    
    %%
    %Sine #1 (Amplitude less than a certain amount voxels causes errors...)
    %Sine F = 3 Amp = 100
    center_y = length_axis_y/2;
    center_z = length_axis_z/2;
    
    xxx = 2:(length_axis_x-1);
    Fre = 3;
    Amp = 100;
    zzz = round(Amp*sin(2*pi*(xxx/length(xxx))*Fre));
    
    sine_F3_A100 = image_3D_template;
    
    %Accurate insertion of points.
    z_adj = (zzz + center_z);
    for i=1:length(xxx)
       sine_F3_A100(xxx(i),center_y,z_adj(i)) = 1; 
        
    end
    
    %plot3(xxx,repmat(center_y,length(xxx)),(zzz + center_z),'*-')
    %axis([0 phantom_space(1) 0 phantom_space(2) 0 phantom_space(3)])
    
    disp('Skel2Graph3D started...')
    [sf3a100_A,sf3a100_node,sf3a100_link] = Skel2Graph3D(sine_F3_A100,9);
    
    sf3a100_length = length(sf3a100_link);
    if sf3a100_length ~= 1
        disp('There are multiple links, when it should only be 1...')
    else
        disp('Only 1 link found, good!')
    end
    
    [sf3a100_DM,sf3a100_SOAM_IP,sf3a100_SOAM_TP,sf3a100_LL] = measure_tortuosity(sf3a100_A,sf3a100_link,sf3a100_node,phantom_space,sampling_rate_manual);
    
    disp('Sine F3 A100:')
    disp('DM')
    disp(sf3a100_DM)
    disp('SOAM')
    disp(sf3a100_SOAM_IP)
    disp('SOAM_TP')
    disp(sf3a100_SOAM_TP)
    disp('Length')
    disp(sf3a100_LL)
        
    graph_debugging(sf3a100_link,phantom_space,sampling_rate_manual)
    
    %%
    %Sine #2
    %Sine F = 6 Amp = 50
    center_y = length_axis_y/2;
    center_z = length_axis_z/2;
    
    xxx = 2:(length_axis_x-1);
    Fre = 6;
    Amp = 50;
    zzz = round(Amp*sin(2*pi*(xxx/length(xxx))*Fre));
    
    sine_F6_A50 = image_3D_template;
    
    %Accurate insertion of points.
    z_adj = (zzz + center_z);
    for i=1:length(xxx)
       sine_F6_A50(xxx(i),center_y,z_adj(i)) = 1; 
        
    end
    
    %plot3(xxx,repmat(center_y,length(xxx)),(zzz + center_z),'*-')
    %axis([0 phantom_space(1) 0 phantom_space(2) 0 phantom_space(3)])
    
    disp('Skel2Graph3D started...')
    [sf6a50_A,sf6a50_node,sf6a50_link] = Skel2Graph3D(sine_F6_A50,9);
    
    sf6a50_length = length(sf6a50_link);
    if sf6a50_length ~= 1
        disp('There are multiple links, when it should only be 1...')
    else
        disp('Only 1 link found, good!')
    end
    
    [sf6a50_DM,sf6a50_SOAM_IP,sf6a50_SOAM_TP,sf6a50_LL] = measure_tortuosity(sf6a50_A,sf6a50_link,sf6a50_node,phantom_space,sampling_rate_manual);
    
    disp('Sine F6 A50:')
    disp('DM')
    disp(sf6a50_DM)
    disp('SOAM_IP')
    disp(sf6a50_SOAM_IP)
    disp('SOAM_TP')
    disp(sf6a50_SOAM_TP)
    disp('Length')
    disp(sf6a50_LL)
    
    graph_debugging(sf6a50_link,phantom_space,sampling_rate_manual)
    
    %%
    %Sine #3
    %Sine F = 10 Amp = 30
    center_y = length_axis_y/2;
    center_z = length_axis_z/2;
    
    xxx = 2:(length_axis_x-1);
    Fre = 10;
    Amp = 30;
    zzz = round(Amp*sin(2*pi*(xxx/length(xxx))*Fre));
    
    sine_F10_A30 = image_3D_template;
    
    %Accurate insertion of points.
    z_adj = (zzz + center_z);
    for i=1:length(xxx)
       sine_F10_A30(xxx(i),center_y,z_adj(i)) = 1; 
        
    end
    
    %plot3(xxx,repmat(center_y,length(xxx)),(zzz + center_z),'*-')
    %axis([0 phantom_space(1) 0 phantom_space(2) 0 phantom_space(3)])
    
    disp('Skel2Graph3D started...')
    [sf10a30_A,sf10a30_node,sf10a30_link] = Skel2Graph3D(sine_F10_A30,9);
    
    sf10a30_length = length(sf10a30_link);
    if sf10a30_length ~= 1
        disp('There are multiple links, when it should only be 1...')
    else
        disp('Only 1 link found, good!')
    end
    
    [sf10a30_DM,sf10a30_SOAM_IP,sf10a30_SOAM_TP,sf10a30_LL] = measure_tortuosity(sf10a30_A,sf10a30_link,sf10a30_node,phantom_space,sampling_rate_manual);
    
    disp('Sine F10 A30:')
    disp('DM')
    disp(sf10a30_DM)
    disp('SOAM_IP')
    disp(sf10a30_SOAM_IP)
    disp('SOAM_TP')
    disp(sf10a30_SOAM_TP)
    disp('Length')
    disp(sf10a30_LL)
    
    graph_debugging(sf10a30_link,phantom_space,sampling_rate_manual)
    
    %%
    % Sines of varying Amplitude.
    
    %%
    %Sine #1
    %Sine F = 3 Amp = 20
    center_y = length_axis_y/2;
    center_z = length_axis_z/2;
    
    xxx = 2:(length_axis_x-1);
    Fre = 3;
    Amp = 20;
    zzz = round(Amp*sin(2*pi*(xxx/length(xxx))*Fre));
    
    sine_F3_A20 = image_3D_template;
    
    %Accurate insertion of points.
    z_adj = (zzz + center_z);
    for i=1:length(xxx)
       sine_F3_A20(xxx(i),center_y,z_adj(i)) = 1; 
        
    end
   
    %plot3(xxx,repmat(center_y,length(xxx)),(zzz + center_z),'*-')
    %axis([0 phantom_space(1) 0 phantom_space(2) 0 phantom_space(3)])
    
    disp('Skel2Graph3D started...')
    [sf3a20_A,sf3a20_node,sf3a20_link] = Skel2Graph3D(sine_F3_A20,9);
    
    sf3a20_length = length(sf3a20_link);
    if sf3a20_length ~= 1
        disp('There are multiple links, when it should only be 1...')
    else
        disp('Only 1 link found, good!')
    end
    
    [sf3a20_DM,sf3a20_SOAM_IP,sf3a20_SOAM_TP,sf3a20_LL] = measure_tortuosity(sf3a20_A,sf3a20_link,sf3a20_node,phantom_space,sampling_rate_manual);
    
    disp('Sine F3 A20:')
    disp('DM')
    disp(sf3a20_DM)
    disp('SOAM_IP')
    disp(sf3a20_SOAM_IP)
    disp('SOAM_TP')
    disp(sf3a20_SOAM_TP)
    disp('Length')
    disp(sf3a20_LL)
    
    graph_debugging(sf3a20_link,phantom_space,sampling_rate_manual)
    
    %%
    %Sine #2
    %Sine F = 3 Amp = 60
    center_y = length_axis_y/2;
    center_z = length_axis_z/2;
    
    xxx = 2:(length_axis_x-1);
    Fre = 3;
    Amp = 60;
    zzz = round(Amp*sin(2*pi*(xxx/length(xxx))*Fre));
    
    sine_F3_A60 = image_3D_template;
    
    %Accurate insertion of points.
    z_adj = (zzz + center_z);
    for i=1:length(xxx)
       sine_F3_A60(xxx(i),center_y,z_adj(i)) = 1; 
        
    end
   
    %plot3(xxx,repmat(center_y,length(xxx)),(zzz + center_z),'*-')
    %axis([0 phantom_space(1) 0 phantom_space(2) 0 phantom_space(3)])

%     sphere_2 = strel('sphere',2);
%     sine_F3_A40 = imdilate(sine_F3_A40,sphere_2);
%     sine_F3_A40 = imbinarize(sine_F3_A40);
%     sine_F3_A40 = bwskel(sine_F3_A40);
    
    disp('Skel2Graph3D started...')
    [sf3a60_A,sf3a60_node,sf3a60_link] = Skel2Graph3D(sine_F3_A60,9);
    
    sf3a60_length = length(sf3a60_link);
    if sf3a60_length ~= 1
        disp('There are multiple links, when it should only be 1...')
    else
        disp('Only 1 link found, good!')
    end
    
    [sf3a60_DM,sf3a60_SOAM_IP,sf3a60_SOAM_TP,sf3a60_LL] = measure_tortuosity(sf3a60_A,sf3a60_link,sf3a60_node,phantom_space,sampling_rate_manual);
    
    disp('Sine F3 A60:')
    disp('DM')
    disp(sf3a60_DM)
    disp('SOAM_IP')
    disp(sf3a60_SOAM_IP)
    disp('SOAM_TP')
    disp(sf3a60_SOAM_TP)
    disp('Length')
    disp(sf3a60_LL)
    
    graph_debugging(sf3a60_link,phantom_space,sampling_rate_manual)
    
    %%
    %Sine #3
    %Sine F = 3 Amp = 100
    center_y = length_axis_y/2;
    center_z = length_axis_z/2;
    
    xxx = 2:(length_axis_x-1);
    Fre = 3;
    Amp = 100;
    zzz = round(Amp*sin(2*pi*(xxx/length(xxx))*Fre));
    
    sine_F3_A100 = image_3D_template;
    
    %Accurate insertion of points.
    z_adj = (zzz + center_z);
    for i=1:length(xxx)
       sine_F3_A100(xxx(i),center_y,z_adj(i)) = 1; 
        
    end
   
    %plot3(xxx,repmat(center_y,length(xxx)),(zzz + center_z),'*-')
    %axis([0 phantom_space(1) 0 phantom_space(2) 0 phantom_space(3)])

%     sphere_2 = strel('sphere',2);
%     sine_F3_A40 = imdilate(sine_F3_A40,sphere_2);
%     sine_F3_A40 = imbinarize(sine_F3_A40);
%     sine_F3_A40 = bwskel(sine_F3_A40);
    
    disp('Skel2Graph3D started...')
    [sf3a100_A,sf3a100_node,sf3a100_link] = Skel2Graph3D(sine_F3_A100,9);
    
    sf3a100_length = length(sf3a100_link);
    if sf3a100_length ~= 1
        disp('There are multiple links, when it should only be 1...')
    else
        disp('Only 1 link found, good!')
    end
    
    [sf3a100_DM,sf3a100_SOAM_IP,sf3a100_SOAM_TP,sf3a100_LL] = measure_tortuosity(sf3a100_A,sf3a100_link,sf3a100_node,phantom_space,sampling_rate_manual);
    
    disp('Sine F3 A100:')
    disp('DM')
    disp(sf3a100_DM)
    disp('SOAM_IP')
    disp(sf3a100_SOAM_IP)
    disp('SOAM_TP')
    disp(sf3a100_SOAM_TP)
    disp('Length')
    disp(sf3a100_LL)
    
    graph_debugging(sf3a100_link,phantom_space,sampling_rate_manual)
    
    %%
    %Special space for coils...
    %Example to test outmeasure_tortuosity.m and fix its kinks.
    
    length_axis_x = 500;
    length_axis_y = 500;
    length_axis_z = 2000;
    
    phantom_space = [length_axis_x,length_axis_y,length_axis_z];
    
    image_3D_template = zeros(phantom_space);
    
    %%
    % Coils of varying Frequency and Amplitude.
    %%
    %Coil #1
    %Sine F = 3 Amp = 63
    center_x = length_axis_x/2;
    center_y = length_axis_y/2;
    %center_z = length_axis_z/2;
    
    zzz = 2:(length_axis_z-1);
    Fre = 3;
    Amp = 63;
    xxx = round(Amp*cos(2*pi*(zzz/length(zzz))*Fre));
    yyy = round(Amp*sin(2*pi*(zzz/length(zzz))*Fre)); 
    
    coil_F3_A63 = image_3D_template;
    %Accurate insertion of points.
    
    x_adj = (xxx + center_x);
    y_adj = (yyy + center_y);
    for i=1:length(zzz)
       coil_F3_A63(x_adj(i),y_adj(i),zzz(i)) = 1; 
        
    end
    
%     plot3(x_adj,y_adj,zzz,'*-')
%     axis([0 phantom_space(1) 0 phantom_space(2) 0 phantom_space(3)])
    
    disp('Skel2Graph3D started...')
    [cf3a63_A,cf3a63_node,cf3a63_link] = Skel2Graph3D(coil_F3_A63,9);
    
    cf3a63_length = length(cf3a63_link);
    if cf3a63_length > 1
        disp('There are multiple links, when it should only be 1...')
    else
        
        if cf3a63_length < 1
            disp('Less than 1 link?')
        else
            disp('Only 1 link found, good!')
        end
        
    end
    
    [cf3a63_DM,cf3a63_SOAM_IP,cf3a63_SOAM_TP,cf3a63_LL] = measure_tortuosity(cf3a63_A,cf3a63_link,cf3a63_node,phantom_space,sampling_rate_manual);
    
    disp('Coil F3 A63:')
    disp('DM')
    disp(cf3a63_DM)
    disp('SOAM_IP')
    disp(cf3a63_SOAM_IP)
    disp('SOAM_TP')
    disp(cf3a63_SOAM_TP)
    disp('Length')
    disp(cf3a63_LL)
    
    graph_debugging(cf3a63_link,phantom_space,sampling_rate_manual)
    
    %%
    %Coil #2
    %Sine F = 10 Amp = 19
    center_x = length_axis_x/2;
    center_y = length_axis_y/2;
    %center_z = length_axis_z/2;
    
    zzz = 2:(length_axis_z-1);
    Fre = 10;
    Amp = 19;
    xxx = round(Amp*cos(2*pi*(zzz/length(zzz))*Fre));
    yyy = round(Amp*sin(2*pi*(zzz/length(zzz))*Fre)); 
    
    coil_F10_A19 = image_3D_template;
    %Accurate insertion of points.
    
    x_adj = (xxx + center_x);
    y_adj = (yyy + center_y);
    for i=1:length(zzz)
       coil_F10_A19(x_adj(i),y_adj(i),zzz(i)) = 1; 
        
    end
    
%     plot3(x_adj,y_adj,zzz,'*-')
%     axis([0 phantom_space(1) 0 phantom_space(2) 0 phantom_space(3)])
    
    disp('Skel2Graph3D started...')
    [cf10a19_A,cf10a19_node,cf10a19_link] = Skel2Graph3D(coil_F10_A19,9);
    
    cf10a19_length = length(cf10a19_link);
    if cf10a19_length > 1
        disp('There are multiple links, when it should only be 1...')
    else
        
        if cf10a19_length < 1
            disp('Less than 1 link?')
        else
            disp('Only 1 link found, good!')
        end
        
    end
    
    [cf10a19_DM,cf10a19_SOAM_IP,cf10a19_SOAM_TP,cf10a19_LL] = measure_tortuosity(cf10a19_A,cf10a19_link,cf10a19_node,phantom_space,sampling_rate_manual);
    
    disp('Coil F10 A19:')
    disp('DM')
    disp(cf10a19_DM)
    disp('SOAM_IP')
    disp(cf10a19_SOAM_IP)
    disp('SOAM_TP')
    disp(cf10a19_SOAM_TP)
    disp('Length')
    disp(cf10a19_LL)
    
    graph_debugging(cf10a19_link,phantom_space,sampling_rate_manual)
    
    %%
    %Coil #3
    %Sine F = 20 Amp = 9
    center_x = length_axis_x/2;
    center_y = length_axis_y/2;
    %center_z = length_axis_z/2;
    
    zzz = 2:(length_axis_z-1);
    Fre = 20;
    Amp = 9;
    xxx = round(Amp*cos(2*pi*(zzz/length(zzz))*Fre));
    yyy = round(Amp*sin(2*pi*(zzz/length(zzz))*Fre)); 
    
    coil_F20_A9 = image_3D_template;
    %Accurate insertion of points.
    
    x_adj = (xxx + center_x);
    y_adj = (yyy + center_y);
    for i=1:length(zzz)
       coil_F20_A9(x_adj(i),y_adj(i),zzz(i)) = 1; 
        
    end
    
%     plot3(x_adj,y_adj,zzz,'*-')
%     axis([0 phantom_space(1) 0 phantom_space(2) 0 phantom_space(3)])
    
    disp('Skel2Graph3D started...')
    [cf20a9_A,cf20a9_node,cf20a9_link] = Skel2Graph3D(coil_F20_A9,9);
    
    cf20a9_length = length(cf20a9_link);
    if cf20a9_length > 1
        disp('There are multiple links, when it should only be 1...')
    else
        
        if cf20a9_length < 1
            disp('Less than 1 link?')
        else
            disp('Only 1 link found, good!')
        end
        
    end
    
    [cf20a9_DM,cf20a9_SOAM_IP,cf20a9_SOAM_TP,cf20a9_LL] = measure_tortuosity(cf20a9_A,cf20a9_link,cf20a9_node,phantom_space,sampling_rate_manual);
    
    disp('Coil F20 A9:')
    disp('DM')
    disp(cf20a9_DM)
    disp('SOAM_IP')
    disp(cf20a9_SOAM_IP)
    disp('SOAM_TP')
    disp(cf20a9_SOAM_TP)
    disp('Length')
    disp(cf20a9_LL)
    
    graph_debugging(cf20a9_link,phantom_space,sampling_rate_manual)
    
    %%
    % Coils of varying Amplitude.
    
    %%
    %Coil #4
    %Sine F = 3 Amp = 20
    center_x = length_axis_x/2;
    center_y = length_axis_y/2;
    %center_z = length_axis_z/2;
    
    zzz = 2:(length_axis_z-1);
    Fre = 3;
    Amp = 20;
    xxx = round(Amp*cos(2*pi*(zzz/length(zzz))*Fre));
    yyy = round(Amp*sin(2*pi*(zzz/length(zzz))*Fre)); 
    
    coil_F3_A20 = image_3D_template;
    %Accurate insertion of points.
    
    x_adj = (xxx + center_x);
    y_adj = (yyy + center_y);
    for i=1:length(zzz)
       coil_F3_A20(x_adj(i),y_adj(i),zzz(i)) = 1; 
        
    end
    
%     plot3(x_adj,y_adj,zzz,'*-')
%     axis([0 phantom_space(1) 0 phantom_space(2) 0 phantom_space(3)])
    
    disp('Skel2Graph3D started...')
    [cf3a20_A,cf3a20_node,cf3a20_link] = Skel2Graph3D(coil_F3_A20,9);
    
    cf3a20_length = length(cf3a20_link);
    if cf3a20_length > 1
        disp('There are multiple links, when it should only be 1...')
    else
        
        if cf3a20_length < 1
            disp('Less than 1 link?')
        else
            disp('Only 1 link found, good!')
        end
        
    end
    
    [cf3a20_DM,cf3a20_SOAM_IP,cf3a20_SOAM_TP,cf3a20_LL] = measure_tortuosity(cf3a20_A,cf3a20_link,cf3a20_node,phantom_space,sampling_rate_manual);
    
    disp('Coil F3 A20:')
    disp('DM')
    disp(cf3a20_DM)
    disp('SOAM_IP')
    disp(cf3a20_SOAM_IP)
    disp('SOAM_TP')
    disp(cf3a20_SOAM_TP)
    disp('Length')
    disp(cf3a20_LL)
    
    graph_debugging(cf3a63_link,phantom_space,sampling_rate_manual)
    
    %%
    %Coil #5
    %Sine F = 3 Amp = 40
    center_x = length_axis_x/2;
    center_y = length_axis_y/2;
    %center_z = length_axis_z/2;
    
    zzz = 2:(length_axis_z-1);
    Fre = 3;
    Amp = 40;
    xxx = round(Amp*cos(2*pi*(zzz/length(zzz))*Fre));
    yyy = round(Amp*sin(2*pi*(zzz/length(zzz))*Fre)); 
    
    coil_F3_A40 = image_3D_template;
    %Accurate insertion of points.
    
    x_adj = (xxx + center_x);
    y_adj = (yyy + center_y);
    for i=1:length(zzz)
       coil_F3_A40(x_adj(i),y_adj(i),zzz(i)) = 1; 
        
    end
    
%     plot3(x_adj,y_adj,zzz,'*-')
%     axis([0 phantom_space(1) 0 phantom_space(2) 0 phantom_space(3)])
    
    disp('Skel2Graph3D started...')
    [cf3a40_A,cf3a40_node,cf3a40_link] = Skel2Graph3D(coil_F3_A40,9);
    
    cf3a40_length = length(cf3a40_link);
    if cf3a40_length > 1
        disp('There are multiple links, when it should only be 1...')
    else
        
        if cf3a40_length < 1
            disp('Less than 1 link?')
        else
            disp('Only 1 link found, good!')
        end
        
    end
    
    [cf3a40_DM,cf3a40_SOAM_IP,cf3a40_SOAM_TP,cf3a40_LL] = measure_tortuosity(cf3a40_A,cf3a40_link,cf3a40_node,phantom_space,sampling_rate_manual);
    
    disp('Coil F3 A40:')
    disp('DM')
    disp(cf3a40_DM)
    disp('SOAM_IP')
    disp(cf3a40_SOAM_IP)
    disp('SOAM_TP')
    disp(cf3a40_SOAM_TP)
    disp('Length')
    disp(cf3a40_LL)
    
    graph_debugging(cf3a40_link,phantom_space,sampling_rate_manual)    
    
    %%
    %Coil #6
    %Sine F = 3 Amp = 80
    center_x = length_axis_x/2;
    center_y = length_axis_y/2;
    %center_z = length_axis_z/2;
    
    zzz = 2:(length_axis_z-1);
    Fre = 3;
    Amp = 80;
    xxx = round(Amp*cos(2*pi*(zzz/length(zzz))*Fre));
    yyy = round(Amp*sin(2*pi*(zzz/length(zzz))*Fre)); 
    
    coil_F3_A80 = image_3D_template;
    %Accurate insertion of points.
    
    x_adj = (xxx + center_x);
    y_adj = (yyy + center_y);
    for i=1:length(zzz)
       coil_F3_A80(x_adj(i),y_adj(i),zzz(i)) = 1; 
        
    end
    
%     plot3(x_adj,y_adj,zzz,'*-')
%     axis([0 phantom_space(1) 0 phantom_space(2) 0 phantom_space(3)])
    
    disp('Skel2Graph3D started...')
    [cf3a80_A,cf3a80_node,cf3a80_link] = Skel2Graph3D(coil_F3_A80,9);
    
    cf3a80_length = length(cf3a80_link);
    if cf3a80_length > 1
        disp('There are multiple links, when it should only be 1...')
    else
        
        if cf3a80_length < 1
            disp('Less than 1 link?')
        else
            disp('Only 1 link found, good!')
        end
        
    end
    
    [cf3a80_DM,cf3a80_SOAM_IP,cf3a80_SOAM_TP,cf3a80_LL] = measure_tortuosity(cf3a80_A,cf3a80_link,cf3a80_node,phantom_space,sampling_rate_manual);
    
    disp('Coil F3 A80:')
    disp('DM')
    disp(cf3a80_DM)
    disp('SOAM_IP')
    disp(cf3a80_SOAM_IP)
    disp('SOAM_TP')
    disp(cf3a80_SOAM_TP)
    disp('Length')
    disp(cf3a80_LL)
    
    graph_debugging(cf3a80_link,phantom_space,sampling_rate_manual)
    
    %%
    % Condense scores.
    
    Names_ALL = ["Straight","SF3A100","SF6A50","SF10A30","SF3A20","SF3A60","SF3A100","CF3A63","CF10A19","CF20A9","CF3A20","CF3A40","CF3A80"];
    DM_ALL = [s_DM,sf3a100_DM,sf6a50_DM,sf10a30_DM,sf3a20_DM,sf3a60_DM,sf3a100_DM,cf3a63_DM,cf10a19_DM,cf20a9_DM,cf3a20_DM,cf3a40_DM,cf3a80_DM];
    SOAMs_ALL = [s_SOAM_IP,sf3a100_SOAM_IP,sf6a50_SOAM_IP,sf10a30_SOAM_IP,sf3a20_SOAM_IP,sf3a60_SOAM_IP,sf3a100_SOAM_IP,cf3a63_SOAM_IP,cf10a19_SOAM_IP,cf20a9_SOAM_IP,cf3a20_SOAM_IP,cf3a40_SOAM_IP,cf3a80_SOAM_IP];
    SOATs_ALL = [s_SOAM_TP,sf3a100_SOAM_TP,sf6a50_SOAM_TP,sf10a30_SOAM_TP,sf3a20_SOAM_TP,sf3a60_SOAM_TP,sf3a100_SOAM_TP,cf3a63_SOAM_TP,cf10a19_SOAM_TP,cf20a9_SOAM_TP,cf3a20_SOAM_TP,cf3a40_SOAM_TP,cf3a80_SOAM_TP];
    Length_ALL = [s_LL,sf3a100_LL,sf6a50_LL,sf10a30_LL,sf3a20_LL,sf3a60_LL,sf3a100_LL,cf3a63_LL,cf10a19_LL,cf20a9_LL,cf3a20_LL,cf3a40_LL,cf3a80_LL];
    sample_rate_ALL = repmat(sampling_rate_manual,[1 length(Names_ALL)]);
    
    Table_T = table(Names_ALL',DM_ALL',SOAMs_ALL',SOATs_ALL',Length_ALL',sample_rate_ALL','VariableNames',{'Segment' 'DM' 'SOAM' 'SOTM' 'Length' 'Sample_Rate'});
    
    output_example = Table_T;
end