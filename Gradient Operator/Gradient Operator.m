clear all;
% Detecta lineas horizontales
Gy=[1,1,1;0,0,0;-1,-1,-1];
%Detecta lineas verticales
Gx=[-1,0,1;-1,0,1;-1,0,1];
% Laplacian
%w=[-1,-1,-1;-1,8,1;-1,-1,-1];
% Read image
I=double(imread('Fig3.45(a).jpg'));
% Determinate rows and columns
[rows,cols]=size(I);
% Create matix about Gx
g=zeros(rows,cols);
% Create matix about Gy
g2=zeros(rows,cols);
vf=zeros(rows,cols);
for i=2:rows-1
    for j=2:cols-1
        i2=I(i-1:i+1,j-1:j+1);
        g(i,j)=sum(sum(Gx.*i2));
        g2(i,j)=sum(sum(Gy.*i2));
    end
end
% The magnitude of this vector is given by
vf=(g.^2+g2.^2).^(1/2);
% Gradient direction
o=atan(g2./g);
% magnitude and direction
% Show image
figure()
subplot(2,3,1), imagesc(I),title(['Original']);
subplot(2,3,2), imagesc(g),title(['Gx']);
subplot(2,3,3), imagesc(g2),title(['Gy']);
subplot(2,3,4), imagesc(vf),title(['Vf']);
subplot(2,3,5), imagesc(o),title(['Angulo']);
subplot(2,3,6), quiver(g,g2),axis equal,title(['Vectors']);
colormap('gray');