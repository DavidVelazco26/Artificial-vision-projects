clear all
close all

%https://matlabacademy.mathworks.com/
% Instal from Add-Ons the pretained network
% Complete example

Worm = imageDatastore('WormImages','IncludeSubfolders',true,'LabelSource','foldernames');

%Split into training and testing sets

[trainImgs,testImgs] = splitEachLabel(Worm,0.7);

%Determine the number classes

numClasses = numel(categories(Worm.Labels));

%Create a network CNN
layers = [
    imageInputLayer([520 696 1])
    convolution2dLayer(7,16)
    batchNormalizationLayer
    reluLayer    
    convolution2dLayer(3,20)
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(4)
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer];
opts = trainingOptions('sgdm',...
    'InitialLearnRate',  0.0001, ...
    'MaxEpochs', 100, ...
    'MiniBatchSize',30,...
    'Shuffle','every-epoch',...
    'Plots', 'training-progress',...
    'Verbose',false,...
    'ExecutionEnvironment','gpu');
%Modify the classification and output layers

layers(end-2) = fullyConnectedLayer(numClasses);
layers(end) = classificationLayer;

%Perform training

trainedNet= trainNetwork(trainImgs, layers, opts);

%Use the trained network to classify test images

ypred = trainedNet.classify(testImgs);
cnnAccuracy = sum(ypred == testImgs.Labels)/numel(testImgs.Labels)*100;

%Matriz de confusión
figure
cchart = confusionchart(testImgs.Labels,ypred);
cchart.Title = 'Confusion Chart for Deep CNN';
cchart.RowSummary = 'row-normalized';
cchart.ColumnSummary = 'column-normalized';
