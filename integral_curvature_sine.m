function K_space = integral_curvature_sine(x_max)
    
    xxx = 1:x_max;
    
    disp(['Resolution is: ' num2str(1/x_max)])
    
    %%
    %Intializing.
    min_amp = 3;
    max_amp = 20;
    iter_amp = 1;
    
    min_freq = 1;
    max_freq = 10;
    iter_freq = 1;
    
    %%
    % Defining necessary functions.
    
    function curv_k = int_sine_curv(F,A,x_i)
        
        nominator = 4*pi*pi*F*F*A*sin(2*pi*x_i*F);
        denominator = (1 + 2*pi*F*A*cos(2*pi*x_i*F))^(3/2);
        
        curv_k = abs(nominator/denominator);
    end
    
    %%
    % Readying summation of integral.
    amps = min_amp:iter_amp:max_amp;
    freqs = min_freq:iter_freq:max_freq;
    
    length_x = length(xxx);
    length_amps = length(amps);
    length_freqs = length(freqs);
    
    K_space = zeros(length_amps,length_freqs);
    
    for i=1:length_amps
       this_amp = amps(i);
       
       for j=1:length_freqs
           this_freq = freqs(j);
           
           for k=1:length_x
               x_k = xxx(i)/x_max;
               
               K_ijk = int_sine_curv(this_freq,this_amp,x_k);
               
               K_space(i,j) = K_space(i,j) + K_ijk;
           end
           
       end
       
    end
    
    disp('Row axis is amplitude.')
    disp('Coloumn axis is frequency.')
    
    figure(98)
    bar3(K_space)
    axis([0 Inf 0 Inf 1 max(K_space(:))])
    title('Sine [Numeric integral] curvature per amplitude and frequency.')
    xlabel('Frequencies')
    ylabel('Amplitudes')
    
end