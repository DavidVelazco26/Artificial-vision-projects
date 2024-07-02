
clear all
close all
% Complete example

flowerds = imageDatastore('WormImages','IncludeSubfolders',true,'LabelSource','foldernames');

%Split into training and testing sets

[trainImgs,testImgs] = splitEachLabel(flowerds,0.6);

%Determine the number of flower species

numClasses = numel(categories(flowerds.Labels));

%Create a network by modifying AlexNet
%Get the layers from AlexNet

net = alexnet;
layers = net.Layers;

%Modify the classification and output layers

layers(end-2) = fullyConnectedLayer(numClasses);
layers(end) = classificationLayer;

%Set training algorithm options
%Lower the learning rate for transfer learning

options = trainingOptions('sgdm','InitialLearnRate', 0.001);

% Redimensiona las imágenes de entrenamiento al tamaño esperado
resizedTrainImgs = augmentedImageDatastore([227 227], trainImgs);

%Perform training

[flowernet,info] = trainNetwork(resizedTrainImgs, layers, options);

%Use the trained network to classify test images

testpreds = classify(flowernet,testImgs);

%Evaluate the results
%Calculate the accuracy

nnz(testpreds == testImgs.Labels)/numel(testpreds)

%Visualize the confusion matrix

[flowerconf,flowernames] = confusionmat(testImgs.Labels,testpreds);

heatmap(flowernames,flowernames,flowerconf);

plot(info.TrainingLoss)

% Check

dsflowers = imageDatastore(pathToImages,'IncludeSubfolders',true,'LabelSource','foldernames');

[trainImgs,testImgs] = splitEachLabel(dsflowers,0.98);

flwrActual =testImgs.Labels


numCorrect= nnz(flwrPreds == flwrActual)

fracCorrect = numCorrect/numel(flwrPreds)



confusionchart(testImgs.Labels,flwrPreds)