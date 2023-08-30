%backtrans_dbscan
%Transfering images from dbscan into tiff
%
%(c) Johannes Picker
%==========================================================================
%Version history
%17.03.2023     Johannes Picker     creation
%==========================================================================
%Usage:
%   backtrans_dbscan
%Inputs:
%   
%Outputs:
%   
%Globals:
%   ui_runs
%   ui_kpis
%   ui_layerCount
%   ui_range
%==========================================================================
%Notes: Saving of csv not implemented yet 

%% Splittin Layers into Slices

idx = dbscan(tsne_result,4,10);
gscatter(tsne_result(:,1),tsne_result(:,2),idx)  
%%
figure 
tiledlayout(3,2)

for i=1:6
    nexttile
    [layer_filter] = find(tsne_z(:,1) == i & idx == 1 );
    gscatter(tsne_xy(layer_filter,1),tsne_xy(layer_filter,2),idx(layer_filter),[],"s")

    % gscatter(tsne_xycut(layer_filter,1),tsne_xycut(layer_filter,2),selection(layer_filter),[],'s')
    xlim([0 tiff_size(1)]) 
    ylim([0 tiff_size(2)])
    rectangle('Position',[23.5 13.5 64 69])
    daspect([1 1 1])
end

%% Getting first layer RGB Falschfarbe

[single_layer] = find(tsne_z(:,1) == 6);
one_layer_indx = idx(single_layer);
one_layer_xy = tsne_xy(single_layer,:);

%diff = setxor(cords,one_layer_xy);
single_image = zeros(length(x),length(y),3);
% Define a colormap
cmap = jet(max(idx));
for i = 1:length(one_layer_indx)
    % Define a colormap

    % Convert the integer to an RGB triplet
    rgb_triplet = ind2rgb(one_layer_indx(i), cmap);
    single_image(one_layer_xy(i,2),one_layer_xy(i,1),:) = rgb_triplet(1,1,:);
%     single_image(one_layer_xy(i,2),one_layer_xy(i,1),:) = ...
%         uint8([one_layer_indx(i)*100, 0, 0]);
end
figure
imshow(single_image)
%% Saving working

tiledlayout(12,5)
cmap = jet(max(idx));

createTiff = 1;


for j=1:max(tsne_z)
nexttile
[single_layer] = find(tsne_z(:,1) == j);
one_layer_indx = idx(single_layer);
one_layer_xy = tsne_xy(single_layer,:);

%diff = setxor(cords,one_layer_xy);
single_image = zeros(length(x),length(y),3);
% Define a colormap
for i = 1:length(one_layer_indx)
    % Define a colormap

    % Convert the integer to an RGB triplet
    rgb_triplet = ind2rgb(one_layer_indx(i), cmap);
    single_image(one_layer_xy(i,2),one_layer_xy(i,1),:) = rgb_triplet(1,1,:);
%     single_image(one_layer_xy(i,2),one_layer_xy(i,1),:) = ...
%         uint8([one_layer_indx(i)*100, 0, 0]);
end
imshow(single_image)
single_image = im2uint16(single_image);
    if createTiff == 1
        t = Tiff("Layer_" + int2str(j) + ".tiff",'w');
        tagstruct.ImageLength = size(single_image,1); 
        tagstruct.ImageWidth = size(single_image,2);
        tagstruct.Photometric = Tiff.Photometric.RGB;
        tagstruct.BitsPerSample = 16;
        tagstruct.SamplesPerPixel = 3;
        tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky; 
        tagstruct.Software = 'MATLAB';
        setTag(t,tagstruct)
        write(t,single_image);
        close(t);
    end
end

%% Export with greyscale image
figure
tiledlayout(3,2)
padding = 10;
cmap = hsv(max(idx)+2*padding);

createTiff = 0;
x = 100; % make DYNAMIC!
y = 100;

for j=1:max(tsne_z)
nexttile
[single_layer] = find(tsne_z(:,1) == j);
one_layer_indx = idx(single_layer);
one_layer_indx = one_layer_indx + padding;
one_layer_xy = tsne_xy(single_layer,:);

%diff = setxor(cords,one_layer_xy);
single_image = zeros(length(x),length(y),3);
% Define a colormap
for i = 1:length(one_layer_indx)
    % Define a colormap

    % Convert the integer to an RGB triplet
    rgb_triplet = ind2rgb(one_layer_indx(i), cmap);
    single_image(one_layer_xy(i,2),one_layer_xy(i,1),:) = rgb_triplet(1,1,:);

end

imshow(single_image)
if createTiff == 1
    single_image_gray = rgb2gray(single_image);
    num = sprintf("%04d", j);
    imwrite(single_image_gray, "./Export/"+"Layer_"+ "gray_" + num + ".tiff")
end

% imshow(single_image)
% 
%     if createTiff == 1
%         num = sprintf("%04d", j);
%         t = Tiff("./Export/"+"Layer_"+ "gray_" + num + ".tiff",'w');
%         tagstruct.ImageLength = size(single_image,1); 
%         tagstruct.ImageWidth = size(single_image,2);
%         tagstruct.Photometric = 1;
%         tagstruct.BitsPerSample = 16;
%         tagstruct.SamplesPerPixel = 3;
%         tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky; 
%         tagstruct.Software = 'MATLAB';
%         setTag(t,tagstruct)
%         write(t,single_image);
%         close(t);
%     end
end