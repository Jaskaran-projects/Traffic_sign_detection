function im_red = hsiThreshR(im)
%Represent the RGB image in [0 1] range
I = im2double(im);
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);

%Hue
numi=1/2*((R-G)+(R-B));
denom=((R-G).^2+((R-B).*(G-B))).^0.5;

%To avoid divide by zero exception add a small number in the denominator
H=acosd(numi./(denom+0.000001));

%If B>G then H= 360-Theta
H(B>G)=360-H(B>G);

%Normalize to the range [0 1]
% H=H/360;
H = deg2rad(H);

%Saturation
S=1- (3./(sum(I,3)+0.000001)).*min(I,[],3);


%Intensity
I=sum(I,3)./3;


% %HSI
% HSI=zeros(size(A));
% HSI(:,:,1)=H;
% HSI(:,:,2)=S;
% HSI(:,:,3)=I;


im_red = ((H>=0)&(H<0.111*pi))|((H>=1.8*pi).*(H<2*pi)).*(S>0.1).*(S<=1).*(I>0.12).*(I<0.8);


end

