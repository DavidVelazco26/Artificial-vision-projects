% Read the image
datos=imread('circle.png');
% Genterate double image
datos2=double(datos);
% transformada inversa de fourier
d=ifftshift(datos2);
f=ifft2(d);
f2=fftshift(f);
figure()
imagesc(abs(f2));
