%viz_images.m
%visualisation of exported colored images
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
%   gui window
%Globals:
%   none
%=========================================================================%
% Notes:

function viz_images

folder = uigetdir;
files = dir(folder);

%files = dir('C:\Users\johan\Documents\_Education\FH Wiener Neustadt\Masterarbeit\01_Code\framework_sandbox\20230702_210703_Export');
%files = dir('C:\Users\johan\Documents\_Education\FH Wiener Neustadt\Masterarbeit\01_Code\framework_sandbox\20230625_224805_Export NewDataset\20230625_233042_Export');
files = files(~startsWith({files.name}, '.'));
files = files(endsWith({files.name}, '.tiff'));
fig = uifigure('Position',[100 100 1000 600]);
g = uigridlayout(fig,[2 4]);
g.RowHeight = {40,'2x','fit'};
g.ColumnWidth = {'1x','2x'};

parts = strsplit(folder, '\');
fig.Name = string(parts(end));


for i=1:length(files)
        path = fullfile(files(i).folder,files(i).name);
        t = Tiff(path);
        temp_img = read(t);
        close(t);
        %img{i} = double(squeeze(temp_img));
        img{i} = double(temp_img); %#ok<AGROW>

%         disp(max(max(img{i})))
%         disp(min(min(temp_img)))
end

img_mat = cell2mat(img);
lim_set = [min(min(min(img_mat))) max(max(max(img_mat)))];

% Add title
title = uilabel(g,'Text','Visualization');
title.FontName = 'LM Sans 12';
title.HorizontalAlignment = 'center';
title.FontSize = 24;
title.Layout.Row = 1;
title.Layout.Column = [1,2];

% Add two axes
ax1 = uiaxes(g);
ax2 = uiaxes(g);
ax2.Layout.Row = [2 4];


%h = slice(ax2,collection, [], [], 1:size(collection,3));
%set(h, 'EdgeColor','interp', 'FaceColor','interp')
%alpha(.1)



%histogram(ax1,collection(:,:,:),'BinWidth',1)

sld = uislider(g, ...
    "ValueChangedFcn",@(src,event) get_img);
sld.Limits = lim_set;
sld.Tooltip = "Lower Limit";

sld.Value = 0;
sld.Layout.Row = 3;
sld.Layout.Column = 1;

sld2 = uislider(g, ...
    "ValueChangedFcn",@(src,event) get_img);
sld2.Limits = lim_set;
sld2.Tooltip = "Upper Limit";

sld2.Value = lim_set(2);
sld2.Layout.Row = 4;
sld2.Layout.Column = 1;


get_img;


function get_img
    
    if sld.Value < sld2.Value  
        lower = sld.Value;
        upper = sld2.Value;
    else
        lower = sld2.Value;
        upper = sld.Value;
    end

    collection = zeros(size(img{1},1));
    masked = img;

    for j=1:length(masked)
        single_image = masked{j};
        single_image(single_image==0)=nan;
        single_image(single_image<=lower)=nan;
        single_image(single_image>=upper)=nan;

        %img(img~=85)=nan;
        collection(:,:,j) = flipud(single_image(:,:,1));
        %collection(:,:,j) = single_image(:,:,1);

    end

    h = slice(ax2,collection, [], [], 1:size(collection,3));
    set(h, 'EdgeColor','interp', 'FaceColor','interp')

    alpha(h, .1)

    hist = histogram(ax1,collection(:,:,:),'BinWidth',1,'BinLimits',lim_set);
end
end


