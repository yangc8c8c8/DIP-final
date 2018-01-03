function [samplePixels ,x ,y] = selectTop50( avgImage )
    [r,c] = size(avgImage);
    half = round(sum(~isnan(avgImage(:)))/2);
    avgImage(isnan(avgImage)) = -Inf;
    [sorted, ind] = sort(avgImage(:), 'descend');
    [x, y] = ind2sub([r, c], ind(1:half));
    samplePixels = sorted(1:half);
end

