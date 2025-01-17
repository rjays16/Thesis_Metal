% Read an image into MATLAB
      
function varargout = main(varargin)


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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

function main_OpeningFcn(hObject, eventdata, handles, varargin)
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
ah = axes('unit', 'normalized', 'position', [0 0 1 1]);
bg = imread('background.png'); imagesc(bg);

set(ah,'handlevisibility','off','visible','off')

uistack(ah, 'bottom');

handles.output = hObject;
      
guidata(hObject, handles);



function varargout = main_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles) 
set(handles.pushbutton1,'enable','off');
set(handles.pushbutton2,'enable','on');

try
    x = 0;
    [status_apache, result_apache] = system('systemctl is-active apache2');
    [status_mysql, result_mysql] = system('systemctl is-active mysql'); 
    data = urlread('http://localhost/');
    
    if status_apache == 0 && status_mysql == 0 && strcmp(result_apache, 'active') && strcmp(result_mysql, 'active') || ~isempty(data)
        wb = waitbar(x,'Start Opening Camera');
        waitbar(x + 0.2, wb, 'Start Opening Camera...'); 
        camera1 = webcam('USB2.0 VGA UVC WebCam');
        camera2 = webcam('Full HD 1080P PC Camera');
        waitbar(x + 0.4, wb, 'Classify Images...');
        alex = alexnet;
        layers = alex.Layers;
        layers(23) = fullyConnectedLayer(4);
        layers(25) = classificationLayer; 
        allImages = imageDatastore('myImages', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
        [trainingImages, testImages] = splitEachLabel(allImages, 0.8, 'randomize');
        waitbar(x + 0.6, wb, 'Read Sizes of Images...');
        opts = trainingOptions('sgdm', 'InitialLearnRate', 0.001, 'MaxEpochs', 20, 'MiniBatchSize', 64);
        myNet = trainNetwork(trainingImages, layers, opts);
        waitbar(x + 0.8, wb, 'Re training Images for classify images');
        waitbar(x + 1, wb, 'Done');
        delete(wb);
        conn = database('thesis','root','');
        
            picture = camera1.snapshot;
            picture_resize = imresize(picture,[227,227]);
            picture2 = camera2.snapshot;
            picture2_resize = imresize(picture2,[227,227]);
            testImages = picture_resize; picture2_resize;
            predictedLabels = classify(myNet, testImages);
            imshow(picture, 'Parent', handles.axes1);
            imshow(picture2, 'Parent', handles.axes2);
            drawnow;
        
            if predictedLabels == 'Bridge'
                set(handles.editBridge, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
                
                imshow(picture, 'Parent', handles.axes1);
                drawnow limitrate;
                
                A = [150 800 300 500];
                cropped_imageA = imcrop(picture, A);
                input_dataA = single(cropped_imageA);
                input_dataA = (input_dataA - 128) / 128;
                picture_resizeA = imresize(input_dataA,[227,227]);
                predictedLabelsA = classify(myNet, picture_resizeA);
                
                B = [460 800 260 500];
                cropped_imageB = imcrop(picture, B);
                input_dataB = single(cropped_imageB);
                input_dataB = (input_dataB - 128) / 128;
                picture_resizeB = imresize(input_dataB,[227,227]);
                predictedLabelsB = classify(myNet, picture_resizeB);
                
                C = [730 800 300 500];
                cropped_imageC = imcrop(picture, C);
                input_dataC = single(cropped_imageC);
                input_dataC = (input_dataC - 128) / 128;
                picture_resizeC = imresize(input_dataC,[227,227]);
                predictedLabelsC = classify(myNet, picture_resizeC);
                
                D = [1050 800 300 500];
                cropped_imageD = imcrop(picture, D);
                input_dataD = single(cropped_imageD);
                input_dataD = (input_dataD - 128) / 128;
                picture_resizeD = imresize(input_dataD,[227,227]);
                predictedLabelsD = classify(myNet, picture_resizeD);
                
                E = [1340 800 300 500];
                cropped_imageE = imcrop(picture, E);
                input_dataE = single(cropped_imageE);
                input_dataE = (input_dataE - 128) / 128;
                picture_resizeE = imresize(input_dataE,[227,227]);
                predictedLabelsE = classify(myNet, picture_resizeE);
                
                F = [1650 800 350 500];
                cropped_imageF = imcrop(picture, F);
                input_dataF = single(cropped_imageF);
                input_dataF = (input_dataF - 128) / 128;
                picture_resizeF = imresize(input_dataF,[227,227]);
                predictedLabelsF = classify(myNet, picture_resizeF);
                
                hold on;
                rectangle('Position', A, 'EdgeColor', 'red');
                text(400, 750, 'A', 'Color', 'red', 'FontSize', 20);
                hold off;
 
                hold on;
                rectangle('Position', B, 'EdgeColor', 'b');
                text(700, 750, 'B', 'Color', 'b', 'FontSize', 20);
                hold off;
 
                hold on;
                rectangle('Position', C, 'EdgeColor', 'r');
                text(1000, 750, 'C', 'Color', 'r', 'FontSize', 20);
                hold off;
 
                hold on;
                rectangle('Position', D, 'EdgeColor', 'b');
                text(1310, 750, 'D', 'Color', 'b', 'FontSize', 20);
                hold off;
 
                hold on;
                rectangle('Position', E, 'EdgeColor', 'r');
                text(1600, 750, 'E', 'Color', 'r', 'FontSize', 20);
                hold off;
 
                hold on;
                rectangle('Position', F, 'EdgeColor', 'b');
                text(1970, 750, 'F', 'Color', 'b', 'FontSize', 20);
                hold off;
                
                
                imshow(picture, 'Parent', handles.axes1);
                imshow(picture2, 'Parent', handles.axes2);
                 
                if predictedLabelsA == 'Buckle'
                   set(handles.editA, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
                   gray = rgb2gray(picture_resizeA);
                   edges = edge(gray, 'Canny');
                   [H, theta, rho] = hough(edges);
                   peaks = houghpeaks(H, 5);
                   angle = theta(peaks(2, 2));
                   angle = angle * 180 / pi;
                   degrees = angle * (180/pi);
                   degrees = floor(degrees / 1000);
                   result_degree = mod(degrees, 1000);
                   
                   set(handles.editAngleA, 'ForegroundColor', 'g', 'string', angle);
                   set(handles.editDegreeA, 'ForegroundColor', 'g', 'string', [num2str(result_degree), char(176)]);
                   
                else
                   set(handles.editA, 'ForegroundColor', 'r', 'string', 'X');
                   set(handles.editAngleA, 'ForegroundColor', 'r', 'string', 'X');
                   set(handles.editDegreeA, 'ForegroundColor', 'r', 'string', 'X');
                end
                
                if predictedLabelsB == 'Buckle'
                   set(handles.editB, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
                   gray = rgb2gray(picture_resizeA);
                   edges = edge(gray, 'Canny');
                   [H, theta, rho] = hough(edges);
                   peaks = houghpeaks(H, 5);
                   angle = theta(peaks(2, 2));
                   angle = angle * 180 / pi;
                   degrees = angle * (180/pi);
                   degrees = floor(degrees / 1000);
                   result_degree = mod(degrees, 1000);
                   
                   set(handles.editAngleB, 'ForegroundColor', 'g', 'string', angle);
                   set(handles.editDegreeB, 'ForegroundColor', 'g', 'string', [num2str(result_degree), char(176)]);
                else
                   set(handles.editB, 'ForegroundColor', 'r', 'string', 'X');
                   set(handles.editAngleB, 'ForegroundColor', 'r', 'string', 'X');
                   set(handles.editDegreeB, 'ForegroundColor', 'r', 'string', 'X');
                end
                
                if predictedLabelsC == 'Buckle'
                   set(handles.editC, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
                   gray = rgb2gray(picture_resizeC);
                   edges = edge(gray, 'Canny');
                   [H, theta, rho] = hough(edges);
                   peaks = houghpeaks(H, 5);
                   angle = theta(peaks(2, 2));
                   angle = angle * 180 / pi;
                   degrees = angle * (180/pi);
                   degrees = floor(degrees / 1000);
                   result_degree = mod(degrees, 1000);
                   
                   set(handles.editAngleC, 'ForegroundColor', 'g', 'string', angle);
                   set(handles.editDegreeC, 'ForegroundColor', 'g', 'string', [num2str(result_degree), char(176)]);
                else
                   set(handles.editC, 'ForegroundColor', 'r', 'string', 'X');
                   set(handles.editAngleC, 'ForegroundColor', 'r', 'string', 'X');
                   set(handles.editDegreeC, 'ForegroundColor', 'r', 'string', 'X');
                end
                
                if predictedLabelsD == 'Buckle'
                   set(handles.editD, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
                   gray = rgb2gray(picture_resizeD);
                   edges = edge(gray, 'Canny');
                   [H, theta, rho] = hough(edges);
                   peaks = houghpeaks(H, 5);
                   angle = theta(peaks(2, 2));
                   angle = angle * 180 / pi;
                   degrees = angle * (180/pi);
                   degrees = floor(degrees / 1000);
                   result_degree = mod(degrees, 1000);
                   
                   set(handles.editAngleD, 'ForegroundColor', 'g', 'string', angle);
                   set(handles.editDegreeD, 'ForegroundColor', 'g', 'string', [num2str(result_degree), char(176)]);
                else
                   set(handles.editD, 'ForegroundColor', 'r', 'string', 'X');
                   set(handles.editAngleD, 'ForegroundColor', 'r', 'string', 'X');
                   set(handles.editDegreeD, 'ForegroundColor', 'r', 'string', 'X');
                end
                
                if predictedLabelsE == 'Buckle'
                   set(handles.editE, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
                   gray = rgb2gray(picture_resizeE);
                   edges = edge(gray, 'Canny');
                   [H, theta, rho] = hough(edges);
                   peaks = houghpeaks(H, 5);
                   angle = theta(peaks(2, 2));
                   angle = angle * 180 / pi;
                   degrees = angle * (180/pi);
                   degrees = floor(degrees / 1000);
                   result_degree = mod(degrees, 1000);
                   
                   set(handles.editAngleE, 'ForegroundColor', 'g', 'string', angle);
                   set(handles.editDegreeE, 'ForegroundColor', 'g', 'string', [num2str(result_degree), char(176)]);
                else
                   set(handles.editE, 'ForegroundColor', 'r', 'string', 'X');
                   set(handles.editAngleE, 'ForegroundColor', 'r', 'string', 'X');
                   set(handles.editDegreeE, 'ForegroundColor', 'r', 'string', 'X');
                end
                
                if predictedLabelsF == 'Buckle'
                   set(handles.editF, 'ForegroundColor', 'g', 'string', char(hex2dec('2713')));
                   gray = rgb2gray(picture_resizeF);
                   edges = edge(gray, 'Canny');
                   [H, theta, rho] = hough(edges);
                   peaks = houghpeaks(H, 5);
                   angle = theta(peaks(2, 2));
                   angle = angle * 180 / pi;
                   degrees = angle * (180/pi);
                   degrees = floor(degrees / 1000);
                   result_degree = mod(degrees, 1000);
                   
                   set(handles.editAngleF, 'ForegroundColor', 'g', 'string', angle);
                   set(handles.editDegreeF, 'ForegroundColor', 'g', 'string', [num2str(result_degree), char(176)]);
                else
                   set(handles.editF, 'ForegroundColor', 'r', 'string', 'X');
                   set(handles.editAngleF, 'ForegroundColor', 'r', 'string', 'X');
                   set(handles.editDegreeF, 'ForegroundColor', 'r', 'string', 'X');
                end
                
                if predictedLabelsA == 'Buckle' || predictedLabelsB == 'Buckle' || predictedLabelsC == 'Buckle' || predictedLabelsD == 'Buckle' || predictedLabelsE == 'Buckle' || predictedLabelsF == 'Buckle'
                    query = 'UPDATE status_table SET status = 1 WHERE id = 0';
                    exec(conn, query);
                else
                    query = 'UPDATE status_table SET status = 0 WHERE id = 0';
                    exec(conn, query);
                end
            else  
                set(handles.editBridge, 'ForegroundColor', 'r', 'string', 'X');   
                set(handles.editA, 'ForegroundColor', 'r', 'string', 'X');
                set(handles.editB, 'ForegroundColor', 'r', 'string', 'X');   
                set(handles.editC, 'ForegroundColor', 'r', 'string', 'X');   
                set(handles.editD, 'ForegroundColor', 'r', 'string', 'X');   
                set(handles.editE, 'ForegroundColor', 'r', 'string', 'X');   
                set(handles.editF, 'ForegroundColor', 'r', 'string', 'X');
                set(handles.editG, 'ForegroundColor', 'r', 'string', 'X');   
            end
    end
catch ME
    errordlg(['Error checking services: ' ME.message]);
    set(handles.pushbutton1,'enable','on');
    set(handles.pushbutton2,'enable','off');
    system('start C:\xampp\xampp-control.exe');
end
function pushbutton4_Callback(hObject, eventdata, handles)

close all; clear all; clc; delete(gcp('nocreate'));


function editBridge_Callback(hObject, eventdata, handles)


function editBridge_CreateFcn(hObject, eventdata, handles)

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

function uipanel2_CreateFcn(hObject, eventdata, handles)


function figure1_SizeChangedFcn(hObject, eventdata, handles)

function pushbutton5_Callback(hObject, eventdata, handles)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to editBridge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBridge as text
%        str2double(get(hObject,'String')) returns contents of editBridge as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBridge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on pushbutton4 and none of its controls.
function pushbutton4_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton1.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.editBridge, 'ForegroundColor', 'red', 'string', '');
set(handles.editA, 'ForegroundColor', 'r', 'string', '');
set(handles.editB, 'ForegroundColor', 'r', 'string', '');   
set(handles.editC, 'ForegroundColor', 'r', 'string', '');   
set(handles.editD, 'ForegroundColor', 'r', 'string', '');   
set(handles.editE, 'ForegroundColor', 'r', 'string', '');   
set(handles.editF, 'ForegroundColor', 'r', 'string', '');
set(handles.editG, 'ForegroundColor', 'r', 'string', '');
set(handles.editAngleA, 'ForegroundColor', 'g', 'string', '');
set(handles.editAngleB, 'ForegroundColor', 'g', 'string', '');
set(handles.editAngleC, 'ForegroundColor', 'g', 'string', '');
set(handles.editAngleD, 'ForegroundColor', 'g', 'string', '');
set(handles.editAngleE, 'ForegroundColor', 'g', 'string', '');
set(handles.editAngleF, 'ForegroundColor', 'g', 'string', '');
set(handles.editDegreeA, 'ForegroundColor', 'g', 'string', '');
set(handles.editDegreeB, 'ForegroundColor', 'g', 'string', '');
set(handles.editDegreeC, 'ForegroundColor', 'g', 'string', '')
set(handles.editDegreeD, 'ForegroundColor', 'g', 'string', '');
set(handles.editDegreeE, 'ForegroundColor', 'g', 'string', '');
set(handles.editDegreeF, 'ForegroundColor', 'g', 'string', '');
set(handles.pushbutton1,'enable','on');
set(handles.pushbutton2,'enable','off');
clear all; clc;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all; clear all; clc; delete(gcp('nocreate'));



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editA_Callback(hObject, eventdata, handles)
% hObject    handle to editA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editA as text
%        str2double(get(hObject,'String')) returns contents of editA as a double


% --- Executes during object creation, after setting all properties.
function editA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editB_Callback(hObject, eventdata, handles)
% hObject    handle to editB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editB as text
%        str2double(get(hObject,'String')) returns contents of editB as a double


% --- Executes during object creation, after setting all properties.
function editB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editG_Callback(hObject, eventdata, handles)
% hObject    handle to editG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editG as text
%        str2double(get(hObject,'String')) returns contents of editG as a double


% --- Executes during object creation, after setting all properties.
function editG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editC_Callback(hObject, eventdata, handles)
% hObject    handle to editC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editC as text
%        str2double(get(hObject,'String')) returns contents of editC as a double


% --- Executes during object creation, after setting all properties.
function editC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editH_Callback(hObject, eventdata, handles)
% hObject    handle to editE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editE as text
%        str2double(get(hObject,'String')) returns contents of editE as a double


% --- Executes during object creation, after setting all properties.
function editH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editD_Callback(hObject, eventdata, handles)
% hObject    handle to editD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editD as text
%        str2double(get(hObject,'String')) returns contents of editD as a double


% --- Executes during object creation, after setting all properties.
function editD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editE_Callback(hObject, eventdata, handles)
% hObject    handle to editE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editE as text
%        str2double(get(hObject,'String')) returns contents of editE as a double


% --- Executes during object creation, after setting all properties.
function editE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editF_Callback(hObject, eventdata, handles)
% hObject    handle to editF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editE as text
%        str2double(get(hObject,'String')) returns contents of editE as a double


% --- Executes during object creation, after setting all properties.
function editF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAngleA_Callback(hObject, eventdata, handles)
% hObject    handle to editAngleA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAngleA as text
%        str2double(get(hObject,'String')) returns contents of editAngleA as a double


% --- Executes during object creation, after setting all properties.
function editAngleA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAngleA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDegreeA_Callback(hObject, eventdata, handles)
% hObject    handle to editDegreeA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDegreeA as text
%        str2double(get(hObject,'String')) returns contents of editDegreeA as a double


% --- Executes during object creation, after setting all properties.
function editDegreeA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDegreeA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAngleB_Callback(hObject, eventdata, handles)
% hObject    handle to editAngleB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAngleB as text
%        str2double(get(hObject,'String')) returns contents of editAngleB as a double


% --- Executes during object creation, after setting all properties.
function editAngleB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAngleB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDegreeB_Callback(hObject, eventdata, handles)
% hObject    handle to editDegreeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDegreeB as text
%        str2double(get(hObject,'String')) returns contents of editDegreeB as a double


% --- Executes during object creation, after setting all properties.
function editDegreeB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDegreeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit46_Callback(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit46 as text
%        str2double(get(hObject,'String')) returns contents of edit46 as a double


% --- Executes during object creation, after setting all properties.
function edit46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDegreeC_Callback(hObject, eventdata, handles)
% hObject    handle to editDegreeC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDegreeC as text
%        str2double(get(hObject,'String')) returns contents of editDegreeC as a double


% --- Executes during object creation, after setting all properties.
function editDegreeC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDegreeC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAngleD_Callback(hObject, eventdata, handles)
% hObject    handle to editAngleD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAngleD as text
%        str2double(get(hObject,'String')) returns contents of editAngleD as a double


% --- Executes during object creation, after setting all properties.
function editAngleD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAngleD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDegreeD_Callback(hObject, eventdata, handles)
% hObject    handle to editDegreeD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDegreeD as text
%        str2double(get(hObject,'String')) returns contents of editDegreeD as a double


% --- Executes during object creation, after setting all properties.
function editDegreeD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDegreeD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAngleE_Callback(hObject, eventdata, handles)
% hObject    handle to editAngleE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAngleE as text
%        str2double(get(hObject,'String')) returns contents of editAngleE as a double


% --- Executes during object creation, after setting all properties.
function editAngleE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAngleE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDegreeE_Callback(hObject, eventdata, handles)
% hObject    handle to editDegreeE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDegreeE as text
%        str2double(get(hObject,'String')) returns contents of editDegreeE as a double


% --- Executes during object creation, after setting all properties.
function editDegreeE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDegreeE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAngleF_Callback(hObject, eventdata, handles)
% hObject    handle to editAngleF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAngleF as text
%        str2double(get(hObject,'String')) returns contents of editAngleF as a double


% --- Executes during object creation, after setting all properties.
function editAngleF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAngleF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDegreeF_Callback(hObject, eventdata, handles)
% hObject    handle to editDegreeF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDegreeF as text
%        str2double(get(hObject,'String')) returns contents of editDegreeF as a double


% --- Executes during object creation, after setting all properties.
function editDegreeF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDegreeF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAngleG_Callback(hObject, eventdata, handles)
% hObject    handle to editAngleG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAngleG as text
%        str2double(get(hObject,'String')) returns contents of editAngleG as a double


% --- Executes during object creation, after setting all properties.
function editAngleG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAngleG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDegreeG_Callback(hObject, eventdata, handles)
% hObject    handle to editDegreeG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDegreeG as text
%        str2double(get(hObject,'String')) returns contents of editDegreeG as a double


% --- Executes during object creation, after setting all properties.
function editDegreeG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDegreeG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
