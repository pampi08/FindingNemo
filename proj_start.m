%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Visualização de volumes tomográficos 
%Pedro Vieira 11/2017
%Ref: https://www.mathworks.com/help/matlab/visualize/
%           techniques-for-visualizing-scalar-volume-data.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
clear all; %limpa todas as variáveis
close all; %fecha todas as janelas de visualização
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Lê os dados correspondentes a 27 slides de imagens de MRI com uma resolução
%de 128*128. Esses dados ficam disponíveis na matriz D.
load mri
D=squeeze(D);
%matriz convertida para o formato double
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Na figure(1) é apresentado o slide 
figure(1);
imshow(D(:,:,10), []);
colormap('gray');
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Na figure(2) é representado todo o volume da imagem, usando-se para isso a
%função slice.
figure(2);
colormap('gray');
%representação do slide em x=50, y=50 e z=10;
%nota: foi necessário converter a matriz D para double.
h=slice(double(D)/255, 50,50,10); 
%angulo de visualização do volume
view(35,30); 
 %sem representação do voxel e com interpolação dos slides
set(h, 'EdgeColor','none', 'FaceColor','interp');
%grelhas no grafico desligadas
grid off;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%na figure(3) são apresentados mapas de contorno (filtro laplaciano) para os
%slides: 1,12,19,27
figure(3);
colormap('gray');
axis tight
contourslice(D,[],[],[1,12,19,27],8);
view(35,30); 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%na figure(4) é apresentado uma imagem de superfície do volume 
figure(4)
colormap(map)
%aplica um filtro passa baixo a todo o volume
Ds = smooth3(D);
%cria a superficie externa do volume
hiso = patch(isosurface(Ds,5),...
   'FaceColor',[1,.75,.65],...
   'EdgeColor','none');
   isonormals(Ds,hiso)
%define a imagem superior e inferior do volume
hcap = patch(isocaps(D,5),...
   'FaceColor','interp',...
   'EdgeColor','none');
%define o ângulo de visualização do volume
view(35,30) 
axis tight 
%define o fator de escala de cada um dos eixos para uma visualização mais
%realista
daspect([1,1,.4]);
%define as condições de iluminação de forma a se ter uma perspetiva 3D do
%volume
lightangle(45,30);
lighting gouraud
hcap.AmbientStrength = 0.6;
hiso.SpecularColorReflectance = 0;
hiso.SpecularExponent = 50;







