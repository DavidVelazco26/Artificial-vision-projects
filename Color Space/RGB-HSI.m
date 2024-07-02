fabric = imread('fabric.png');
figure(2)
subplot(1, 3, 1)
imshow(fabric)
title('Original')

load regioncoordinates;

nColors = 6;
sample_regions = false([size(fabric,1) size(fabric,2) nColors]);

for count = 1:nColors
  sample_regions(:,:,count) = roipoly(fabric,region_coordinates(:,1,count),...
                                      region_coordinates(:,2,count));
end

% RGB Color Space
r = double(fabric(:,:,1)) / 255;  % Normalize R channel
g = double(fabric(:,:,2)) / 255;  % Normalize G channel
b = double(fabric(:,:,3)) / 255;  % Normalize B channel

color_markers_rgb = zeros(nColors, 3);

for count = 1:nColors
  color_markers_rgb(count, 1) = mean(r(sample_regions(:,:,count)));
  color_markers_rgb(count, 2) = mean(g(sample_regions(:,:,count)));
  color_markers_rgb(count, 3) = mean(b(sample_regions(:,:,count)));
end

subplot(1, 3, 2)
scatter3(r(:), g(:), b(:), 10, [r(:) g(:) b(:)], '.')
title('RGB Color Space')
xlabel('Red')
ylabel('Green')
zlabel('Blue')

% HSI Color Space
h = acos(0.5 * ((r - g) + (r - b)) ./ sqrt((r - g).^2 + (r - b) .* (g - b)));
h(b > g) = 2 * pi - h(b > g);
h = h / (2 * pi);

s = 1 - 3 * min(r, min(g, b)) ./ (r + g + b + eps);
i = (r + g + b) / 3;

hsv_fabric = cat(3, h, s, i);

subplot(1, 3, 3)
scatter3(h(:), s(:), i(:), 10, [r(:) g(:) b(:)], '.')
title('HSI Color Space')
xlabel('Hue')
ylabel('Saturation')
zlabel('Intensity')

colormap(gca, 'hsv')
colorbar


