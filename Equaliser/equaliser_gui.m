%% ELEC 3104 Option E 
% Write by Hanyu Meng(z5194536)
% 16/11/2020
function varargout = equaliser_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @equaliser_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @equaliser_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before equaliser_gui is made visible.
function equaliser_gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = equaliser_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function pushbutton_stop_Callback(hObject, eventdata, handles)


% --- Executes on button press in pushbutton_start.
function pushbutton_start_Callback(hObject, eventdata, handles)
%% 1.Resample
file = handles.filename;
[x,fs] = audioread(file); % read the whole audio and resample to 16kHz
if fs == 8000 % up-sampling by 2
    x_r = my_upsample(x,2);
elseif fs == 44100 % upsampleing by 4 and down sampling by 11
    x_r = my_up_down_sample(x,4,11); 
elseif fs == 22050 % upsampling by 8 and down sampling by 11
    x_r = my_up_down_sample(x,8,11);
else
    x_r = x;
end
% Normalised the audio signal to avoid data clipped
max_value = max(abs(x_r));
x_r = x_r/max_value; 
% write the resampled audio signal into a file
Fs = 16e3;
audiowrite('16k_buffer_file.wav',x_r,Fs);

%% 2. Process the data in realtime
% get audio from real-time streaming
T = 1;  % the time for update data
n = 200;  % order of the filters
f = [100 400 1000 4000 7500];  % 5 frequency band
B = get_coef(f,n,Fs);  % get coefficient of 5 filter bank
fsize = T*Fs;  % frame size 
filereader = dsp.AudioFileReader('16k_buffer_file.wav','SamplesPerFrame',fsize);
devicewriter = audioDeviceWriter(Fs,'SupportVariableSizeInput',true);
fileinfo_16 = audioinfo('16k_buffer_file.wav');
fs_16 = fileinfo_16.SampleRate;  % get sample frequency of the audio file
% total times of the file
file_length = ceil(fileinfo_16.TotalSamples/fs_16); 
% fvtool(B(:,1),1,B(:,2),1,B(:,3),1,B(:,4),1,B(:,5),1);
% fvtool(B(:,1),1);

% use timer to ensure that the audio file can be fully played
tic;
while toc < file_length
    audio = filereader();
    audio = audio(:,1);
    gain1 = get(findobj('tag','slider1'),'value');
    gain2 = get(findobj('tag','slider2'),'value');
    gain3 = get(findobj('tag','slider3'),'value');
    gain4 = get(findobj('tag','slider4'),'value');
    gain5 = get(findobj('tag','slider5'),'value');
    gain_dB = [gain1 gain2 gain3 gain4 gain5];
    gain = 10.^(gain_dB./20);
    y = zeros(length(audio),1);
    for i = 1:5
        y = y + gain(i).*Hanyu_filter(B(:,i),audio(:,1));
    end
    devicewriter(y);
    drawnow();
end
release(filereader);
release(devicewriter);

% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% get the audio file name and address
[FileName, PathName] = uigetfile('*.wav','Please choose your wav file');
% show the file and path name
set(handles.text_address,'string',[PathName FileName]); 
[audio,fs] = audioread(FileName);
handles.data = audio;
handles.filename = FileName;
handles.fs = fs;
guidata(hObject,handles);

% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
gain5 = get(handles.slider5, 'Value');
handles.gain5 = gain5;
str5 = num2str(gain5);
set(handles.edit5,'String',str5);


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
    gain4 = get(handles.slider4, 'Value');
    handles.gain4 = gain4;
    str4 = num2str(gain4);
    set(handles.edit4,'String',str4);




% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider3_Callback(hObject, eventdata, handles)
    gain3 = get(handles.slider3, 'Value');
    handles.gain3 = gain3;
    str3 = num2str(gain3);
    set(handles.edit3,'String',str3);

function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider2_Callback(hObject, eventdata, handles)
    gain2 = get(handles.slider2, 'Value');
    handles.gain2 = gain2;
    str2 = num2str(gain2);
    set(handles.edit2,'String',str2);
    
function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider1_Callback(hObject, eventdata, handles)
    gain1 = get(handles.slider1, 'Value');
    handles.gain1 = gain1;
    str1 = num2str(gain1);
    set(handles.edit1,'String',str1);

function slider1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Filter_Bank_CreateFcn(hObject, eventdata, handles)
