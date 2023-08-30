%read_directory.m 
%reading of file path and getting path of all images
%
%(c) Johannes Picker
%==========================================================================
%Version history
%01.11.2022     Johannes Picker     creation of file
%07.11.2022     Johannes Picker     first finished version
%==========================================================================
%Usage:
%   read_directory
%Inputs:
%   none
%Outputs:
%   images      Cell with paths of images | indexing: images{<Run>,<kpi>,<Layer>}     
%Globals:
%   ui_runs
%   ui_kpis
%==========================================================================
%Notes: 

%% Preallocation of Memory
images = cell(length(ui_runs),length(ui_kpis));

%% Creating cell-array with file paths of images
% structure images --> images{<Run>,<kpi>,<Layer>}
for i = 1:length(ui_runs)
    for j = 1:length(ui_kpis)
        str = ['*',ui_kpis(j),'*.tiff';];
        path = char(join(str,""));
        if isempty(sub_folder)
            image = dir(fullfile(...
            directory,char(ui_kpis(j)),path));
        else
            image = dir(fullfile(...
            directory,char(ui_runs(i)),sub_folder,char(ui_kpis(j)),path));
        end

        for k = 1:length(image)
            images{i,j,k} = fullfile(image(k).folder,image(k).name);

        end
    end
end

%% Check if layerCount to high
if ui_layerCount > size(images,3)
    msg = 'Max Layercount is ' + string(size(images,3))...
    + '! Please choose lower layer count!';
    error(msg)
end
    
%% Clearing of variables
% clear image i j k noFilter path str

