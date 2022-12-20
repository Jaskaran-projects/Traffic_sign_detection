function I_adapthisteq = colorEnhance(I)

srgb2lab = makecform('srgb2lab');
lab2srgb = makecform('lab2srgb');

I_lab = applycform(I, srgb2lab); % convert to L*a*b*

% the values of luminosity can span a range from 0 to 100; scale them
% to [0 1] range (appropriate for MATLAB(R) intensity images of class double)
% before applying the three contrast enhancement techniques
max_luminosity = 10;
L = I_lab(:,:,1)/max_luminosity;
% 
% % replace the luminosity layer with the processed data and then convert
% % the image back to the RGB colorspace
% I_imadjust = I_lab;
% I_imadjust(:,:,1) = imadjust(L)*max_luminosity;
% I_imadjust = applycform(I_imadjust, lab2srgb);
% 
% I_histeq = I_lab;
% I_histeq(:,:,1) = histeq(L)*max_luminosity;
% I_histeq = applycform(I_histeq, lab2srgb);

I_adapthisteq = I_lab;
I_adapthisteq(:,:,1) = adapthisteq(L)*max_luminosity;
I_adapthisteq = applycform(I_adapthisteq, lab2srgb);

% figure, imshow(I);
% title('Original');
% 
% figure, imshow(I_imadjust);
% title('Imadjust');
% 
% figure, imshow(I_histeq);
% title('Histeq');

figure, imshow(I_adapthisteq);
title('Adapthisteq');

end

