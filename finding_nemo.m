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

% Last Modified by GUIDE v2.5 18-Dec-2017 01:21:31

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

%Assim que o programa abre, é carregada a imagem 3D e projectada no axes
%chamando a função my_ajust
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
function initialConditions(hObject, handles) %Definir todas as condições e variáveis iniciais
%handles = guidata(hObject);
set(handles.foundNemoBtn, 'Enable', 'off');
set(handles.filterOffButton, 'Enable', 'off');
set(handles.laplacianButton, 'Enable', 'off');
set(handles.playButton, 'Enable', 'on');
set(handles.selectLevel, 'Enable', 'on');
set(handles.sliderGamma,'Value', 1, 'Min', 0.3, 'Max', 3, 'Enable', 'off');
set(handles.sliderContr, 'Enable', 'off', 'Value', 0);
set(handles.sliderBright, 'Enable', 'off', 'Value', 0);
set(handles.textBright, 'String', 'Brightness: 0');
set(handles.textContr, 'String', 'Contrast: 0');
set(handles.textGamma, 'String', 'Gamma: 1');
handles.sliderB = 0;
handles.sliderC=0;
handles.sliderG=1;
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
handles.level=1;
handles.Xcoord1=0;
handles.Ycoord1=0;
handles.Xcoord2=0;
handles.Ycoord2=0;
handles.Xcoord3=0;
handles.Ycoord3=0;
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
cla
colormap('gray');
%nota: foi necessário converter a matriz D para double.
h=slice(double(handles.D)/255,handles.Nslice,handles.Mslice,handles.Pslice); 
%os sliders em baixo dos tres axes definem a slice
axis tight%angulo de visualização do volume
view(handles.Xangle,handles.Zangle); 
 %sem representação do voxel e com interpolação dos slides
set(h, 'EdgeColor','none', 'FaceColor','interp');
%grelhas no grafico desligadas
grid off;

%FUNÇÕES PARA MOSTRAR CADA UMA DAS SLICES EM CADA DIREÇÃO (MxNxP)
%ERRO: SO TA A MOSTRAR SLICES P
function Mgraph(hObject, handles) 
%projectar a fatia M no axes1
D=squeeze(handles.D(handles.Mslice, :, :)); %transformar na matriz 2D
axes(handles.axes1);
%mudamos o tamanho e rodamos 90º com interpolação bicubica. A internsidade
%é definida ente zero e o méximo da matriz
h = imshow(imresize(imrotate(D, 90, 'bicubic'), [300 300], 'cubic'), [0 handles.maxD]);
%honestamente nao compreendemos parte do seguinte código mas foi a única solução
%econtrada na internet para passar o handles depois do buttondown ser
%chamado
set(h,'ButtonDownFcn',{@axes1_ButtonDownFcn,handles});
child_handles = allchild(h);
set(child_handles,'HitTest','off');
colormap('gray');
guidata(hObject, handles);


function Ngraph(hObject, handles)
%projectar a fatia N no axes2 (análogo ao anterior)
D=squeeze(handles.D(:, handles.Nslice, :));
axes(handles.axes2);
h = imshow(imresize(imrotate(D, 90, 'bicubic'), [300 300], 'cubic'), [0 handles.maxD]);
set(h,'ButtonDownFcn',{@axes2_ButtonDownFcn,handles});
child_handles = allchild(h);
set(child_handles,'HitTest','off');
colormap('gray');
guidata(hObject, handles);

function Pgraph(hObject, handles)
%projectar a fatia P no axes3 (análogo ao anterior)
D=squeeze(handles.D(:,:,handles.Pslice));
axes(handles.axes3);
h = imshow(imresize(D, [300 300], 'nearest'), [0 handles.maxD]);
set(h,'ButtonDownFcn',{@axes3_ButtonDownFcn,handles});
child_handles = allchild(h);
set(child_handles,'HitTest','off');
colormap('gray');
guidata(hObject, handles);

% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
%Quando carregamos no axes1 guardamos as coordenadas do clique
handles = guidata(hObject);
disp('Coordinates');
axesHandles  = get(hObject,'Parent');
coordinate = get(axesHandles,'CurrentPoint');
%convertemos as coordenadas de [300 300] para a slice correspondente e
%guardamos no handles
handles.Xcoord1=round(coordinate(1,1)*128/300); %(slice N)
handles.Ycoord1=round(coordinate(1,2)*27/300); %(slice P)
guidata(hObject, handles);

% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
%Quando carregamos no axes2 guardamos as coordenadas do clique
handles = guidata(hObject);
disp('Coordinates');
axesHandles  = get(hObject,'Parent');
coordinate = get(axesHandles,'CurrentPoint');
handles.Xcoord2=round(coordinate(1,1)*128/300); %(slice M)
handles.Ycoord2=round(coordinate(1,2)*27/300); %(slice P)

