clear all
close all

% Cargar la imagen
I = imread('coins.png');

% Convertir la imagen a escala de grises
gray =I;

% Binarizar la imagen utilizando un umbral adaptativo
bw = imbinarize(gray, 'adaptive');

% Realizar la Transformada de Hough
%% 15 y 30 son parámetros recomendados en toolbox MATLAB
[centers, radii] = imfindcircles(bw, [15, 30]);

% Mostrar la imagen con los círculos detectados
imshow(I);
hold on;
viscircles(centers, radii, 'EdgeColor', 'g');

