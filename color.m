clear all
clc;

path1 = 'F:\Study\UnderGrad\Graduation Design\Data\heiti201709baitian\2017\09\0914\dn\';
path2 = '20170914-103053F_1000_675_0.tiff';
filepath = fullfile(path1,path2);

% filepath='F:\Study\UnderGrad\Graduation Design\Data\heiti201709baitian\2017\09\0915\dn\20170915-110053F_1000_675_0.tiff';               %%图像名称与路径
Info=imfinfo(filepath);                                      %judge whether the picture is tif
 
tif='tif';
format=Info.Format;
if  (strcmp(format ,tif)==0)
    disp('载入的不是tif图像，请确认载入的数据');                %make sure it is tiff
end
Slice=size(Info,1);                                          %get z
Width=Info.Width;
Height=Info.Height;
 
Image=zeros(Height,Width,Slice*3);
 
for i=1:Slice
    Image(:,:,(i-1)*3+1:i*3)=imread(filepath,i);                 %red color image one slice by one slice
end

I(:,:,1) = Image(:,:,1);%/(2^13);
Imax = max(I(:));
Imin = min(I(:));
In(:,:,3) =(I - Imin)/(Imax - Imin);
% imshow(In);

K(:,:,1) = Image(:,:,2);%/(2^13);
Imax = max(K(:));
Imin = min(K(:));
In(:,:,2) = (K - Imin)/(Imax - Imin);
 
L(:,:,1) = Image(:,:,3);%/(2^13);
Imax = max(L(:));
Imin = min(L(:));
In(:,:,1) = (L - Imin)/(Imax - Imin);

M =In;% cat(3,[In ; Kn; Ln]);

I2=rot90(M,2);
% imshow((I2));


%----- color -----

r = 15; %depth map scale
% beta = 0.59;
% beta = 0.3976;
beta = 0.7575;
% beta = 0.4395;
% beta = 1.0;

%----- Parameters for Guided Image Filtering -----
gimfiltR = 60;
eps = 10^-3;
%-------------------------------------------------
tic;
[dR, dP] = calVSMap(I2, r);
% refineDR = fastguidedfilter_color(double(I2)/255, dP, r, eps, r/4);
% refineDR = fastguidedfilter_color(I2, dP, r, eps, r/4);
% refineDR = imguidedfilter(dR, double(I2)/255, 'NeighborhoodSize', [gimfiltR, gimfiltR], 'DegreeOfSmoothing', eps);
refineDR = imguidedfilter(dR, I2, 'NeighborhoodSize', [gimfiltR, gimfiltR], 'DegreeOfSmoothing', eps);
tR = exp(-beta*refineDR);%according to transmission femula, compute the transmission map
tP = exp(-beta*dP);

imwrite(dR, 'originalDepthMap.png');
imwrite(refineDR, 'refineDepthMap.png');

figure;
dPn=(dP-min(dP(:)))/(max(dP(:))-min(dP(:)));
dRn=(dR-min(dR(:)))/(max(dR(:))-min(dR(:)));
refineDRn=(refineDR-min(refineDR(:)))/(max(refineDR(:))-min(refineDR(:)));
imshow([dPn dRn refineDRn]);
title('depth maps');

figure;
tPn=(tP-min(tP(:)))/(max(tP(:))-min(tP(:)));
tRn=(tR-min(tR(:)))/(max(tR(:))-min(tR(:)));
imshow([tPn tRn]);
title('transmission maps');
imwrite(tR, 'transmission.png');

% a = estA(I2, dR);
a = estA(I2, refineDR);
t0 = 0.05;
t1 = 1;
% I2 = double(I2)/255;
[h w c] = size(I2);
J = zeros(h,w,c);
J(:,:,1) = I2(:,:,1)-a(1);
J(:,:,2) = I2(:,:,2)-a(2);
J(:,:,3) = I2(:,:,3)-a(3);

% t = zeros(h,w);
% for i1 = 1:h
%     for i2 = 1:w
%     t(i1,i2) = t(i1,i2) + 0.9893;    
%     end
% end
% % 
t = tR;
% t = tP;
[th tw] = size(t);
for y=1:th
    for x=1:tw
        if t(y,x)<t0
            t(y,x)=t0;
        end
    end
end

for y=1:th
    for x=1:tw
        if t(y,x)>t1
            t(y,x)=t1;
        end
    end
end

J(:,:,1) = J(:,:,1)./t;
J(:,:,2) = J(:,:,2)./t;
J(:,:,3) = J(:,:,3)./t;

J(:,:,1) = J(:,:,1)+a(1);
J(:,:,2) = J(:,:,2)+a(2);
J(:,:,3) = J(:,:,3)+a(3);

toc; % recording time 
figure;
Imagen=(I2-min(I2(:)))/(max(I2(:))-min(I2(:)));
Jn=(J-min(J(:)))/(max(J(:))-min(J(:)));
imshow([Imagen Jn]);
title('hazy image and dehazed image');

saveName = ['' num2str(r) '_beta' num2str(beta) '.png'];
imwrite(J, saveName);