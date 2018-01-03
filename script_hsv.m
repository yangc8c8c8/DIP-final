% % initial 
% % import pictures and compute average and gradient; 3 dimension for [hight(x), wideth(y), RGB, frame number]
% jpegFiles = dir('./full_data/*.jpg'); 
% frameNum = round(length(jpegFiles));
% files = strcat('./full_data/', {jpegFiles(1:frameNum).name});
% % observe size
% test = im2single(imread(files{1}));
% [height, width, ~] = size(test); 
% intensity = double(zeros(height, width, 3));
% % compute gradient and sum intensity
% gradientMag = zeros(height, width, 3);
% for i = 1:frameNum
%     test = im2single(imread(files{i}));
%     for j = 1:3
%         [gm,~] = imgradient(test(:,:,j));
%         gradientMag(:,:,j) = gradientMag(:,:,j) + gm;
%     end
%     intensity = intensity + test;
% end
% disp('gradient done.');

% average all frames
avgI = intensity/frameNum;
avgGradientI = gradientMag/frameNum;
disp('average done.');
imwrite(avgI,'averagI.jpg');
imwrite(normalize(avgGradientI),'averagGradientI.jpg');

% transform color space
hsvAvgI = rgb2hsv(avgI);
hsvAvgGradientI = rgb2hsv(avgGradientI);

% RANSAC for each channel
iterationNum = 20;
disp('lightness channel ');
disp('intensity');
fitMasks = zeros(height, width,iterationNum,2);
[hsvAvgI(:,:,3), fitMasks(:,:,:,1)] = ransac(hsvAvgI(:,:,3), iterationNum);
disp('gradient');
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

filesNum = [41 546 1046 1366];
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
