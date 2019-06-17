function [DM_array,SOAM_array,SOTM_array,LL_array,K_array] = viz_sinus_space_wrapper(sample_rate)
    %%Wrapper to do_sine.m intended to make a 2/3D plots of values
    %%retrieved from measure tortuosity given a sample rate.
    
    %%
    %Intializing.
    min_amp = 3;
    max_amp = 20;
    iter_amp = 1;
    
    min_freq = 1;
    max_freq = 10;
    iter_freq = 1;
    
    %%
    %Readying loops
    
    amps = min_amp:iter_amp:max_amp;
    freqs = min_freq:iter_freq:max_freq;
    
    length_amps = length(amps);
    length_freqs = length(freqs);
    
    DM_array = zeros(length_amps,length_freqs);
    SOAM_array = zeros(length_amps,length_freqs);
    SOTM_array = zeros(length_amps,length_freqs);
    LL_array = zeros(length_amps,length_freqs);
    K_array = zeros(length_amps,length_freqs);
    
    %%
    %Looping
    disp(['Starting ' num2str(length_amps*length_freqs) ' iterations...'])
    
    parfor i=1:length_amps
       %Outer loop 
       this_amp = amps(i);
       
       for j=1:length_freqs
           %Inner loop
           this_freq = freqs(j); %#ok<PFBNS>
           
           disp(['Current A: ' num2str(this_amp)])
           disp(['Current F: ' num2str(this_freq)])
           
           [this_DM,this_SOAM,this_SOTM,this_LL,this_K] = do_sine(this_freq,this_amp);
           
           %Storing
           DM_array(i,j) = this_DM;
           SOAM_array(i,j) = this_SOAM;
           SOTM_array(i,j) = this_SOTM;
           LL_array(i,j) = this_LL;
           K_array(i,j) = this_K;
       end
        
        
    end
    
    figure(1)
    bar3(DM_array)
    title('[Sine] DM plot')
    axis([0 Inf 0 Inf 1 max(DM_array(:))])
    xlabel('Frequencies')
    ylabel('Amplitudes')
    
    figure(2)
    bar3(SOAM_array)
    title('[Sine] SOAM plot')
    axis([0 Inf 0 Inf 0 max(SOAM_array(:))])
    xlabel('Frequencies')
    ylabel('Amplitudes')
    
    SOAM_array_mod = SOAM_array;
    isnan_SOAM_index = (SOAM_array == -1);
    SOAM_array_mod(isnan_SOAM_index) = NaN;
    mean_SOAM_array = nanmean(SOAM_array_mod);
    
    figure(3)
    bar(mean_SOAM_array)
    title('[Sine] (NaN)Mean (per freq) SOAM plot')
    xlabel('Frequencies')
    ylabel('Amplitudes')
    
    LL_array_mod = LL_array;
    isnan_LL_index = (LL_array == -1);
    LL_array_mod(isnan_LL_index) = NaN;
    
    figure(4)
    bar3(LL_array_mod)
    title('[Sine] Arc length plot')
    axis([0 Inf 0 Inf min(LL_array_mod(:)) max(LL_array_mod(:))])
    xlabel('Frequencies')
    ylabel('Amplitudes')
    
    size_DM = size(DM_array);
    col_coding_amp = repmat(1:size_DM(1),1,size_DM(2));
    col_coding_amp = col_coding_amp/max(col_coding_amp);
    col_coding_amp = [col_coding_amp' 1-col_coding_amp' col_coding_amp'];
    %col_coding = [col_coding' ones(size_DM(1)*size_DM(2),1) ones(size_DM(1)*size_DM(2),1)];
    
    figure(5) %Need a color coding per coloumn too!
    scatter(DM_array(:),SOAM_array(:),10,col_coding_amp,'filled')
    axis([1 Inf 0 Inf])
    xlabel('DM')
    ylabel('SOAM')
    title('[Sine] DM vs SOAM scatterplot [Amp coded]')
    
    col_coding_freq = repmat((1:size_DM(2))',size_DM(1),1);
    col_coding_freq = col_coding_freq/max(col_coding_freq);
    col_coding_freq = [col_coding_freq 1-col_coding_freq col_coding_freq];
    
    figure(6) %Need a color coding per coloumn too!
    scatter(DM_array(:),SOAM_array(:),10,col_coding_freq,'filled')
    axis([1 Inf 0 Inf])
    xlabel('DM')
    ylabel('SOAM')
    title('[Sine] DM vs SOAM scatterplot [Freq coded]')
    
    figure(7)
    bar3(K_array)
    title('[Sine] Finite Difference K curvature plot')
    axis([0 Inf 0 Inf 0 max(K_array(:))])
    xlabel('Frequencies')
    ylabel('Amplitudes')
    
    figure(8)
    scatter(K_array(:),SOAM_array(:),10,col_coding_amp,'filled')
    axis([0 Inf 0 Inf])
    xlabel('Finite Difference K curvature')
    ylabel('SOAM')
    title('[Sine] Finite Difference K curvature vs SOAM scatterplot [Amp Coded]')
    
    figure(9)
    scatter(DM_array(:),K_array(:),10,col_coding_amp,'filled')
    axis([1 Inf 0 Inf])
    xlabel('DM')
    ylabel('Finite Difference K curvature')
    title('[Sine] DM vs Finite Difference K curvature scatterplot [Amp coded]')
    
end