%read_images.m 
%reading of images
%
%(c) Johannes Picker
%==========================================================================
%Version history
%01.11.2022     Johannes Picker     creation of file
%07.11.2022     Johannes Picker     first finished version
%==========================================================================
%Usage:
%   read_images
%Inputs:
%   none
%Outputs:
%   img         cell with image data | indexing: img{<Run>,<kpi>,<Layer>}
%Globals:
%   ui_runs
%   ui_kpis
%   ui_layerCount
%   ui_range
%==========================================================================
%Notes: 

%% Preallocating Memory
img = cell(length(ui_runs),length(ui_kpis),ui_layerCount);

% temp_img = zeros(2500); % !Image size currently not dynamic!

%% Loading images into Memory
% structure img --> img{<Run>,<kpi>,<Layer>}
for i = 1:length(ui_runs)
    for j = 1:length(ui_kpis)
        for k = 1:ui_layerCount
             file = images{i,j,k};
             % if is Tiff not needed --> in read only tiffs
             t = Tiff(file);
             temp_img = read(t);
             close(t);
             layer_img = temp_img(ui_range(1,1):ui_range(1,2),...
                                  ui_range(2,1):ui_range(2,2));
             img{i,j,k} = layer_img;
             
             % Uncomment to show images when loading
              % show_img_loading(layer_img,i,j,k,ui_runs,ui_kpis);
             
        end
    end
end
close


function show_img_loading(layer_img,i,j,k,ui_runs,ui_kpis)
    imshow(layer_img,'InitialMagnification', 400)
    title(ui_runs(i)+" "+ui_kpis(j)+" "+k, Interpreter="none")
    pause(0.2)

end
    
%% Clearing of variables
% clear i j k rowIndex pixelWritten tempImg layerImage t file