guidata(hObject, handles);



% --- Executes on mouse press over axes background.
function axes3_ButtonDownFcn(hObject, eventdata, handles)
%Quando carregamos no axes1 guardamos as coordenadas do clique
handles = guidata(hObject);
disp('Coordinates');
axesHandles  = get(hObject,'Parent');
coordinate = get(axesHandles,'CurrentPoint');
%com uma regra de trê simples podemos obter a slice sorrespondente à
%coordenada pedida
handles.Xcoord3=round(coordinate(1,1)*128/300); 
handles.Ycoord3=round(coordinate(1,2)*128/300);

guidata(hObject, handles);


        

function my_adjust(hObject, handles)
%função que serve para ajustar brilho contraste e gama
%para além disso, faz imshow dos gráficos por isso é chamada sempre que há
%este propósito
handles = guidata(hObject);

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
%handles = guidata(hObject);
if handles.laplacianON == true %caso o filtro laplaciano esteja activado, utilizamos a função 
    %contourslice para realce de contornos no gráfico 3D
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
%receber o valor do slider que dá o ângulo em XY e guardar numa variavel
%handles. Também é mudado o texto da textbox correspondente
handles.Xangle = get(hObject, 'Value');
textX = strcat('Horizontal: ', num2str(round(handles.Xangle)),'º');
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
%receber o valor do slider que dá o ângulo em Z e guardar numa variavel
%handles. Também é mudado o texto da textbox correspondente
handles.Zangle = get(hObject, 'Value');
textZ = strcat('Vertical: ', num2str(round(handles.Zangle)),'º');
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
%receber o valor do slider que dá a slice M e guardar numa variavel
%handles. Também é mudado o texto da textbox correspondente
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
%receber o valor do slider que dá a slice N e guardar numa variavel
%handles. Também é mudado o texto da textbox correspondente
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
%receber o valor do slider que dá a slice P e guardar numa variavel
%handles. Também é mudado o texto da textbox correspondente
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
%receber o valor do slider que dá o valor do brilho e guardar numa variavel
%handles. Também é mudado o texto da textbox correspondente
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
%receber o valor do slider que dá o valor do contraste e guardar numa variavel
%handles. Também é mudado o texto da textbox correspondente
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
%receber o valor do slider que dá o valor do gama e guardar numa variavel
%handles. Também é mudado o texto da textbox correspondente
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
%quando o botão do filtro laplaciano é activado, mudamos a variável
%laplacianON para true e chamamos o my_adjust para aplicar a mudança
handles.laplacianON=true;
set(handles.filterOffButton, 'Enable', 'on');
guidata(hObject, handles);
my_adjust(hObject, handles);
   
function create_NEMO(hObject, handles)
%criar a matriz 3D do peixe graças a uma fotografia 2D que foi empilhada
%sete vezes com diversos tamanhos
nemo=imread('nemo','jpg');     
nemo1=255-imresize(nemo, [30 30], 'cubic');
nemo2=255-imresize(nemo, [25 25], 'cubic');
nemo3=255-imresize(nemo, [20 20], 'cubic');
nemo4=255-imresize(nemo, [10 10], 'cubic');
%o nemo terá tamanho (30,30,7)
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
%após criado o nemo, esta função permite somá-lo a uma região aleatória do
%cérebro 
create_NEMO(hObject, handles);
handles=guidata(hObject);
% é definida aleatoriamente a posição inicial da matriz
%os intervalos foram definidos experimentalmente para só calharem na zona
%do cérebro e não no fundo preto
positionX = round(22+(97-22).*rand(1,1));
positionY = round(26+(80-26).*rand(1,1));
positionZ = round(1+(20-1).*rand(1,1));
disp(positionX)
disp(positionY)
disp(positionZ)
%conforme o nível a intensidade da contstante multiplicada pelo nemo varia
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
%é éntão somado o nemo à matriz do cerebro 3D
handles.D(positionX:positionX+29,positionY:positionY+29,positionZ:positionZ+6)=double(handles.D(positionX:positionX+29,positionY:positionY+29,positionZ:positionZ+6)) + nemoCte*handles.nemo(:,:,:);
%queremos saber o máximo da matriz para ajustar a escala de cores
handles.maxD=max(max(max(handles.D)));
%queremos descobrir a que coordenada pertence a slice com indice positionX
%é criado o intervalo de fatias onde o nemo pertence
%serão depois usados em foundNemo para saber se o nemo foi encontrado
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
%Imagem com slice N: (imrotate90º)
%eixo xx:M (posX)
%eixo yy:P (posZ)
%Imagem com slice M: (imrotate90º)
%eixo xx:N (posY)
%eixo yy:P (posZ)

