close all

% Load database of face reference points
load data_points.mat

% Findout how many images are there in the database and how many reference
% points all the images have
[imgCount,dimCount,ptsCount] = size(data);

% Get list of images
myDirInfo = dir("Im_Faces/");
myDirInfo = myDirInfo(3:imgCount+2);    % the first two elements are not images but linux directory artifacts

% Select reference image
refImgPath = "Im_Faces/" + myDirInfo(1).name;
refImg = imread(refImgPath);

% Points from the reference image
fixedPoints = data(1,:,:);
fixedPoints = reshape(fixedPoints, [dimCount,ptsCount]);
fixedPoints = fixedPoints';

ith = 25;
% Select a test image
testImgPath = "Im_Faces/" + myDirInfo(ith).name;
testImg = imread(testImgPath);

% Points from the test image
testPoints = data(ith,:,:);
testPoints = reshape(testPoints, [dimCount,ptsCount]);
testPoints = testPoints';

% Apply the transformation
tform = fitgeotrans(testPoints,fixedPoints,'affine'); % affine nonreflectivesimilarity
Roriginal = imref2d(size(refImg));
recovered = imwarp(testImg,tform,'OutputView',Roriginal);

