% This function can first upsample the signal by 'L_up' factor and then
% downsample the signal by 'M_down' factor.

function y = my_up_down_sample(x,L_up,M_down)

L = L_up*length(x);
x_up = zeros(L,1);
x_up(1:L_up:end) = x; % up sample the signal by padding zeros
wn = min(1/L_up,1/M_down);
n = 200;
b = fir1(n,wn,'low'); % pass through the low pass filter
x_down = Hanyu_filter(b,x_up);
y = M_down*x_down(1:M_down:end); % decimate by M_down
    
end
    