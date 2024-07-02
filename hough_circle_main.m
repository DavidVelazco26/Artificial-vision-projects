clear all;
clc;
%% ------------------------------Procesamiento de imagen---------------------------------
% Load  image
img=imread('coins.png');
% Detectamos los bordes de la imagen.
BW = edge(img, 'Canny');
% Buscamos los centros y los radios de la imagen.
[centros, radios] = encontrar_circulos(BW, [24,28]);
% Dibujamos los circulos.
hough_circles_draw(img, centros, radios)
%% ----------------------------------Funciones-------------------------------------------
function [centros, radios] = encontrar_circulos(BW, rango_radio)
     % Parámetros de configuración
    radio_min = rango_radio(1); % Radio mínimo en el rango
    radio_max = rango_radio(2); % Radio máximo en el rango
    num_radios = 2; % Número de radios utilizados para la detección
    num_picos = 6; % Número de picos máximos a encontrar
    centros = zeros(num_radios * num_picos, 2); % Matriz para almacenar los centros de los círculos encontrados
    radios = zeros(size(centros, 1), 1); % Vector para almacenar los radios correspondientes a los círculos encontrados
    num_filas = 0; % Contador de filas

    % Bucle para buscar círculos para diferentes radios en el rango dado
    for radio = linspace(radio_min, radio_max, num_radios)
        % Acumulación de Hough para detectar círculos de radio radio en la imagen binaria BW
        H = hough_circles_acc(BW, radio);
        
        % Encontrar picos en la matriz de acumulación Hough
        centros_temp = hough_peaks(H, num_picos, 'Threshold', 0.7* max(H(:)));
        
        % Verificar si se encontraron suficientes picos para considerarlos como círculos válidos
        if (size(centros_temp, 1) > 0)
            num_filas_nuevo = num_filas + size(centros_temp, 1);
            % Almacenar los centros y radios encontrados en las matrices correspondientes
            centros(num_filas + 1:num_filas_nuevo, :) = centros_temp;
            radios(num_filas + 1:num_filas_nuevo) = radio;
            num_filas = num_filas_nuevo;
        end
    end
end
function H = hough_circles_acc(BW, radius)
    % Crear una matriz de acumulación H inicializada con ceros
    H = zeros(size(BW));
    
    % Recorrer cada columna de la imagen binaria BW
    for x = 1 : size(BW, 2)
        % Recorrer cada fila de la imagen binaria BW
        for y = 1 : size(BW, 1)
            % Verificar si el píxel en (x, y) es blanco (valor 1)
            if (BW(y,x))
                % Generar una serie de ángulos theta desde 0 a 2pi (360 grados)
                for theta = linspace(0, 2 * pi, 360)
                    % Calcular las coordenadas (a, b) del punto en el círculo de radio dado
                    a = round(x + radius * cos(theta));
                    b = round(y + radius * sin(theta));
                    
                    % Verificar si las coordenadas (a, b) están dentro de los límites de la matriz H
                    if (a > 0 && a <= size(H, 2) && b > 0 && b <= size(H,1))
                        % Incrementar el valor en la posición (b, a) de la matriz H
                        H(b,a) = H(b,a) + 1;
                    end
                end
            end
        end
    end
end

function peaks = hough_peaks(H, varargin)
    %% InputParser: inputParser es una herramienta útil en MATLAB para analizar 
    %% y validar los argumentos de entrada de una función,
    %% lo que permite una programación más robusta y flexible
    
    % Crear un objeto inputParser para analizar los argumentos de entrada
    p = inputParser;
    
    % Agregar un argumento opcional 'numpeaks' con valor predeterminado 1
    addOptional(p, 'numpeaks', 1, @isnumeric);
    
    % Agregar un argumento de parámetro 'Threshold' con valor predeterminado 0.7 * max(H(:))
    addParameter(p, 'Threshold', 0.7 * max(H(:)));
    
    % Agregar un argumento de parámetro 'NHoodSize' con valor predeterminado calculado a partir del tamaño de H
    addParameter(p, 'NHoodSize', floor(size(H) / 100.0) * 2 + 1);
    
    % Analizar los argumentos de entrada
    parse(p, varargin{:});

    % Obtener los valores de los argumentos analizados
    numpeaks = p.Results.numpeaks;
    threshold = p.Results.Threshold;
    nHoodSize = p.Results.NHoodSize;

    % Inicializar una matriz de picos vacía
    peaks = zeros(numpeaks, 2);
    
    % Inicializar el contador de picos encontrados
    num = 0;
    
    % Bucle para encontrar picos hasta alcanzar el número máximo de picos
    while(num < numpeaks)
        % Encontrar el valor máximo en la matriz H
        maxH = max(H(:));
        
        % Verificar si el valor máximo supera el umbral
        if (maxH >= threshold)
            % Incrementar el contador de picos
            num = num + 1;
            
            % Obtener las coordenadas del primer pico encontrado
            [r,c] = find(H == maxH);
            peaks(num,:) = [r(1),c(1)];
            
            % Calcular las coordenadas del vecindario para suprimir picos cercanos
            rStart = max(1, r - (nHoodSize(1) - 1) / 2);
            rEnd = min(size(H,1), r + (nHoodSize(1) - 1) / 2);
            cStart = max(1, c - (nHoodSize(2) - 1) / 2);
            cEnd = min(size(H,2), c + (nHoodSize(2) - 1) / 2);
            
            % Suprimir los valores del vecindario en la matriz H estableciéndolos a cero
            for i = rStart : rEnd
                for j = cStart : cEnd
                        H(i,j) = 0;
                end
            end
        else
            % Si el valor máximo no supera el umbral, salir del bucle
            break;          
        end
    end
    
    % Eliminar filas no utilizadas en la matriz de picos
    peaks = peaks(1:num, :);
end
function hough_circles_draw(img, centers, radii)
    % Mostrar la imagen original
    figure();
    subplot(1,2,1),
    imshow(img);
    title('Original image')
    subplot(1,2,2),
    imshow(img);
    title('Image with circles detected')
    hold on;
    % Recorrer cada centro y radio para dibujar los círculos
    for i = 1 : size(centers, 1)
        % Obtener el radio y los valores de coordenadas del centro
        r = radii(i);
        center_x = centers(i, 2);
        center_y = centers(i, 1);
        
        % Generar una serie de ángulos theta desde 0 a 2pi (360 grados)
        theta = linspace(0, 2 * pi, 360);
        
        % Calcular las coordenadas (xx, yy) de los puntos en el círculo
        xx = center_x + r * cos(theta);
        yy = center_y + r * sin(theta);
        
        % Dibujar el círculo en la imagen con color verde y grosor de línea de 2
        plot(xx, yy, 'g','LineWidth', 3);
    end
end

