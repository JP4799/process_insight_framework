%exportimages.m
%Export cutted layer images
%
%(c) Johannes Picker
%=========================================================================%
% Version history
%13.04.2023     Johannes Picker     creation of file
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
% Notes: structure img : img{<Run>,<kpi>,<Layer>}

for i = 1:length(ui_runs)
    for k = 1:ui_layerCount
        for j = 1:length(ui_kpis)
        num = sprintf("%04d", k);
        imwrite(img{i,j,k}, "./Images/"+ ui_runs(i)+ "_"+ ui_kpis(j) + ...
            "_Layer_" + num + ".tiff")
        end
    end
end