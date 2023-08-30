%export_images.m
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

function export_images(img,tsne_xy,tsne_z,export_type,clustering_info,ui_info)
   
    cmapped = clustering_info.cmapped;
    %export_type = "rgb";
    
    % create folder
    folder_name = sprintf('%s_Export', datestr(now,'yyyymmdd_HHMMSS'));
    if export_type == "debug"
        disp("Debug Active")
    elseif ~exist(folder_name, 'dir')
       mkdir(folder_name)
    else
       disp("Folder Already Exists")
       return
    end
    
    % check export_type
    switch export_type
        case "rgb"
            cmap = jet(max(cmapped));
        case "gray"
            padding = 10;
            cmap = flipud(gray(max(cmapped)+2*padding));
        case "debug"
            cmap = jet(max(cmapped));
        otherwise
            disp("Error")
            return
    end
    
    sub_folder = sprintf('%s/%s', folder_name, "clusters");
    if ~exist(sub_folder, 'dir')
      mkdir(sub_folder);
    end

    for j=1:max(tsne_z)
        num = sprintf("%04d", j);
    
        [single_layer] = find(tsne_z(:,1) == j);
        one_layer_indx = cmapped(single_layer);
        one_layer_xy = tsne_xy(single_layer,:);
    
        size_img = size(img{1,1,1});
        single_image = zeros(size_img(1), size_img(2), 3);
    
        for i = 1:length(one_layer_indx)
            % Convert the integer to an RGB triplet
            rgb_triplet = ind2rgb(one_layer_indx(i), cmap);
            single_image(one_layer_xy(i,2),one_layer_xy(i,1),:) = rgb_triplet(1,1,:);
        end
    
        switch export_type
            case "rgb"
                imwrite(single_image, "./"+ sub_folder +"/"+"Layer_"+ "rgb_" + num + ".tiff")
    
            case "gray"
                %single_image_gray = single_image;
                imwrite(single_image, "./"+ sub_folder +"/"+"Layer_"+ "gray_" + num + ".tiff")
            case "debug"
                imshow(single_image)
                % uiwait()
                
        end
    end
        for i = 1:length(ui_info.kpis)
        sub_folder = sprintf('%s/%s', folder_name, ui_info.kpis{i});
        if ~exist(sub_folder, 'dir')
          mkdir(sub_folder);
        end
        end

        
        for i = 1:length(ui_info.runs)
        for j = 1:length(ui_info.kpis)
            sub_folder = ui_info.kpis(j);
            for k = 1:ui_info.layer_count
                num = sprintf("%04d", k+(ui_info.layer_count*(i-1)));
                imwrite(img{i,j,k}, "./"+ folder_name +"/"+ sub_folder ...
                    +"/"+"Layer_"+ ui_info.kpis{j}+"_"+ ui_info.runs{i} ...
                    +"_"+ num + ".tiff")
            end
        end
        end
        
    fprintf("Files Exported: %s\n", folder_name)

end
