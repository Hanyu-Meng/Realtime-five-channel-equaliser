% This function can get coefficents of filters bank
% The filter bank consist with 1 low-pass filter and 4 band-passfilter

function B = get_coef(f,n,fs)
    wn = 2*f./fs; % normalise the frequency vector
    B(:,1) = fir1(n,wn(1),'low');
    B(:,2) = fir1(n,[wn(1) wn(2)]);
    B(:,3) = fir1(n,[wn(2) wn(3)]);
    B(:,4) = fir1(n,[wn(3) wn(4)]);
    B(:,5) = fir1(n,[wn(4) wn(5)]);
end