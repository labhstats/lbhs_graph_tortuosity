function graph_debugging(link_i,im_dim,sampling_rate_manual,smoothing)
%%Function for plotting the graph created by Skel2Graph3D.m while also providing the original image dimensions.

[test_I,test_J,test_K] = ind2sub(im_dim,link_i(1).point);

[test_I,test_J,test_K] = down_sample_link(test_I,test_J,test_K,sampling_rate_manual);

if smoothing == 1
    test_I = smoothdata(test_I,'rloess');
    test_J = smoothdata(test_J,'rloess');
    test_K = smoothdata(test_K,'rloess');
end

figure(99)
plot3(test_I,test_J,test_K,'*-')
axis([0 im_dim(1) 0 im_dim(2) 0 im_dim(3)])
hold on;

if length(link_i) > 1
    for i=2:length(link_i)
        [test_I,test_J,test_K] = ind2sub(im_dim,link_i(i).point);
        
        if smoothing == 1
            test_I = smoothdata(test_I,'rloess');
            test_J = smoothdata(test_J,'rloess');
            test_K = smoothdata(test_K,'rloess');
        end

        plot3(test_I,test_J,test_K,'*-')
    end
end

hold off;
end