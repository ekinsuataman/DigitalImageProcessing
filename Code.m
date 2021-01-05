%170315022-Ekin ÞUATAMAN
close all;
clc;
clear;

%Loading Original and noise Image 
a=imread('images/original.tif');
subplot(1,2,1);
imshow(a);
title('Original Image');

b=imread('images/2.tif');
subplot(1,2,2);
imshow(b);
title('Image 2');

%applying 2-3 matrices and remove the salt pepper noise with median filter
b=medfilt2(b,[2 3]);
figure, imshow(b)
title('Median Filter');

%Paddedsize doubles the original image in two sizes
PQ=paddedsize(size(b));

%Notch filters for extra peaks in the Fourier Transform
H1=notch('btw',PQ(1),PQ(2),7,81,24);
H2=notch('btw',PQ(1),PQ(2),7,923,727);

%Calculate the Fourier Transform of the image
F=fft2(double(b),PQ(1),PQ(2));

%Apply array multiplication for each pixel
FS_b=F.*H1.*H2;

%Coverted result to spacial domain
F_b=real(ifft2(FS_b));

%For return to original size crop the image to undo padding 
F_b = F_b(1:size(b,1),1:size(b,2));
figure,imshow(F_b,[])
title('Notch Filter');

%Sharpining
sharp1=imsharpen(F_b);
figure, imshow(sharp1,[])
title('Sharpening Filter');

%where increasing brightness 
g = sharp1;

% Display the Fourier Spectrum 
% Move the origin of the transform to the center of the frequency rectangle.
Fc=F;
Fcf=fftshift(FS_b);

% use abs to compute the magnitude and use log to brighten display
S1=log(1+abs(Fc)); 
S2=log(1+abs(Fcf));
%figure, imshow(S1,[])
%figure, imshow(S2,[])

%where increasing brightness with gama
im = g/255; %normalize

g1 = 0.4;
out1 = 255*(g.^g1);
figure,imshow(out1, []);
title('After increased brightness with gama');


