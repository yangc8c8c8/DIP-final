% initial 
% import pictures and compute average and gradient; 3 dimension for [hight(x), wideth(y), RGB, frame number]
jpegFiles = dir('./full_data/*.jpg'); 
frameNum = round(length(jpegFiles));
files = strcat('./full_data/', {jpegFiles(1:frameNum).name});
% observe size
test = im2single(imread(files{1}));
[height, width, ~] = size(test); 
intensity = double(zeros(height, width, 3));
% compute gradient and sum intensity
gradientMag = zeros(height, width, 3);
for i = 1:frameNum
    test = im2single(imread(files{i}));
    for j = 1:3
        [gm,~] = imgradient(test(:,:,j));
        gradientMag(:,:,j) = gradientMag(:,:,j) + gm;
    end
    intensity = intensity + test;
end
disp('gradient done.');

% average all frames
avgI = intensity/frameNum;
avgGradientI = gradientMag/frameNum;
disp('average done.');
imwrite(avgI,'averagI.jpg');
imwrite(normalize(avgGradientI),'averagGradientI.jpg');
