function [estimateAvgImage, fitMasks]  = ransac( avgImage, iterationNum)
    [height, width] = size(avgImage);
    samplePixels = avgImage;
    [subData, x, y] = selectTop50(avgImage);
    fitMasks = zeros(height, width, 1, iterationNum);
    for i = 1:iterationNum
%        disp(['iteration ',num2str(i)]);
        
        x = 2*(x-1)/height-1; % nomalize to -1 ~ 1
        y = 2*(y-1)/width-1;
        [xData, yData, zData] = prepareSurfaceData( x, y, double(subData));
        % Set up fittype and options.
        ft = fittype( 'poly44' );
        % Fit model to data.
        [fitResult, ~] = fit( [xData, yData], zData, ft );
        [mask, surface] = fitEvaluate(fitResult, avgImage);
        fitMasks(:,:,1,i) = mask;
        % update subset 
        subData = samplePixels(:);
        subData = subData(mask(:));
        [y, x] = meshgrid(1:width,1:height);
        x = x(:); y = y(:);
        x = x(mask(:));
        y = y(mask(:));
    end
    estimateAvgImage = surface;
end