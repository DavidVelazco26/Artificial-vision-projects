% Get the desired number of gray levels from the user


user_choice=menu('What action do you want to perform?',  'Enter some scale',  'See all grayscales number specific of gray levels ');
% Read the image
image= imread('Fig2.21(a).jpg');

switch(user_choice)
    case 1
num_levels = input('Enter the desired number of gray levels (must be a power of 2): ');
imagelvl=escala_grises(image,num_levels);
    case 2
imagelvl_2=escala_grises(image,2);
imagelvl_4=escala_grises(image,4);
imagelvl_8=escala_grises(image,8);
imagelvl_16=escala_grises(image,16);
imagelvl_32=escala_grises(image,32);
imagelvl_64=escala_grises(image,64);
imagelvl_128=escala_grises(image,128);
figure(1)
subplot(2,4,1),imagesc(image);title('Original')
subplot(2,4,2),imagesc(imagelvl_128),title('Displayed in 128');
subplot(2,4,3),imagesc(imagelvl_64),title('Displayed in 64');
subplot(2,4,4),imagesc(imagelvl_32),title('Displayed in 32');
subplot(2,4,5),imagesc(imagelvl_16),title('Displayed in 16');
subplot(2,4,6),imagesc(imagelvl_8),title('Displayed in 8');
subplot(2,4,7),imagesc(imagelvl_4),title('Displayed in 4');
subplot(2,4,8),imagesc(imagelvl_2),title('Displayed in 2');
end


