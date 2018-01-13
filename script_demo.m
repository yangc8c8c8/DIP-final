% transform color space
hsvAvgI = rgb2hsv(avgI);
hsvAvgGradientI = rgb2hsv(avgGradientI);

% RANSAC for each channel
iterationNum = 15;
disp('Fitting lightness channel of intensity');
fitMasks = zeros(height, width,iterationNum,2);
[hsvAvgI(:,:,3), fitMasks(:,:,:,1)] = ransac(hsvAvgI(:,:,3), iterationNum);
disp('Fitting lightness channel of gradient');
[hsvAvgGradientI(:,:,3), fitMasks(:,:,:,2)] = ransac(hsvAvgGradientI(:,:,3), iterationNum);
disp('ransac done.');
for i = 1:iterationNum
    imwrite(fitMasks(:,:,i,1),strcat('fitMask_',num2str(i),'.jpg'));
    imwrite(fitMasks(:,:,i,2),strcat('gradientFitMask_',num2str(i),'.jpg'));
end
avgI0 = hsv2rgb(hsvAvgI);
avgGradientI0 = hsv2rgb(hsvAvgGradientI);
imwrite(avgI0,'averagI0.jpg');
imwrite(normalize(avgGradientI0),'averagGradientI0.jpg');

filesNum = [546];
[alpha, beta] = solve_ab(avgI,avgI0,avgGradientI,avgGradientI0);
imwrite(alpha,'alpha.jpg');
imwrite(beta,'beta.jpg');
I0 = zeros(height, width, 3, size(filesNum,2));
C = zeros(size(filesNum,2), 3);
for i = 1: size(filesNum,2)
    test = im2single(imread(files{filesNum(i)}));
    for j = 1:3
        C(i,j) = solve_c(test(:,:,j),alpha(:,:,j),beta(:,:,j));
        I0(:,:,j,i) = (test(:,:,j)-C(i,j)*beta(:,:,j))./alpha(:,:,j);
    end
    imwrite(I0(:,:,:,i),strcat('I0_',num2str(filesNum(i)),'.jpg'));
end
