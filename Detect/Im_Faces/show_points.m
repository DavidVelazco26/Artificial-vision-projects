clear all;
close all

load data_points
I=double(imread('BioID_0001.pgm')); %1515
n=1;
imagesc(I)
colormap(gray)
hold on
plot(squeeze(data(n,1,:)),squeeze(data(n,2,:)),'oy')