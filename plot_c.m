function C = plot_c( image, alpha, beta )
    minGradient = Inf;
    t = linspace(0,2,100);
    sparsity = zeros(1,100);
    for i = 1:100
        I0 = (image-i/50*beta)./alpha;
        oneNormofGI0 = norm(imgradient(I0),1);
        sparsity(1,i) = oneNormofGI0;
        if oneNormofGI0 < minGradient
            C = i/50;
            minGradient = oneNormofGI0;
        end
    end
    plot(t,sparsity);
end
