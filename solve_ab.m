function [alpha, beta] = solve_ab( avgI, avgI0, avgGradientI, avgGradientI0 )
    alpha = avgGradientI./avgGradientI0;
    beta = avgI - avgI0.*alpha;
end

