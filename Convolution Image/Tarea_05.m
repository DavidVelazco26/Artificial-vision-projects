clear all;
%Read the image
I=double(imread('Fig3.35(a).jpg'));

%Determinate the dimension
[rows,cols]=size(I);

% You can modificate the coefficients in the program

%Examples

% Edge enhancement
% [[0,-1,0],[-1,5,-1],[0,-1,0]]
% Edge detection
% [[-1, -1, -1], [-1, 8,-1], [-1, -1, -1]]
% Blur
% [[1/9, 1/9, 1/9], [1/9, 1/9,1/9], [1/9, 1/9, 1/9]]
% Sharpening
% [[0,-1,0],[-1,9,-1],[0,-1,0]]

%Determinate the kernel
mask = input('Introduce los coeficientes de la mascara espacial de 3x3 separados por coma: ');
mask = reshape(mask, [3,3]);

% Variable where we save convolution matrix 
g=zeros(rows,cols);
for i=2:rows-1
    for j=2:cols-1
        i2=I(i-1:i+1,j-1:j+1);
        % Se suman los extremos hasta i+1 y j+1 
        g(i,j)=sum(sum(mask.*i2));
    end
end

% Show convolution imagen
colormap("gray");
figure(1)
subplot(1,2,1),imagesc(I),title('Original image');
subplot(1,2,2),imagesc(g),title('Convulation image');






