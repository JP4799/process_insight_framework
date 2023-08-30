%selection_menu.m
%menu for selecting Runs/KPIs/Layers/Image Range
%
%(c) Johannes Picker
%==========================================================================
%Version history
%05.11.2022     Johannes Picker     creation of file
%07.11.2022     Johannes Picker     first finished version
%==========================================================================
%Usage:
%   selection_menu
%Inputs:
%   none
%Outputs:
%   ui_runs
%   ui_kpis
%   ui_layerCount
%   ui_range
%Globals:
%   none
%==========================================================================
%Notes: Choice of Fill/No-Fill Subfolder hard-coded
%       TODO: Variables could be more verbose

%% Show gui for folder selection

directory = uigetdir;

% Uncomment for static Folder
% directory = 'C:\Users\johan\Documents\_Education\FH Wiener Neustadt\Masterarbeit\02_Messdaten\Result';

if ~directory
    msg = 'Please use a valid Directory';
    error(msg)
end


%% Subfolder
% Selection if Missing Points should be filled or not
%sub_folder = "NO-Fill-Missing-Points\th45_res01";
% sub_folder = "th60_fpn_res01";
% sub_folder = "Fill-Missing-Points\th45_fpn_res01_fill_missing_points";
%% Get Subfolder

%% Get Runs
d = dir(directory);
d = d(~startsWith({d.name}, '.'));     % deletion of unnessesary list-items
d = d(~endsWith({d.name},'.csv'));


folders = {d.name};
if max(contains(folders,"Run"))
    [items,~] = listdlg('PromptString',{ ...
        'Select Runs.',...
        'Multiple Files can be selected.',''},...
        'SelectionMode','multiple','ListString',folders);
    ui_runs = folders(items);
    sub_folder  = "NO-Fill-Missing-Points\th45_res01";
    directory_kpis = fullfile(directory,ui_runs(1),sub_folder);


    if ~ui_runs{1}
        msg = 'Please make a selection!';
        error(msg)
    end
else
    ui_runs = {['NoRun']};
    sub_folder = [];
    directory_kpis = fullfile(directory);
end

import_path = directory;



%% Get KPIs
d = dir(directory_kpis);
d = d(~startsWith({d.name}, '.'));
d = d(~endsWith({d.name},'.csv'));

folders = {d.name};
[items,~] = listdlg('PromptString',{...
    'Select KPIs.',...
    'Multiple Files can be selected.',''},...
    'SelectionMode','multiple','ListString',folders);
ui_kpis = folders(items);

%% Get range and layercount
prompt = {'Enter Layer Count:',...
          'Enter range (format: x1 x2 ; y1 y2)'};
dlgtitle = 'Input';

dims = [1 35];
definput = {'10','1201 1300; 1201 1300'};

answer = inputdlg(prompt,dlgtitle,dims,definput);

ui_layerCount = str2num(answer{1}); %#ok<*ST2NM> 
ui_range = str2num(answer{2});


%% Clearing of variables
% clear answer d definput dims directory_kpis...
%     dlgtitle fn indx prompt subFolder tf
