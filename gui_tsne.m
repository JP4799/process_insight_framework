%gui_tsne.m 
%main gui for working with the tsne toolbox
%
%
%==========================================================================
%Version history
%18.10.2022     Thomas Gruenberger      new
%01.11.2022     Johannes Picker         implementing menu
%06.11.2022     Johannes Picker         read/write of images done
%07.11.2022     Johannes Picker         first finished version
%08.01.2023     Johannes Picker         started back-transformation
%==========================================================================
%Usage:
%   gui_tsne      
%Inputs:
%   none
%Outputs:
%   none
%Globals:
%   none
%==========================================================================
%Notes: 

function gui_tsne

main_menu.load_image_stacks             = 1;
main_menu.calculate_export_input_data   = 2;
main_menu.calculate_tsne_transformation = 3;
main_menu.visualize_results             = 4;
main_menu.save_data                     = 5;
main_menu.show_images                   = 6;
main_menu.import_data                   = 7;
main_menu.backtrans                     = 8;
main_menu.quit                          = 9;
menu_selected = 1;



log = status_logging();
[fig, uit] = log_window(log);

%persistent clustering_info
clustering_info = [];


%clc
%disp(log)





while and(menu_selected < main_menu.quit, menu_selected ~= 0)
try  
    figure(fig)
    menu_selected = menu('TSNE-Toolbox V1.00.04', ...
                         'Load imagestacks', ...
                         'Calculate and export tsne input data', ...
                         'Calculate tsne_Transformation', ...
                         'Visualize results', ...
                         'Save Workspace', ...
                         'Show Images',...
                         'Import Data',...
                         'Backtrans',...
                         'Quit');
    
    switch menu_selected
        case main_menu.load_image_stacks
           selection_menu;
           tic
           read_directory;
           read_images;
           %logging_table("Files Loaded",["Status", "Elapsed Time", "Path"]) ...
                                % = table("Done"  , toc           , "temp");
            log = log_data(log,"Files Loaded",'done',...
                toc,import_path,mat2str(size(img)));



        case main_menu.calculate_export_input_data
            % transform ui_info into stuct
            ui_info.kpis = ui_kpis;
            ui_info.layer_count = ui_layerCount;
            ui_info.range = ui_range;
            ui_info.runs = ui_runs;
            
            tic
            process_images;
            log = log_data(log,"t-SNE Matrix",'done',toc,"-",mat2str(size(tsne_matrix)));

        case main_menu.calculate_tsne_transformation
            [perplexity, distance, max_iter] = tsne_settings();
            tic
            tsne_result = tsne_calc_v2(tsne_matrix, perplexity, distance, max_iter);
            log = log_data(log,"t-SNE Calculation",'done',...
                toc,"-",mat2str(size(tsne_result)));

        case main_menu.visualize_results
            tsne_show;

        case main_menu.save_data
            try 
                clustering_info = evalin('base','clustering_info');
                log = log_data(log,"Backtransformation",'done',0,string(max(clustering_info.cmapped)),"");
            end
            save_data;

        case main_menu.show_images
            show_image(img, ui_runs, ui_kpis, ui_layerCount);

        case main_menu.import_data
            import_data;
            log = log_data(log,"Imported Data",'done',0,string(full_file_name),"");

        case main_menu.backtrans
            try 
                clustering_info = evalin('base','clustering_info');
            end
            set_dbscan(img,tsne_result,tsne_xy,tsne_z,clustering_info,ui_info);

        otherwise
            if isvalid(fig)
            close(fig)
            end

            clear clustering_info
            return
            
    end
    if ~isvalid(fig)
        [fig, uit] = log_window(log);
    else
        uit.Data = log;
    end

catch e
    fprintf(2,'There was an error! The message was:\n%s\n',e.message);
end
end

close all
clear clustering_info
end


function logging_table = log_data(logging_table,heading,value,time,path,info)
    logging_table(heading,["Status", "Elapsed Time", "Info", "Path"]) ...
        = table(string(value), time, string(info), string(path));
    % clc
    % disp(logging_table)
end

function [fig, uit] = log_window(log)
    fig = uifigure("Position",[500 500 760 300], ...
        'Name','Instance Information', ...
        'WindowStyle','modal');
    uit = uitable(fig, ...
        "Data",log, ...
        "Position",[20 20 720 280]);
        
end



    
   