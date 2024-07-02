close all
clear all

% Load database of face reference points
load data_points.mat

% Findout how many images are there in the database and how many reference
% points all the images have
[imgCount,dimCount,ptsCount] = size(data);

% Get list of images
myDirInfo = dir("Im_Faces/");
%myDirInfo = myDirInfo(3:imgCount+2);    % the first two elements are not images but linux directory artifacts

% Select reference image
refImgPath = "Im_Faces/" + myDirInfo(1).name;
refImg = imread(refImgPath);

% Points from the reference image
fixedPoints = data(1,:,:);
fixedPoints = reshape(fixedPoints, [dimCount,ptsCount]);
fixedPoints = fixedPoints';

errors = zeros(imgCount, 1);
for ith = 1:imgCount
    % ith = 25;
    % Select a test image
    testImgPath = "Im_Faces/" + myDirInfo(ith).name;
    testImg = imread(testImgPath);
    
    % Points from the test image
    movingPoints = data(ith,:,:);
    movingPoints = reshape(movingPoints, [dimCount,ptsCount]);
    movingPoints = movingPoints';
    
    % Apply the transformation
    tform = fitgeotrans(movingPoints,fixedPoints,'affine');    % affine nonreflectivesimilarity
    Roriginal = imref2d(size(refImg));
    recovered = imwarp(testImg,tform,'OutputView',Roriginal);

    % Compute the corresponding error
    movedPoints = transformPointsForward(tform, movingPoints);
    euclideanDistance = sqrt(sum((fixedPoints - movedPoints).^2, 2));
    errors(ith) = sum(euclideanDistance);
end

% Sort the errors and keep the best 100 indexes includding the reference
% image
[Errors, Indexes] = sort(errors);
bestImageIndexes = Indexes(1:100);

% Plot the best 100 movingPoints includding the reference points
index = bestImageIndexes(1);
movingPoints = data(ith,:,:);
movingPoints = reshape(movingPoints, [dimCount,ptsCount]);
movingPoints = movingPoints';
scatter(movingPoints(:,1), movingPoints(:,2), 'o', 'filled', 'red');

hold on

for ith = 2:100
    index = bestImageIndexes(ith);
    % Points from the test image
    movingPoints = data(ith,:,:);
    movingPoints = reshape(movingPoints, [dimCount,ptsCount]);
    movingPoints = movingPoints';

    s = scatter(movingPoints(:,1), movingPoints(:,2), 'd', 'filled', 'blue');
    s.MarkerFaceAlpha = 0.2;
    s.MarkerEdgeAlpha = 0.15;
end