function clearNemo(hObject, handles)
%função para voltar à matriz do cérebro sem o nemo com as condições
%iniciais
load mri;
handles.D=squeeze(D);
handles.maxD=max(max(max(handles.D)));
initialConditions(hObject, handles);
handles=guidata(hObject);
guidata(hObject, handles);
my_adjust(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
%instruções
msgbox('Instructions: Choose the dificulty and then press "Play".Press the 2D axes to select the spot where you see NEMO. When you have chosen in all the 2D graphs, press the button "I FOUND NEMO!" Good luck FINDING NEMO!');



% --- Executes on mouse press over axes background.
function axes4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in playButton.
function playButton_Callback(hObject, eventdata, handles)
%botão para começar o jogo, permite esconder o nemo chamando a função hideNEMO
%e alterar o estado dos botões
hideNEMO(hObject, handles);
handles=guidata(hObject);
set(handles.foundNemoBtn, 'Enable', 'on');
set(handles.quitButton, 'Enable', 'on');
set(handles.laplacianButton, 'Enable', 'on');
set(handles.sliderBright, 'Enable', 'on');
set(handles.sliderContr, 'Enable', 'on');
set(handles.sliderGamma, 'Enable', 'on');
set(handles.playButton, 'Enable', 'off');
set(handles.selectLevel, 'Enable', 'off');




% --- Executes on button press in filterOffButton.
function filterOffButton_Callback(hObject, eventdata, handles)
%para retirar o filtro laplaciano alteramos o estado da variavel laplacianON
%para false e chamamos o my_adjust
handles.laplacianON=false;
set(handles.laplacianButton, 'Enable', 'on');
guidata(hObject, handles)
my_adjust(hObject, handles);


% --- Executes on button press in quitButton.
function quitButton_Callback(hObject, eventdata, handles)
%botão para desistir do jogo, limpa o nemo com a função clearNemo e volta
%Às condiçõe iniciais
clearNemo(hObject, handles);
handles=guidata(hObject);
guidata(hObject, handles);
my_adjust(hObject,handles);

% --- Executes on selection change in selectLevel.
function selectLevel_Callback(hObject, eventdata, handles)
%popup menu que permite receber o valor do nivel selecccionado e guardar no
%handles
allLevels = get(handles.selectLevel,'string'); %string com todas as opções do popupmenu
selectedIndex = get(handles.selectLevel,'Value'); %índice seleccionado
handles.level = str2num(allLevels{selectedIndex}); %gurdar o número do nível, correspondente ao índice do pop up 
if isnan(handles.level) 
    handles.level=1; %valor default
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function selectLevel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function foundNemoBtn_Callback(hObject, eventdata, handles)
%função para verificar se o nemo foi encontrado correctamente
handles = guidata(hObject);
Mplane = false;
Nplane = false;
Pplane = false;
%primeiro um if para saber se todos os axes foram pressionados
%depois vários ifs para saber se as condições dos intervalos foram
%satisfeitas
if (handles.Xcoord1==0 || handles.Xcoord2==0 || handles.Xcoord3==0)
    msgbox('You didnt press all the graphs! Try again :)');
else
    if handles.Xcoord1>handles.intervalX(1,1) && handles.Xcoord1<handles.intervalX(1,2) && handles.Ycoord1>handles.intervalX(2,1) && handles.Ycoord1<handles.intervalX(2,2)
        Mplane = true;
    end
    if handles.Xcoord2>handles.intervalY(1,1) && handles.Xcoord2<handles.intervalY(1,2) && handles.Ycoord2>handles.intervalY(2,1) && handles.Ycoord2<handles.intervalY(2,2)
        Nplane = true;
    end    
    if handles.Xcoord3>handles.intervalZ(1,1) && handles.Xcoord3<handles.intervalZ(1,2) && handles.Ycoord3>handles.intervalZ(2,1) && handles.Ycoord3<handles.intervalZ(2,2)
        Pplane = true;
    end    
    if Mplane == true && Nplane == true && Pplane == true
        %caso todas as coordenadas estejam desntro dos limites dos
        %intervalos calculados em hideNemo o jogo foi ganho
        handles.nemoFound = true;
        uiwait(msgbox('Well done!!! Now try a harder level ;)'));
        clearNemo(hObject,handles);
        handles = guidata(hObject);
    else
        handles.nemoFound = false;
        uiwait(msgbox('Looks like Nemo is going to die in the Medusa (aka Neuron) Field! Try Again :)'));
        clearNemo(hObject,handles);
        handles = guidata(hObject);
    end
disp(handles.nemoFound)
end
guidata(hObject, handles);
