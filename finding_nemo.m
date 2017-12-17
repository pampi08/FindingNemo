function varargout = finding_nemo(varargin)
% FINDING_NEMO MATLAB code for finding_nemo.fig
%      FINDING_NEMO, by itself, creates a new FINDING_NEMO or raises the existing
%      singleton*.
%
%      H = FINDING_NEMO returns the handle to a new FINDING_NEMO or the handle to
%      the existing singleton*.
%
%      FINDING_NEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINDING_NEMO.M with the given input arguments.
%
%      FINDING_NEMO('Property','Value',...) creates a new FINDING_NEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before finding_nemo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to finding_nemo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help finding_nemo

% Last Modified by GUIDE v2.5 17-Dec-2017 14:20:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @finding_nemo_OpeningFcn, ...
                   'gui_OutputFcn',  @finding_nemo_OutputFcn, ...
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


% --- Executes just before finding_nemo is made visible.
function finding_nemo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to finding_nemo (see VARARGIN)

% Choose default command line output for finding_nemo
load mri
handles.D=squeeze(D);
handles.output = hObject;
initialConditions(hObject, handles);
handles = guidata(hObject);
my_adjust(hObject, handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes finding_nemo wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function initialConditions(hObject, handles)
set(handles.sliderGamma,'Value', 1, 'Min', 0.3, 'Max', 3);
set(handles.sliderContr, 'Value', 0);
set(handles.sliderBright, 'Value', 0);
set(handles.sliderM,'Value', 50, 'Min', 1, 'Max', 128);
set(handles.sliderN,'Value', 50, 'Min', 1, 'Max', 128);
set(handles.sliderP,'Value', 10, 'Min', 1, 'Max', 27);
set(handles.sliderX,'Value', 35, 'Min', -180, 'Max', 180);
set(handles.sliderZ,'Value', 30, 'Min', -90, 'Max', 90);
handles.Mslice = 50;
handles.Nslice = 50;
handles.Pslice = 10;
handles.Xangle = 35;
handles.Zangle = 30;
handles.sliderB = 0;
handles.sliderC = 0;
handles.sliderG = 1;
handles.laplacianON=false;
handles.maxD=88;
handles.level=2;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = finding_nemo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function DDDgraph(hObject, handles) %FUN��O PARA MOSTRAR AS SLICES 3D
%L� os dados correspondentes a 27 slides de imagens de MRI com uma resolu��o
%de 128*128. Esses dados ficam dispon�veis na matriz D.
%matriz convertida para o formato double
axes(handles.axes4);
cla
colormap('gray');

%nota: foi necess�rio converter a matriz D para double.
h=slice(double(handles.D)/255,handles.Nslice,handles.Mslice,handles.Pslice); 
%os sliders em baixo dos tres axes definem a slice
axis tight%angulo de visualiza��o do volume
view(handles.Xangle,handles.Zangle); 
 %sem representa��o do voxel e com interpola��o dos slides
set(h, 'EdgeColor','none', 'FaceColor','interp');
%grelhas no grafico desligadas
grid off;

%FUN��ES PARA MOSTRAR CADA UMA DAS SLICES EM CADA DIRE��O (MxNxP)
%ERRO: SO TA A MOSTRAR SLICES P
function Mgraph(hObject, handles) 
handles.D=squeeze(handles.D(handles.Mslice, :, :));
axes(handles.axes1);
h = imshow(imresize(imrotate(handles.D, 90, 'bicubic'), [300 300], 'cubic'), [0 handles.maxD]);
set(h,'ButtonDownFcn',{@axes1_ButtonDownFcn});
colormap('gray');


function Ngraph(hObject, handles)
handles.D=squeeze(handles.D(:, handles.Nslice, :));
axes(handles.axes2);
h = imshow(imresize(imrotate(handles.D, 90, 'bicubic'), [300 300], 'cubic'), [0 handles.maxD]);
set(h,'ButtonDownFcn',{@axes2_ButtonDownFcn});
colormap('gray');

function Pgraph(hObject, handles)
handles.D=squeeze(handles.D(:,:,handles.Pslice));
axes(handles.axes3);
h = imshow(imresize(handles.D, [300 300], 'nearest'), [0 handles.maxD]);
set(h,'ButtonDownFcn',{@axes3_ButtonDownFcn});
colormap('gray');
        

function my_adjust(hObject, handles)
sliderBright = handles.sliderB;
sliderContrast = handles.sliderC/2;
sliderGamma = handles.sliderG;

%AJUSTE BRILHO
if sliderBright>=0
   handles.D = imadjustn(handles.D,[0;1-sliderBright],[sliderBright;1]); %para aummentar brilho
else
   handles.D = imadjustn(handles.D,[-sliderBright;1],[0;1+sliderBright]);
end

%AJUSTE CONTRASTE
if sliderContrast>=0
   handles.D = imadjustn(handles.D,[sliderContrast;1-sliderContrast],[0;1]); %para aummentar contraste
else
   handles.D = imadjustn(handles.D,[0;1],[-sliderContrast;1+sliderContrast]);
end
%AJUSTE GAMMA
handles.D = imadjustn(handles.D,[],[],sliderGamma); 

DDDgraph(hObject, handles);
Mgraph(hObject, handles);
Ngraph(hObject, handles);
Pgraph(hObject, handles);
handles = guidata(hObject);
if handles.laplacianON == true
    handles=guidata(hObject);
    axes(handles.axes4);
    colormap('gray');
    axis tight
    contourslice(handles.D,handles.Mslice,handles.Nslice,handles.Pslice);
    view(handles.Xangle,handles.Zangle);
end
guidata(hObject, handles);

% --- Executes on slider movement.
function sliderX_Callback(hObject, eventdata, handles)
handles.Xangle = get(hObject, 'Value');
textX = strcat('Horizontal: ', num2str(round(handles.Xangle)),'�');
set(handles.textX, 'String', textX);
guidata(hObject, handles);
my_adjust(hObject, handles);



% --- Executes during object creation, after setting all properties.
function sliderX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function sliderZ_Callback(hObject, eventdata, handles)
handles.Zangle = get(hObject, 'Value');
textZ = strcat('Vertical: ', num2str(round(handles.Zangle)),'�');
set(handles.textZ, 'String', textZ);
guidata(hObject, handles);
my_adjust(hObject, handles);



% --- Executes during object creation, after setting all properties.
function sliderZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderM_Callback(hObject, eventdata, handles)
handles.Mslice = round(get(hObject, 'Value'));
textM = strcat('Longitudinal Slice: ', num2str(handles.Mslice));
set(handles.textM, 'String', textM);
guidata(hObject, handles);
my_adjust(hObject, handles);




% --- Executes during object creation, after setting all properties.
function sliderM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderN_Callback(hObject, eventdata, handles)
handles.Nslice = round(get(hObject, 'Value'));
textN = strcat('Sagital Slice: ', num2str(handles.Nslice));
set(handles.textN, 'String', textN);
guidata(hObject, handles);
my_adjust(hObject, handles);





% --- Executes during object creation, after setting all properties.
function sliderN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderP_Callback(hObject, eventdata, handles)
handles.Pslice = round(get(hObject, 'Value'));
textP = strcat('Transversal Slice: ', num2str(handles.Pslice));
set(handles.textP, 'String', textP);
guidata(hObject, handles);
my_adjust(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderBright_Callback(hObject, eventdata, handles)
handles.sliderB = get(hObject, 'Value');
textB = strcat('Brightness: ', num2str(round(handles.sliderB*100)));
set(handles.textBright, 'String', textB);

my_adjust(hObject, handles);

guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderBright_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderBright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderContr_Callback(hObject, eventdata, handles)
handles.sliderC = get(hObject, 'Value');
textC = strcat('Contrast: ', num2str(round(handles.sliderC*100)));
set(handles.textContr, 'String', textC);

my_adjust(hObject, handles);

guidata(hObject, handles);

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderContr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderContr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderGamma_Callback(hObject, eventdata, handles)
handles.sliderG = get(hObject, 'Value');
textG = strcat('Gamma: ', num2str(handles.sliderG, 3));
set(handles.textGamma, 'String', textG);

my_adjust(hObject, handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function sliderGamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderGamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in laplacianButton.
function laplacianButton_Callback(hObject, eventdata, handles)
handles.laplacianON=true;
guidata(hObject, handles);
my_adjust(hObject, handles);
 


% contourslice(X, Y, Z, V, Sx, Sy, Sz) draws contours in axis aligned x, y, z
%     planes at the points in the vectors Sx, Sy, Sz. The arrays X, Y, Z define
%     the coordinates for V and must be monotonic and 3-D plaid (as if
%     produced by MESHGRID).  The color at each contour will be determined
%     by the volume V.  V must be an M-by-N-by-P volume array.
%  
%     contourslice(X, Y, Z, V, XI, YI, ZI) draws contours through the volume V
%     along the surface defined by the arrays XI, YI, ZI.
%  
%     contourslice(V, Sx, Sy, Sz) or contourslice(V, XI, YI, ZI) assumes
%     [X, Y, Z] = meshgrid(1 : N, 1 : M, 1 : P) where [M, N, P] = SIZE(V).
%  
function create_NEMO(hObject, handles)
%clear all;
%por o nemo dentro do cerebro
nemo1 = [];
nemo2 = [];
nemo3 = [];
nemo4 = [];

nemo=imread('nemo','jpg');     
nemo1=255-imresize(nemo, [30 30], 'cubic');
nemo2=255-imresize(nemo, [25 25], 'cubic');
nemo3=255-imresize(nemo, [20 20], 'cubic');
nemo4=255-imresize(nemo, [10 10], 'cubic');
handles.nemo=zeros(30,30,7);
handles.nemo(11:20,11:20,1) = nemo4;
handles.nemo(6:25,6:25,2) = nemo3;
handles.nemo(3:27,3:27,3) = nemo2;
handles.nemo(:,:,4) = nemo1;
handles.nemo(3:27,3:27,5) = nemo2;
handles.nemo(6:25,6:25,6) = nemo3;
handles.nemo(11:20,11:20,7) = nemo4;
guidata(hObject,handles);
my_adjust(hObject, handles);

 

% --- Executes on button press in hideButton.
function hideNEMO(hObject, handles)
%AS VEZES DA ERRO, � PRECISO DEFINIR MELHOR A POSI��O
create_NEMO(hObject, handles);
handles=guidata(hObject);
positionX = round(22+(97-22).*rand(1,1));
positionY = round(26+(80-26).*rand(1,1));
positionZ = round(1+(20-1).*rand(1,1));
disp(positionX)
disp(positionY)
disp(positionZ)
% A + (B-A)*rand(1,1)
%PLANO M: [22, 120]
%PLANO N: [26, 100]
%PLANO Z: [0, 25]
switch handles.level
    case 1
        nemoCte = 0.3;
    case 2
        nemoCte = 0.25;
    case 3
        nemoCte = 0.15;
    case 4
        nemoCte = 0.1;
    case 5
        nemoCte = 0.075;
    case 6
        nemoCte = 0.05;
    case 7
        nemoCte = 0.015; 
end
handles.D(positionX:positionX+29,positionY:positionY+29,positionZ:positionZ+6)=double(handles.D(positionX:positionX+29,positionY:positionY+29,positionZ:positionZ+6)) + nemoCte*handles.nemo(:,:,:);
handles.maxD=max(max(max(handles.D)));
%queremos descobrir a que coordenada pertence a slice com indice positionX
%� criado o intervalo de fatias onde o nemo pertence
handles.intervalX = [positionY, positionY+29; 27-(positionZ+6), 27-positionZ];
handles.intervalY = [positionX, positionX+29; 27-(positionZ+6), 27-positionZ];
handles.intervalZ = [positionY, positionY+29; positionX, positionX+29];
guidata(hObject, handles);
disp(handles.intervalX)
disp(handles.intervalY)
disp(handles.intervalZ)
my_adjust(hObject, handles);
%Imagem com slice P:
%eixo xx:M (posX)
%eixo yy:N (posY)
%Imagem com slice N: (imrotate90�)
%eixo xx:M (posX)
%eixo yy:P (posZ)
%Imagem com slice M: (imrotate90�)
%eixo xx:N (posY)
%eixo yy:P (posZ)

%https://www.mathworks.com/help/matlab/creating_plots/button-down-callback-function.html#buhztrs-16
function clearNemo(hObject, handles)
load mri;
handles.D=squeeze(D);
handles.maxD=max(max(max(handles.D)));
guidata(hObject, handles);
my_adjust(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
msgbox('Instructions:');
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
disp('Coordinates');
axesHandles  = get(hObject,'Parent');
coordinate = get(axesHandles,'CurrentPoint');
%disp(coordinate);
handles.Xcoord1=round(coordinate(1,1)*128/300); %(slice N)
handles.Ycoord1=round(coordinate(1,2)*28/300); %(slice P)
disp(handles.Xcoord1);
disp(handles.Ycoord1);
guidata(hObject, handles);

% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
disp('Coordinates');
axesHandles  = get(hObject,'Parent');
coordinate = get(axesHandles,'CurrentPoint');
%disp(coordinate);
handles.Xcoord2=round(coordinate(1,1)*128/300); %(slice M)
handles.Ycoord2=round(coordinate(1,2)*28/300); %(slice P)
disp(handles.Xcoord2);
disp(handles.Ycoord2);
guidata(hObject, handles);


% --- Executes on mouse press over axes background.
function axes3_ButtonDownFcn(hObject, eventdata, handles)
disp('Coordinates');
axesHandles  = get(hObject,'Parent');
coordinate = get(axesHandles,'CurrentPoint');
%disp(coordinate);
%com uma regra de tr� simples podemos obter a slice sorrespondente �
%coordenada pedida
handles.Xcoord3=round(coordinate(1,1)*128/300); 
handles.Ycoord3=round(coordinate(1,2)*128/300);
disp(handles.Xcoord3);
disp(handles.Ycoord3);
guidata(hObject, handles);


% --- Executes on button press in playButton.
function playButton_Callback(hObject, eventdata, handles)
hideNEMO(hObject, handles);
handles=guidata(hObject);


% --- Executes on button press in filterOffButton.
function filterOffButton_Callback(hObject, eventdata, handles)
handles.laplacianON=false;
guidata(hObject, handles)
my_adjust(hObject, handles);


% --- Executes on button press in quitButton.
function quitButton_Callback(hObject, eventdata, handles)
clearNemo(hObject, handles);
handles=guidata(hObject);
handles.laplacianON=false;
% set(handles.sliderM, 'Value', 50);
% set(handles.sliderN, 'Value', 50);
% set(handles.sliderP, 'Value', 10);
% sliderM_Callback(hObject, eventdata, handles);
% sliderN_Callback(hObject, eventdata, handles);
% sliderP_Callback(hObject, eventdata, handles);
% set(handles.sliderX, 'Value', 35);
% set(handles.sliderZ, 'Value', 30);
% sliderX_Callback(hObject, eventdata, handles);
% sliderZ_Callback(hObject, eventdata, handles);
guidata(hObject, handles);


% --- Executes on selection change in selectLevel.
function selectLevel_Callback(hObject, eventdata, handles)
allLevels = get(handles.selectLevel,'string'); %string com todas as op��es do popupmenu
selectedIndex = get(handles.selectLevel,'Value'); %�ndice seleccionado
handles.level = str2num(allLevels{selectedIndex}); %gurdar o n�mero do n�vel, correspondente ao �ndice do pop up 
if isnan(handles.level) 
    %FALTA CODIGO
end
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns selectLevel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectLevel


% --- Executes during object creation, after setting all properties.
function selectLevel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
