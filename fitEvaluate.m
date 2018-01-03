function [ mask, surface] = fitEvaluate( fitResult, avgImage )
    [height, width] = size(avgImage);
    [y,x] = meshgrid(1:width, 1:height);
    x = 2*(x-1)/height-1; % nomalize to -1 ~ 1
    y = 2*(y-1)/width-1;
    coeff = coeffvalues(fitResult);
    % surface = feval(fitResult, x, y);
    surface = coeff(1)       + coeff(2)*x         + coeff(4)*x.^2         + coeff(7)*x.^3         + coeff(11)*x.^4    + ...
              coeff(3)*y     + coeff(5)*y.*x      + coeff(8)*y.*x.^2      + coeff(12)*y.*x.^3      + ...
              coeff(6)*y.^2  + coeff(9)*(y.^2).*x + coeff(13)*(y.^2).*x.^2+ ...
              coeff(10)*y.^3 + coeff(14)*(y.^3).*x+ ...
              coeff(15)*y.^4 ;
    mask = abs(avgImage-surface) <= 0.1*avgImage; 
end

