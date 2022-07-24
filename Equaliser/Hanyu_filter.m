% This is a function like 'filter()' MATLAB build in function
% First do convolution and make the length equal to the signal.
% Using the shift mutiple principle of convolution.

function y = Hanyu_filter(h, x)
% b should be an column vector and x should be a row vector
[row_h,col_h] = size(h);
[row_x,col_x] = size(x);
if col_h ~= 1
    h = h';
elseif row_x ~= 1
    x = x';
end
% convolution
L_sig = length(x);
L_sys = length(h);
L = L_sig+L_sys-1; % the signal size after convolution
y = zeros(L,1);  % output is a column vector.
for i = 1:L_sig
    res_sum = x(i)*h;
    y(i:i+L_sys-1) = y(i:i+L_sys-1) + res_sum;
end
y = y(1:L_sig); % cut off the signal to length same as input signal
end

