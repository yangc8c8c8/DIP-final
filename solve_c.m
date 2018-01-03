function C = solve_c( image, alpha, beta )
    minGradient = Inf;
    for i = 1:100
        I0 = (image-i/50*beta)./alpha;
        oneNormofGI0 = norm(imgradient(I0),1);
        if oneNormofGI0 < minGradient
            C = i/50;
            minGradient = oneNormofGI0;
        end
    end
end

