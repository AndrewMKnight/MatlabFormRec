clc %Limpia la pantalla
clear all %limpia todas las variables
close all %cierra todo
warning off all %evita llamadas de atención

%variables

%Pasar a escala de grises 
I = imread('Figuras.jpg');
I = rgb2gray(I);
figure(1)
title('IMAGEN ORIGINAL');
[fila,columna]=size(I);

I = wiener2(I,[50 50]);
imshow(I);
I = im2bw(I,0.20);
figure(1)
imshow(I)
I = bwareaopen(I,130);
se = strel('disk',5);
I = imclose(I,se);
figure
imshow(I)

[B,L] = bwboundaries(I,'noholes');
imshow(label2rgb(L,@jet,[.5 .5 .5]))
hold on

for k = 1:length(B)  boundary = B{k};
    plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end

stats = regionprops(L,'Area','Centroid');
threshold = 0.94;
for k = 1:length(B)
    boundary = B(k);
    delta_sq = diff(boundary).^2;
    perimeter = sum(sqrt(sum(delta_sq,2)));
    area = stats(k).Area;
    metric = 4*pi*area/perimeter^2;
    metric_string = sprintf('%2.2f',metric);
if metric > threshold
   centroid = stats(k).Centroid;
   plot(centroid(1),centroid(2),'ko');
end
     text(boundary(1,2)-35,boundary(1,1)+13,metric_string,'Color','k','FontSize',20,'FontWeight','bold')
end
