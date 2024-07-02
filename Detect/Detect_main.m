% Cargar la base de datos de imágenes
imageDir = './';

% Colocamos las imagenes en una estructura 
fileList = dir([imageDir '*.pgm']);

% Cargar los puntos de control
load data_points.mat
[imgcount,dimensioncount,ptscount]=size(data);
% Puntos de control de la imagen de referencia (primera imagen)
fixedPoints = data(1,:,:);
fixedPoints=reshape(fixedPoints,[dimensioncount,ptscount]);
fixedPoints=fixedPoints';

% Inicializar variables
nImages = length(fileList);
nPoints = size(fixedPoints, 1);
errors = zeros(nImages, 1);
hold on

%---------------Mapa de distribución antes del registro-------------%

% Creamos un loop para obtener todos los puntos de control
for i = 1:nImages
    % 
    Pts = squeeze(data(i,:,:));
    x = Pts(1,:);
    y = Pts(2,:);
    % Mostramos el mapa de distribución sin registro.
    mapa_distribucion_antes = scatter(x,y,3);
end
figure();
%-------------Registrar las imágenes----------------------------
for i = 1:nImages
    % Cargar la imagen
    imageFile = [fileList(i).name];
    image = imread(imageFile);
    
    % Puntos de control de la imagen actual
    movingPoints = data(i,:,:);
    movingPoints=reshape(movingPoints,[dimensioncount,ptscount]);
    movingPoints=movingPoints';

    % Calcular la transformación para registrar la imagen actual con la de referencia
    tform = fitgeotrans(movingPoints, fixedPoints, 'affine');
    %tform=affinetform2d(tform.T);

    % Aplicar la transformación a la imagen actual
    registeredImage = imwarp(image, tform, 'OutputView', imref2d(size(image)));
    
    % Calcular el error de ajuste
    registeredPoints = transformPointsForward(tform, movingPoints);
    % Distancia euclidiana
    errors(i) = sum(sqrt(sum((fixedPoints - registeredPoints).^2, 2)));
end
%--------------Seleccionamos las 99 mejores-----------------------------
% Seleccionar las 99 imágenes con menor error de ajuste
[sortedErrors, sortedIndices] = sort(errors);
selectedIndices = sortedIndices(1:99);
index_best=selectedIndices(1);
movingPoints = data(index_best,:,:);
movingPoints = reshape(movingPoints, [dimCount,ptsCount]);
movingPoints = movingPoints';
%scatter(movingPoints(:,1), movingPoints(:,2), 'o', 'filled', 'blue');

%----------Mapa de distribución después del registro--------------%

hold on
for i = 1:99
    % Puntos de control de la imagen actual
    movingPoints =data(selectedIndices(i),:,:);
    movingPoints=reshape(movingPoints,[dimensioncount,ptscount]);
    movingPoints=movingPoints';
    x = movingPoints(:,1);
    y = movingPoints(:,2);
    s = scatter(movingPoints(:,1), movingPoints(:,2),5);
end
figure();

