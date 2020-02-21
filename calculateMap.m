function [outputRegion outputPixel] = calVSMap(I, r)
if nargin < 2
    r = 15;
end
hsvI = rgb2hsv(I);
s = hsvI(:,:,2);
v = hsvI(:,:,3);
sigma = 0.041337;
sigmaMat = normrnd(0, sigma, size(I, 1), size(I, 2));

% Here is another parameters setting
%
% output = 0.1893 + 1.0267*v  - 1.2966*s; 
% output = -0.1 + 0.7*v  - 0.9*s; 
%  output = 0.121779 + 0.959710*v  - 0.880245*s;
output = 0.121779 + 0.959710*v  - 0.780245*s + sigmaMat;
outputPixel = output;
output = ordfilt2(output, 1, ones(r,r), 'symmetric'); % order = 1--;s = symmetric shows this filter is a 15*15, min filter
outputRegion = output;
imwrite(outputRegion, 'F:\vsFeature.jpg');
end
