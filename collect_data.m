close all;clear;clc;

inputImagePath = 'F:\Study\UnderGrad\Graduation Design\heiti201709baitian\2017\09\0901\dn\20170901-120055N_1000_675_0.tiff';
II = imread(inputImagePath);
I = tifread(inputImagePath);
r = 15;
beta = 1.0;

%----- Parameters for Guided Image Filtering -----
gimfiltR = 60;
eps = 10^-3;
%-------------------------------------------------
tic;
[dR, dP] = calVSMap(I, r);

rgb = I;
hsv = rgb2hsv(rgb);
H = hsv(:,:,1); % 色调
S = hsv(:,:,2); % 饱和度
V = hsv(:,:,3); % 亮度

Vh = V(:);
Sh = S(:);
Dh = dR(:);
Dg = dR(:);

save('F:\Study\Data\Vh.mat','Vh');
save('F:\Study\Data\Sh.mat','Sh');
save('F:\Study\Data\Dh.mat','Dh');
save('F:\Study\Data\Dg.mat','Dg');