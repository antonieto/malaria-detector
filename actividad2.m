%Equipo 3
% Gael Rodríguez Gómez A01639279
% Carlo Angel Lujan Garcia A01639847
% José Antonio Chaires Monroy A01640114

function varargout = actividad2(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @actividad2_OpeningFcn, ...
                   'gui_OutputFcn',  @actividad2_OutputFcn, ...
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


% --- Executes just before actividad2 is made visible.
function actividad2_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
global p;
p.MyData = [];

grafica(1,1,.25,1);
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = actividad2_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% --- Executes on slider movement.
function ElectrodoN_Callback(hObject, eventdata, handles)
valorSliderP = get(handles.ElectrodoP, 'Value');  
valorSliderN = get(hObject, 'Value');
valorDistancia = get(handles.distancia,'Value');
valorN = get(handles.n,'Value');

set(handles.placaN, 'String', num2str(valorSliderN))

grafica(valorSliderN,valorSliderP,valorDistancia,valorN);
clear(handles);

% --- Executes during object creation, after setting all properties.
function ElectrodoN_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function ElectrodoP_Callback(hObject, eventdata, handles)

valorSliderP = get(hObject, 'Value');  
valorSliderN = get(handles.ElectrodoN, 'Value');
valorDistancia = get(handles.distancia,'Value');
valorN = get(handles.n,'Value');

set(handles.placaP, 'String', num2str(valorSliderP))

grafica(valorSliderN,valorSliderP,valorDistancia,valorN);
clear(handles);

% --- Executes during object creation, after setting all properties.
function ElectrodoP_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function distancia_Callback(hObject, eventdata, handles)
valorSliderP = get(handles.ElectrodoP, 'Value');  
valorSliderN = get(handles.ElectrodoN, 'Value');
valorDistancia = get(hObject,'Value');
valorN = get(handles.n,'Value');

set(handles.placaD, 'String', num2str(valorDistancia))

grafica(valorSliderN,valorSliderP,valorDistancia,valorN);
clear(handles);


% --- Executes during object creation, after setting all properties.
function distancia_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function crearGlobulo_CreateFcn(hObject, eventdata, handles)
global contador
contador=0; 
global infectadas 
infectadas = 0;

% --- Executes on button press in crearGlobulo.
function crearGlobulo_Callback(hObject, ~, handles)

global contador 
global infectadas
contador = contador+1;

if contador == 20
    set(hObject,'Enable','off')
end

valorSliderP = get(handles.ElectrodoP, 'Value');  
valorSliderN = get(handles.ElectrodoN, 'Value');
valorDistancia = get(handles.distancia,'Value');


if valorSliderP<valorSliderN
    valorY=valorSliderP;
else
    valorY=valorSliderN;
end


PosX = (rand()*2-1)*valorDistancia*0.325;
PosY = (rand()*2-1)*valorY*0.5;
PosZ = 0;
RadioEsfera = 0.05;
[xe,ye,ze] = sphere(10);
xe = xe*RadioEsfera;
ye = ye*RadioEsfera;
ze = ze*RadioEsfera; 
diametro = rand()*RadioEsfera;

%Carga de los glóbulos y número de cargas de las placas
Q = 5e-9;
n = get(handles.n,'Value');

[E2, E1]  = diagnostico(PosX,PosY,diametro,n,5e-9,valorDistancia,valorSliderP,valorSliderN); 
F1 = E1.*-Q; 
F2 = E2.*Q;
Ftotal = F1+F2;

global p;
%Graficar quiver
vecFuerza = quiver3(PosX,PosY,0,Ftotal(1),Ftotal(2),Ftotal(3),1*1e7);
set(vecFuerza, 'Color', 'k') 
set(vecFuerza, 'LineWidth', 2)
infectado = false;
if diagnosticar(E2,E1)
    color = 'y';
    infectadas = infectadas + 1;
    infectado = true;
else 
    color = 'r';
end
surf(xe+PosX, ye+PosY, ze+PosZ,'FaceColor',color, 'EdgeColor', color, 'FaceAlpha',0.2, 'EdgeAlpha', 0.2);

crearCargas(PosX,PosY,diametro);  

%String del campo neto  

campo1 = num2str(E1(1))+"i + "+ num2str(E1(2))+"j + "+ "0k"; 
campo2 = num2str(E2(1))+"i + "+ num2str(E2(2))+"j + "+ "0k";
fuerzaNeta = num2str(Ftotal(1))+"i + "+ num2str(Ftotal(2))+"j + "+ "0k"; 

p.MyData = [p.MyData; [{PosX} {PosY} {Ftotal(1)} {Ftotal(2)} {'0'} {infectado}]];
set(handles.tablaGlobulos, 'Data' , p.MyData)
set(handles.fuerzaText,'String',fuerzaNeta); 
set(handles.campo1, 'String', campo1);
set(handles.campo2, 'String', campo2); 
set(handles.distanciaTxt, 'String', diametro*2); 
set(handles.infectadasTxt, 'String', infectadas); 

function result = diagnosticar(E2, E1) 
mag2 = sqrt(sum(E2.^2)); 
mag1 = sqrt(sum(E1.^2)); 
if mag2 > mag1 
    diferencia = (mag2-mag1)/mag2;
else 
    diferencia = (mag1-mag2)/mag1;  
end 
if diferencia > 0.1 
    result = true;
else 
    result = false;
end 
disp(mag1);

% --- Executes on slider movement.
function n_Callback(hObject, eventdata, handles)
val = round(hObject.Value);
hObject.Value=val;
valorSliderP = get(handles.ElectrodoP, 'Value');  
valorSliderN = get(handles.ElectrodoN, 'Value');
valorDistancia = get(handles.distancia,'Value');
valorN = get(hObject,'Value');
grafica(valorSliderN,valorSliderP,valorDistancia,valorN);

set(handles.cargas, 'String', num2str(valorN))

clear(handles);
get(hObject,'Value')

% --- Executes during object creation, after setting all properties.
function n_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in restart.
function restart_Callback(hObject, eventdata, handles)
global contador
contador=0;
valorSliderP = get(handles.ElectrodoP, 'Value');  
valorSliderN = get(handles.ElectrodoN, 'Value');
valorDistancia = get(handles.distancia,'Value');
valorN = get(handles.n,'Value');
grafica(valorSliderN,valorSliderP,valorDistancia,valorN);
clear(handles);


function grafica(valorSliderN,valorSliderP,valorDistancia,n)
cla;
dm = 0.2; %Incremento entre puntos 

%Crear malla 
x = -5:dm:5;
y = -5:dm:5;
z = 0;
[X,Y,Z] = meshgrid(x,y,z); 

%Cargas y constantes de coulomb 
k = 8.987e9;
Q = 5e-6;

amp = 0.5;
positiveX = [ones(1,n).*valorDistancia];
positiveY = [linspace(-amp*valorSliderP,amp*valorSliderP,n)]; 

negativeX = [ones(1,n).*-valorDistancia]; 
negativeY = [linspace(-amp*valorSliderN,amp*valorSliderN,n)];

positiveZ = zeros(1,length(positiveX)); 
negativeZ = zeros(1,length(positiveX));

% positivePoints = [positiveX ; positiveY]'; 
% negativePoints = [negativeX ; negativeY]';

%Calcular campos de la placa positiva 
Ex = zeros(length(X)); 
Ey = zeros(length(Y));
Ez = zeros(length(Z));

%Campos X
for i = 1:n 
    Xpi = positiveX(i); 
    Xni = negativeX(i);  
    Ypi = positiveY(i);  
    Yni = negativeY(i);
    Expi = k*(Q/n).*(X-Xpi)./((X-Xpi).^2+(Y-Ypi).^2).^1.5;  
    Exni =  k*(Q/n).*(X-Xni)./((X-Xni).^2+(Y-Yni).^2).^1.5; 
    Ex = Ex+Expi-Exni;
end
%Campos placa negativa 
for i = 1:n     
    Xpi = positiveX(i); 
    Xni = negativeX(i);  
    Ypi = positiveY(i);  
    Yni = negativeY(i);
    Eypi = k*(Q/n).*(Y-Ypi)./((X-Xpi).^2+(Y-Ypi).^2).^1.5;  
    Eyni =  k*(Q/n).*(Y-Yni)./((X-Xni).^2+(Y-Yni).^2).^1.5; 
    Ey = Ey+Eypi-Eyni;
end
EE = sqrt(Ex.^2+Ey.^2+Ez.^2); 
i=Ex./EE;
j=Ey./EE;
k=Ez./EE;

%Propiedades de las placas
v=0.5;
ancho = 0.2; 
alto = 0.25;
largoN = valorSliderN;
largoP = valorSliderP;
moverx = valorDistancia;

verticesP=[[v*ancho+moverx -v*largoP -v*alto]; %v1
          [-v*ancho+moverx -v*largoP -v*alto]; %v2
          [-v*ancho+moverx v*largoP -v*alto];%v3
          [v*ancho+moverx v*largoP -v*alto];%v4
          [v*ancho+moverx -v*largoP v*alto];%v5
          [-v*ancho+moverx -v*largoP v*alto];%v6
          [-v*ancho+moverx v*largoP v*alto];%v7
          [v*ancho+moverx v*largoP v*alto]];%v8
      
verticesN=[[v*ancho-moverx -v*largoN -v*alto]; %v1
          [-v*ancho-moverx -v*largoN -v*alto]; %v2
          [-v*ancho-moverx v*largoN -v*alto];%v3
          [v*ancho-moverx v*largoN -v*alto];%v4
          [v*ancho-moverx -v*largoN v*alto];%v5
          [-v*ancho-moverx -v*largoN v*alto];%v6
          [-v*ancho-moverx v*largoN v*alto];%v7
          [v*ancho-moverx v*largoN v*alto]];%v8

caras = [1 2 6 5; %cara xz frontal
         2 3 7 6; %cara zy frontal
         3 4 8 7; %cara 3
         1 4 8 5; %cara 4
         5 6 7 8; %cara arriba
         1 2 3 4];%cara abajo 
     

%Campo eléctrico 

hold on; 
quiver3(X,Y,Z,i,j,k,0.5,"b");
LaminaP = patch('Faces', caras, 'Vertices', verticesP, 'FaceColor', 'r');
LaminaN = patch('Faces', caras, 'Vertices', verticesN, 'FaceColor', 'b');
grid on; 
xlabel('X'); 
ylabel('Y'); 
zlabel('Z');
% axis equal;
title("Campo Eléctrico de 2 cargas")
box on;

rotate3d on;


function clear(handles)
global contador
global infectadas
contador=0; 
infectadas = 0;
global p;
p.MyData = [];
set(handles.tablaGlobulos, 'Data', {});
set(handles.crearGlobulo,'Enable','on')

function [E1, E2]  = diagnostico(x,y,distanciaCargas,n,Q,valorDistancia,valorSliderP,valorSliderN)
k = 8.987e9; 
Q = Q/n; 

%Coordenadas de cargas prueba
x1 = x-distanciaCargas; 
x2 = x+distanciaCargas; 
%Coordenadas de las cargas fuente
amp = 0.5;
positiveX = ones(1,n).*valorDistancia;
positiveY = linspace(-amp*valorSliderP,amp*valorSliderP,n); 

negativeX = ones(1,n).*-valorDistancia;
negativeY = linspace(-amp*valorSliderN,amp*valorSliderN,n);

% Inicializar componentes campo
Ex1 = 0; 
Ey1  = 0; 
Ex2 = 0; 
Ey2  = 0; 

% %Calcular campo carga 1 
for i=1:n 
    %Calcular campo por la placa derecha 
    xPosi = positiveX(i); 
    yPosi = positiveY(i); 
    xNeg = negativeX(i); 
    yNeg = negativeY(i);
    %Contribución de campo en X
    Exp = k*(Q/((x1-xPosi)^2+(y-yPosi)^2)^1.5)*(x1-xPosi);  
    Exn = k*(Q/((x1-xNeg)^2+(y-yNeg)^2)^1.5)*(x1-xNeg); 
    Ex1 = Ex1 + Exp - Exn; 
    %Contribución de campo en Y 
    Eyp = k*(Q/((x1-xPosi)^2+(y-yPosi)^2)^1.5)*(y-yPosi);  
    Eyn = k*(Q/((x1-xNeg)^2+(y-yNeg)^2)^1.5)*(y-yNeg);
    Ey1 = Ey1 + Eyp - Eyn;    
end
%Calcular campo en carga 2
for i=1:n 
    %Calcular campo por la placa derecha 
    xPosi = positiveX(i); 
    yPosi = positiveY(i); 
    xNeg = negativeX(i); 
    yNeg = negativeY(i);
    %Contribución de campo en X
    Exp = k*(Q/((x2-xPosi)^2+(y-yPosi)^2)^1.5)*(x2-xPosi);  
    Exn = k*(Q/((x2-xNeg)^2+(y-yNeg)^2)^1.5)*(x2-xNeg); 
    Ex2 = Ex2 + Exp - Exn; 
    %Contribución de campo en Y 
    Eyp = k*(Q/((x2-xPosi)^2+(y-yPosi)^2)^1.5)*(y-yPosi);  
    Eyn = k*(Q/((x2-xNeg)^2+(y-yNeg)^2)^1.5)*(y-yNeg);
    Ey2 = Ey2 + Eyp - Eyn;       
end 

Ey1 = round(Ey1,2);
Ey2 = round(Ey2,2);
Ex1 = round(Ex1,2); 
Ex2 = round(Ex2, 2);


E1 = [Ex1 Ey1 0]; 
E2 = [Ex2 Ey2 0]; 

function crearCargas(x,y,d)
x1 = x + d; 
x2 = x - d; 
RadioEsfera = 0.025;
[xe,ye,ze] = sphere(10);
xe = xe*RadioEsfera;
ye = ye*RadioEsfera;
ze = ze*RadioEsfera; 
color = 'k';
surf(xe+x1, ye+y, ze+0,'FaceColor',color, 'EdgeColor', color);
surf(xe+x2, ye+y, ze+0,'FaceColor',color, 'EdgeColor', color); 

function edit1_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
