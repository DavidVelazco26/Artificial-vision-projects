function detected_circles = hough_circle(img, min_radius, max_radius, threshold)
    % Convertir la imagen a escala de grises
    gray = im2gray(img);
    
    % Aplicar desenfoque Gaussiano para reducir el ruido
    blurred = imgaussfilt(gray, 2);
    
    % Dimensiones de la imagen
    [height, width] = size(blurred);
    
    % Rango de los radios de los círculos
    radii_range = min_radius:max_radius;
    num_radii = numel(radii_range);
    
    % Crear matriz acumuladora
    accumulator = zeros(height, width, num_radii);
    
    % Umbral para la detección de círculos
    max_accumulator = 0.3 * max(accumulator(:));
    
    % Bucle sobre cada píxel de la imagen
    for y = 1:height
        for x = 1:width
            % Solo considerar los píxeles blancos
            if blurred(y, x) > 0
                % Bucle sobre los radios de los círculos
                for r = 1:num_radii
                    % Calcular las coordenadas del centro del círculo
                    for theta = linspace(0, 2 * pi, 100)
                        a = round(x - radii_range(r) * cos(theta));
                        b = round(y - radii_range(r) * sin(theta));
                        
                        % Verificar si las coordenadas están dentro de la imagen
                        if a > 0 && a <= width && b > 0 && b <= height
                            % Incrementar el contador en la matriz acumuladora
                            accumulator(b, a, r) = accumulator(b, a, r) + 1;
                        end
                    end
                end
            end
        end
    end
    
    % Detectar los círculos con suficientes votos
    detected_circles = [];
    [y_coords, x_coords, radii_idxs] = ind2sub(size(accumulator), find(accumulator > max_accumulator));
    for i = 1:numel(x_coords)
        center = [x_coords(i), y_coords(i)];
        radius = radii_range(radii_idxs(i));
        detected_circles = [detected_circles; struct('center', center, 'radius', radius)];
    end
end


