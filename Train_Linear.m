close all;clear;clc;

load('F:\Study\Data\Dh.mat');
load('F:\Study\Data\Sh.mat');
load('F:\Study\Data\Vh.mat');
load('F:\Study\Data\Dg.mat');

v = Vh; s = Sh; d = Dh; dg = Dg;

n = size(v,1);

a = 5; p0 = 0; p1 = 1; p2 = -1;

Su = 0; wSum = 0; vSum = 0; sSum = 0; aSum = 0;

Lr = 0.002;

    for i = 1:n
        temp = dg(i) - d(i);  
        temp1 = p0 + p1*v(i) + p2*s(i);
        Su = Su + temp*temp;
        
        wSum = wSum + temp*(1-d(i))*d(i)*a;
        vSum = vSum + temp*(1-d(i))*d(i)*a*v(i); 
        sSum = vSum + temp*(1-d(i))*d(i)*a*s(i);
        aSum = aSum + temp*(1-d(i))*d(i)*temp1;
    end
        
    p0 = p0 + Lr*1000*wSum/n;
    p1 = p1 + Lr*vSum/n;
    p2 = p2 + Lr*sSum/n;  
    a = a + Lr*aSum/n;
