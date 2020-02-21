
clear all
clc;

path1 = 'F:\Study\UnderGrad\Graduation Design\Data\heiti201709baitian\2017\09\0907\dn\';
path2 = '20170907-113555F_1000_674_0.tiff';
filepath = fullfile(path1,path2);

% filepath='F:\Study\UnderGrad\Graduation Design\Data\heiti201709baitian\2017\09\0902\dn\20170902-143155F_2000_675_0.tiff';               %%图像名称与路径
Info=imfinfo(filepath);                                      %%获取图片信息并判断是否为tif
 
tif='tif';
format=Info.Format;
if  (strcmp(format ,tif)==0)
    disp('载入的不是tif图像，请确认载入的数据');                %%确保载入的图像是tiff图像
end
Slice=size(Info,1);                                          %%获取图片z向帧数
Width=Info.Width;
Height=Info.Height;
 
Image=zeros(Height,Width,Slice*3);
 
for i=1:Slice
    Image(:,:,(i-1)*3+1:i*3)=imread(filepath,i);                 %%一层一层的读入彩色图像
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
imshow((I2));

imwrite(I2, 'Clear.png');

