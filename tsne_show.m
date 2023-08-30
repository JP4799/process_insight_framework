%tsne_show.m 
%graphical representation of tsne result with lable
%
%(c) Johannes Picker
%===========================================
%Version history
%05.11.2022     Johannes Picker     creation of file
%07.11.2022     Johannes Picker     first finished version
%===========================================
%Usage:
%   tsne_show
%Inputs:
%   tsne_result
%   tsne_label
%   tsne_xy
%Outputs:
%   gscatter    grouped scatter plot
%Globals:
%   none
%===========================================
%Notes: tsneXY can also be used as lable, but it takes a long time with
%       a higher range of the images

%% Visualize tsne
figure
if ui_runs(1) == "NoRun"
    gscatter(tsne_result(:,1),tsne_result(:,2))
else
    gscatter(tsne_result(:,1),tsne_result(:,2),tsne_label)    
end