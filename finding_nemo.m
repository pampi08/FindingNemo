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

% Last Modified by GUIDE v2.5 06-Dec-2017 18:37:50

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
DDDgraph(hObject, handles); 
Mgraph(hObject, handles);
Ngraph(hObject, handles);
Pgraph(hObject, handles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes finding_nemo wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function initialConditions(hObject, handles)
set(handles.sliderGamma,'Value', 1, 'Min', 0.3, 'Max', 3);
set(handles.sliderContr, 'Value', 0);
set(handles.sliderBright, 'Value', 0);
set(handles.sliderM,'Value', 50, 'Min', 0, 'Max', 128);
set(handles.sliderN,'Value', 50, 'Min', 0, 'Max', 128);
set(handles.sliderP,'Value', 10, 'Min', 0, 'Max', 27);
set(handles.sliderX,'Value', 35, 'Min', -180, 'Max', 180);
set(handles.sliderZ,'Value', 30, 'Min', -90, 'Max', 90);
handles.Mslice = 50;
handles.Nslice = 50;
handles.Pslice = 10;
handles.Xangle = 35;
handles.Zangle = 30;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = finding_nemo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function DDDgraph(hObject, handles) %FUNÇÃO PARA MOSTRAR AS SLICES 3D
%Lê os dados correspondentes a 27 slides de imagens de MRI com uma resolução
%de 128*128. Esses dados ficam disponíveis na matriz D.
%matriz convertida para o formato double
axes(handles.axes4);
colormap('gray');
%representação do slide em x=50, y=50 e z=10;
%nota: foi necessário converter a matriz D para double.
h=slice(double(handles.D)/255, handles.Mslice,handles.Nslice,handles.Pslice); 
%os sliders em baixo dos tres axes definem a slice, é suposto ela ser
%mostrada no gráfico 2D correspondente e no 3D
%angulo de visualização do volume
view(handles.Xangle,handles.Zangle); 
 %sem representação do voxel e com interpolação dos slides
set(h, 'EdgeColor','none', 'FaceColor','interp');
%grelhas no grafico desligadas
grid off;

%FUNÇÕES PARA MOSTRAR CADA UMA DAS SLICES EM CADA DIREÇÃO (MxNxP)
%ERRO: SO TA A MOSTRAR SLICES P
function Mgraph(hObject, handles) 
handles.D=squeeze(handles.D(handles.Mslice, :, :));

axes(handles.axes1);
imshow(imresize(handles.D, [300 300], 'nearest'), []);
colormap('gray');

function Ngraph(hObject, handles)
handles.D=squeeze(handles.D(:, handles.Nslice, :));

axes(handles.axes2);
imshow(imresize(handles.D, [300 300], 'nearest'), []);
colormap('gray');

function Pgraph(hObject, handles)
handles.D=squeeze(handles.D(:,:,handles.Pslice));

axes(handles.axes3);
imshow(imresize(handles.D, [300 300], 'nearest'), []);
colormap('gray');
        

function my_adjust(hObject, handles)
sliderBright = get(handles.sliderBright, 'Value');
sliderContrast = get(handles.sliderContr, 'Value')/2;
sliderGamma = get(handles.sliderGamma, 'Value');

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

guidata(hObject, handles);

% --- Executes on slider movement.
function sliderX_Callback(hObject, eventdata, handles)
handles.Xangle = get(hObject, 'Value');
textX = strcat('Horizontal: ', num2str(round(handles.Xangle)),'º');
set(handles.textX, 'String', textX);

my_adjust(hObject, handles);

guidata(hObject, handles);

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
textZ = strcat('Vertical: ', num2str(round(handles.Zangle)),'º');
set(handles.textZ, 'String', textZ);

my_adjust(hObject, handles);

guidata(hObject, handles);

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

my_adjust(hObject, handles);

guidata(hObject, handles);


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

my_adjust(hObject, handles);

guidata(hObject, handles);



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

my_adjust(hObject, handles);

guidata(hObject, handles);


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
my_adjust(hObject, handles);

guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


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
