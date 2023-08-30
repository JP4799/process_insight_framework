%import_data.m
%Import Data
%
%(c) Johannes Picker
%=========================================================================%
% Version history
%22.06.2023     Johannes Picker     creation of file
%=========================================================================%
% Usage:
%   
%Inputs:
%   
%Outputs:
%   tiff images
%Globals:
%   none
%=========================================================================%
% Notes: 

%% Import data

[filename, pathname] = uigetfile('*.mat');
full_file_name = fullfile(pathname,filename);

% use matfile for faster processing?
if exist(full_file_name, 'file')
    load(full_file_name)
else
    warningMessage = sprintf('Warning: mat file does not exist:\n%s',...
        full_file_name);
    uiwait(errordlg(warningMessage));
    return;
end

fprintf("\n-------------------\n")
fprintf("IMPORTED DATA INFO:\n")
fprintf("Note: \n %s \n\n", note)
fprintf("KPIS: \n")
disp(ui_kpis)
fprintf("Layer Count: %i\n\n",ui_layerCount)
fprintf("Range:\n")
disp(ui_range)
fprintf("Runs: ")
disp(ui_runs)
fprintf("\n-------------------\n")


