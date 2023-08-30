%process_images.m 
%tranfersing images into Matrix for tsne
%
%(c) Johannes Picker
%==========================================================================
%Version history
%01.11.2022     Johannes Picker     creation of file
%07.11.2022     Johannes Picker     first finished version
%==========================================================================
%Usage:
%   process_images
%Inputs:
%   img
%   tiff_size
%   prod_tiff_size
%Outputs:
%   tsneMatrix
%   tsneLable
%   tsneXY
%Globals:
%   ui_runs
%   ui_kpis
%   ui_layerCount
%   ui_range
%==========================================================================
%Notes: Saving of csv not implemented yet 

%% Coordinate Matrix
% For determining the X and Y position of points in tsneMatrix

tiff_size = [ui_range(1,2)-ui_range(1,1)+1
            ui_range(2,2)-ui_range(2,1)+1];


x = linspace(1,tiff_size(1),tiff_size(2));
y = linspace(1,tiff_size(1),tiff_size(2));
[X,Y] = meshgrid(x,y);

prod_tiff_size = prod(tiff_size);

cords = [reshape(X,prod_tiff_size,1),reshape(Y,prod_tiff_size,1)];

%% Allocating Space

tsne_matrix = zeros(length(ui_runs)*ui_layerCount*prod_tiff_size,length(ui_kpis),'double');
tsne_label = cell(length(ui_runs)*ui_layerCount*prod_tiff_size,1);
tsne_xy = zeros(length(ui_runs)*ui_layerCount*prod_tiff_size,2);
tsne_z = zeros(length(ui_runs)*ui_layerCount*prod_tiff_size,1);

row_index = 1;
pixel_written = prod_tiff_size;
z_height = 1;

%% Iterate over Images
tic
for i = 1:length(ui_runs) % Loop vars are switched for this operation!
    for k = 1:ui_layerCount
        for j = 1:length(ui_kpis)
            insertion = reshape(img{i,j,k},[prod_tiff_size,1]);

            tsne_matrix(row_index:pixel_written,j) = insertion;
            tsne_xy(row_index:pixel_written,:) = cords;
            tsne_label(row_index:pixel_written, 1) = ui_runs(i);
            tsne_z(row_index:pixel_written,1) = z_height;

            % fprintf('Run: %.2d KPI: %.2d Layer: %.3d Mean: %.5d\n', i,j,k,mean(insertion));
        end
    row_index = row_index + prod_tiff_size;
    pixel_written = pixel_written + prod_tiff_size;
    z_height = z_height + 1;
    end

end

%% Remove Zeros
% find row with least amount of zeros
column = 0;
amount_zeros = length(tsne_matrix);

for i = 1:length(ui_kpis)
    numofzeros = sum(tsne_matrix(:,i)==0);
    if numofzeros < amount_zeros
        column = i;
        amount_zeros = numofzeros;
    else
        % next
    end
end
%%

[index] = find(tsne_matrix(:,column) == 0);
tsne_label(index) = [];
tsne_matrix(index,:) = [];
tsne_xy(index,:) = [];
tsne_z(index,:) = [];


%% Clearing Variables
% clear i j k x y X Y ...
%     rowIndex pixelWritten ...
%     insertion ...
%     tiffSize TIFFSIZE ...
%     cords

