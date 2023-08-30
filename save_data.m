%save_data.m
%save relevant workspace variables to file
%
%(c) Johannes Picker
%==========================================================================
%Version history
%05.11.2022     Johannes Picker     creation of file
%07.11.2022     Johannes Picker     first finished version
%==========================================================================
%Usage:
%   save_data
%Inputs:
%   tsneMatrix      Should every variable be listed here?
%   tsneLable
%   tsneXY
%   tsneResult
%   ui_kpis
%   ui_layerCount
%   ui_range
%   ui_runs%Outputs:
%   tsneMatrix
%   tsneLable
%   tsneXY
%   tsneResult
%   ui_kpis
%   ui_layerCount
%   ui_range
%   ui_runs
%   directory
%Globals:
%   tsneMatrix
%   tsneLable
%   tsneXY
%   tsneResult
%   ui_kpis
%   ui_layerCount
%   ui_range
%   ui_runs
%==========================================================================
%Notes: More variabels to be saved?

%% User-input
prompt = {'Enter Filename:','Enter Note'};
dlgtitle = 'Save Function';
dims = [1 50];
definput = {'sampleName','sampleNote'};
answer = inputdlg(prompt,dlgtitle,dims,definput);

fileName = string(answer{1});
note = answer{2};

%% Saving
save(fileName +'.mat','note',...
    'tsne_matrix','tsne_label','tsne_xy', 'tsne_z', 'tsne_result',...
    'ui_kpis','ui_layerCount','ui_range','ui_runs', ...
    'ui_info',...
    'clustering_info',...
    'img',...
    'images', 'directory', ...
    'log')

% writematrix(tsne_result,fileName + '_result.csv','Delimiter','semi')
% writematrix(tsne_matrix,fileName + '_inputmatrix.csv','Delimiter','semi')
% writematrix(string(tsne_label),fileName + '_runs.csv','Delimiter','semi')
% writematrix(string(tsne_xy),fileName + '_xy.csv','Delimiter','semi')
% writematrix(string(tsne_z),fileName + '_z.csv','Delimiter','semi')
% writematrix(string(clustering_info.cmapped),fileName + '_clusters.csv','Delimiter','semi')

T = array2table(tsne_matrix,...
    'VariableNames',ui_kpis);

writematrix(tsne_result,fileName + '_result.csv','Delimiter','semi')
writetable(T,fileName + '_inputmatrix.csv','Delimiter','semi')
writematrix(string(tsne_label),fileName + '_runs.csv','Delimiter','semi')
writematrix(string(tsne_xy),fileName + '_xy.csv','Delimiter','semi')
writematrix(string(tsne_z),fileName + '_z.csv','Delimiter','semi')
writematrix(string(clustering_info.cmapped),fileName + '_clusters.csv','Delimiter','semi')
