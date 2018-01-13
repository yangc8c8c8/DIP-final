% RANSAC for each channel
avgI0 = zeros(height, width, 3);
avgGradientI0 = zeros(height, width, 3);
iterationNum = 20;
fitMasks = zeros(height, width, 6, iterationNum);
for i = 1:3
   disp(['channel ',num2str(i)]);
   disp('intensity');
   [avgI0(:,:,i), fitMasks(:,:,i,:)] = ransac(avgI(:,:,i), iterationNum);
   disp('gradient');
   [avgGradientI0(:,:,i), fitMasks(:,:,i+3,:)] = ransac(avgGradientI(:,:,i), iterationNum);
end
disp('ransac done.');
intensityMask = all(fitMasks(:,:,1:3,:),3);
gradientMask = all(fitMasks(:,:,4:6,:),3);
for i = 1:iterationNum
    imwrite(intensityMask(:,:,1,i),strcat('fitMask_',num2str(i),'.jpg'));
    imwrite(gradientMask(:,:,1,i),strcat('gradientFitMask_',num2str(i),'.jpg'));
end
imwrite(avgI0,'averagI0.jpg');
imwrite(normalize(avgGradientI0),'averagGradientI0.jpg');

filesNum = [41 546 1046 1366];
I0 = zeros(height, width, 3, size(filesNum,2));
C = zeros(size(filesNum,2), 3);
[alpha, beta] = solve_ab(avgI,avgI0,avgGradientI,avgGradientI0);
imwrite(alpha,'alpha.jpg');
imwrite(beta,'beta.jpg');
for i = 1: size(filesNum,2)
    test = im2single(imread(files{filesNum(i)}));
    for j = 1:3
        C(i,j) = solve_c(test(:,:,j),alpha(:,:,j),beta(:,:,j));
        I0(:,:,j,i) = (test(:,:,j)-C(i,j)*beta(:,:,j))./alpha(:,:,j);
    end
    imwrite(I0(:,:,:,i),strcat('I0_',num2str(filesNum(i)),'.jpg'));
end
