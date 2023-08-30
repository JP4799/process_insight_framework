%set_dbscan.m
%Function to export images
%
%(c) Johannes Picker
%=========================================================================%
% Version history
%23.06.2023     Johannes Picker     creation of file
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

function set_dbscan(img,tsne_result,tsne_xy,tsne_z,clustering_info,ui_info)
    minpts = [];
    minpts.Value = 10;

    fig = uifigure('Name','Result DBSCAN');
    
    fig.Position(3:4) = [440 320];

    ax = uiaxes('Parent',fig,...
        'Position',[10 10 300 300]);
    
%     cbx = uicheckbox(fig,...
%         'Position',[320 220 100 20],...
%         'Text','AutoUpdate?',...
%         'Value', 0);

    lbl_epsilon = uilabel(fig,...
        'Text', 'Epsilon',....
        'Position',[320 220 100 20]);

    epsilon = uispinner(fig,...
        'Limits', [0.1  100],....
        'Position',[320 200 100 20],...
        'Value',4); %, ...
        %'ValueChangedFcn',@(epsilon,event) autoUpdate(...
         %          cbx,epsilon.Value,minpts.Value,ax, tsne_result));

    lbl_min_pnts = uilabel(fig,...
        'Text', 'Min Points',....
        'Position',[320 180 100 20]);

    minpts = uispinner(fig,...
        'Limits', [1  100],....
        'Position',[320 160 100 20],...
        'Value',10); %, ...
        %'ValueChangedFcn',@(minpts,event) autoUpdate(...
         %          cbx, epsilon.Value, minpts.Value, ax, tsne_result));
    
    btn = uibutton(fig,'push',...
                   'Text', 'Refresh',...
                   'Position',[320 130 100 20],...
                   'ButtonPushedFcn', @(btn,event) show_dbscan(...
                   epsilon.Value, minpts.Value, ax, tsne_result));

    loading = uilabel(fig,"Text","test", ...
        'Position',[320 260 100 20]);

    num_clusters = uilabel(fig,"Text","test", ...
        'Position',[320 280 100 20]);

    export_type = uibuttongroup(fig,'Position',[310 40 120 80]);  
    export_options = ["gray" "rgb"];

    lbl_min_pnts = uilabel(export_type,...
        'Text', 'Export Settings',...
        'FontWeight', 'bold',...
        'Position',[10 60 100 20]);

    rb1 = uidropdown(export_type,...
        'Position',[10 38 100 20],...
        'Items',export_options,...
        'ItemsData',1:length(export_options),...
        'Value',1);

    b3 = uibutton(export_type,...
        'Text', 'Export',...
        'Position',[10 10 100 20],...
        'ButtonPushedFcn', @(btn,event) pass_to_export(...
                   img,tsne_xy,tsne_z,export_options(rb1.Value),ui_info));

    if isempty(clustering_info)
        clustering_info = guihandles(fig);
        clustering_info.cmapped = [];
        clustering_info.epsilon = [];
        clustering_info.minptns = [];

        loading.Text = "Press Refresh";
        num_clusters.Text = "Num. Clusters: -";

    else
        minpts.Value = clustering_info.minpnts;
        epsilon.Value = clustering_info.epsilon;
        loading.Text = "Clusters on file";
        num_clusters.Text = "Num. Clusters: "+ string(max(clustering_info.cmapped));
        cmap = jet(max(clustering_info.cmapped));
        gscatter(ax, tsne_result(:,1),tsne_result(:,2),clustering_info.cmapped,cmap)
        legend(ax,'off')

    end

    function pass_to_export(img,tsne_xy,tsne_z,export_type,ui_info)
        export_images(img,tsne_xy,tsne_z,export_type,clustering_info,ui_info)
    end

    function show_dbscan(epsilon, minpts, ax,tsne_result)
        loading.Text = "Loading Clusters";
        drawnow
        disp("Loading Clusters")
    
        cmapped = dbscan(tsne_result,epsilon, minpts);
        gscatter(ax, tsne_result(:,1),tsne_result(:,2),cmapped)
        legend(ax,'off')
        
        loading.Text = "Clusters Loaded";
        num_clusters.Text = "Num. Clusters: " + string(max(cmapped));
        drawnow

        clustering_info = guidata(gcbo);
        clustering_info.cmapped = cmapped;
        clustering_info.epsilon = epsilon;
        clustering_info.minpnts = minpts;
        guidata(gcbo,clustering_info)
        assignin('base','clustering_info', clustering_info)
        legend(ax,'off')
    end

    
    % Automatic Refresh
    %function autoUpdate(cbx,epsilon, minpts, ax,tsne_result)
    %    if cbx.Value 
    %       show_dbscan(epsilon, minpts, ax,tsne_result);
    %    end
    %end

    

end

