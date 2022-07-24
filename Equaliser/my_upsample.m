% This function can upsample the signal by M factor
% First change the length of the signal by padding zeros
% Then pass through the low pass filter to avoid aliasing.

function y = my_upsample(x,M)

L = M*length(x);
x_up = zeros(L,1);
x_up(1:M:end) = x;
% pass through lowpass filter, normalised cut-off frequency --> 1/M 
wn = 1/M;
n = 200;
b = fir1(n,wn,'low');
y = Hanyu_filter(b,x_up);
    
end