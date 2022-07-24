# Realtime-five-channel-equaliser
A real-time five channel equaliser with graphic user interface implemented by MATLAB.

2020 T3 project for ELEC3104(Digital Signal Processing)
To play the equaliser please run the equaliser_gui.m file and select the wav file.
It accept .wav file sampled at 8kHz 16kHz 22.5kHz and 44.1kHz.
More detailed description please see the description in the user interface. : )


1.This program can equalise and play the audio signal for 5 band of frequency in realtime.

2.The equaliser_gui.m is the main function, first run this function and press 'Browse' button in GUI figure to chose the audio file to be played from current directory.

Then press 'Play' button to play the audio file in real-time. Sliding the 5 slider bars can change the gains of 5 frequency bands and get realtime sound effect.

3.There are 4 functions:
	Hanyu_filter: get the output of a signal passed through the low pass filter, which is similar to Matlab build in 'filter()' function, the input is the coefficient of the filter (column vector) and the original signal (row vector), and the output is a column vector which has same length as original signal.

	get_coef: get the coefficients of the filter bank. The input is a frequency vector, order(n) or the filters and the sampling frequency, and the output is an (n+1)*5 matrix corresponding to coefficients of five filters.

	my_upsample: up sample the signal by factor M, the input is the signal with sampling frequency of fs, and the original signal. The output is a signal with sampling frequency of fs*M.

	my_up_down_sample: first up sample a signal by factor of L_up and then down sample it by factor of M_down, the input is the signal with sampling frequency of fs, and the output is the signal with sampling frequency of fs*L_up/M_down.
