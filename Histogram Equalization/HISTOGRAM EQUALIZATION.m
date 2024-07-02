% Read the image
%im=imread('Fig3.15(a)3.jpg');
image=imread('Fig3.15(a)3.jpg');
% Determinate dimension imagen
[r,c]=size(image);
% Create histogram vector for counting pixel occurrences from 0 to 255
histogram= zeros(256,1);
for r=1:1:r
    for c=1:1:c
        % we add one for fit the scale
        point=image(r,c)+1;
        % Update histogram each time a pixel value is found
        histogram(point)=histogram(point)+1;
    end
end
% We regulate histogram
hist=histogram/(r*c);
n=256;
% The gray-levels in an image may be viewed as random
% variables in the interval [0,1]. A transformation function of
% particular importance in image processing has the form
cumulative=zeros(n,1);
a=hist(1);
for i=2:1:n
    a=a+hist(i);
    cumulative(i)=a;
end
tolerancia=eps(10.0);
%cpd
for i=1:1:n
    % Absolute valore
    if abs(cumulative(i)-0.0)> tolerancia
        al=i-1;
        break
    end
end
for i=n:-1:1
    if abs(cumulative(i)-1)<tolerancia
        acom=i-1;
        break
    end
end
% Fit values
value=(n-1)/(acom-al);
for r=1:1:r
    for c=1:1:c
        image(r,c)=value*(image(r,c)-al);
    end
end
% Create histogram vector of the enhanced image
histo_vec=zeros(n,1);
for r=1:1:r
    for c= 1:1:c
        point=image(r,c)+1;
        histo_vec(point)=histo_vec(point) + 1;
    end
end
% 90:255
hist_normalizad=histo_vec/(r*c);
dominio=al:acom;
range=value*(dominio-al);
colormap("gray")
figure(1)
subplot(2,3,1),imshow(image),title('Original');
subplot(2,3,2),bar(hist),title(['Normalized histogram']);
subplot(2,3,3),scatter(dominio, range, 'r');title(['Equalization function']);
subplot(2,3,4),imagesc(image);title(['Enhanced image']);
subplot(2,3,5),bar(hist_normalizad);title('Normalized histogram (enhanced)');
subplot(2,3,6),plot(cumulative,'r');title('Cumulative distribution function (CDF)');
