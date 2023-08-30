%parameter_exploration.m
%Function to explore parameters
%
%(c) Johannes Picker
%=========================================================================%
% Version history
%23.06.2023     Johannes Picker     creation of file
%=========================================================================%
% Usage:
%   no usage
%Inputs:
%   
%Outputs:
%   structs of paramerter exploration
%Globals:
%   none
%=========================================================================%
% Notes: 

%% Perplexity Testing
parameter = "perplexity";
data = [5 10 25 60 100 200];

perplex = par_exploration(tsne_matrix, parameter, data);
show_plot(perplex.data,perplex.embedding,perplex.parameter,tsne_label)

%%

show_plot(perplex.data,perplex.embedding,perplex.parameter,tsne_label)

%% Distance Testing

parameter = "distance";
data = ["euclidean" "seuclidean" "cityblock" "chebychev" "minkowski" "mahalanobis"];

distance = par_exploration(tsne_matrix, parameter, data);

show_plot(distance.data, distance.embedding, distance.parameter, tsne_label)
%%
show_plot(distance.data, distance.embedding, distance.parameter, tsne_label)
%% Max_Iter Testing
parameter = "max_iter";
data = [100 250 500 1000 2000];

max_iter = par_exploration(tsne_matrix, parameter, data);
%%
show_plot(max_iter.data, max_iter.embedding, max_iter.parameter, tsne_label)
%%
% save("parameter_eval.mat")
%%
time_per_worker(distance);

% time_per_worker(perplex)
%t ime_per_worker(max_iter)
%%
% time_per_worker(max_iter)
show_plot(max_iter.data, max_iter.embedding, max_iter.parameter, tsne_label)
show_plot(distance.data, distance.embedding, distance.parameter, tsne_label)
show_plot(perplex.data,perplex.embedding,perplex.parameter,tsne_label)

%% Functions

function output = par_exploration(tsne_matrix, parameter, data)
    distance = strings(length(data), 1);
    perplexity = zeros(length(data), 1);
    max_iter = zeros(length(data), 1);
    standardize = zeros(length(data), 1);
    info = strings(length(data),1);

    perplexity(:) = 100;
    distance(:) = 'euclidean';
    max_iter(:) = 1000;
    standardize(:) = false;

    
    switch parameter
        case "distance"
            disp("dist")
            distance = data;
        case "perplexity"
            disp("perplexity")
            perplexity = data;
        case "max_iter"
            disp("max_iter")
            max_iter = data;
        case "standardize"
            disp("standardize")
            standardize = data;
    end

    embedding = cell(length(data), 1);
    losses = cell(length(data),1);
    
    time = Par(length(data));

    tic
    rng default
    % Set up a parfor loop to run t-SNE in parallel with different perplexity values
    parfor i = 1:length(data)
        Par.tic;
        % Set the parameter value for this iteration
        
        opts = statset('MaxIter',max_iter(i));
        [Y, loss] = tsne(tsne_matrix,'Options', opts,...
            'Perplexity', perplexity(i), 'Distance', distance(i), ...
            'Standardize', standardize(i));
        % Store the resulting embedding in the cell array
        embedding{i} = Y;
        losses{i} = loss;
        time(i) = Par.toc;
        info(i) = string(data(i));
    end
        stop(time);                      
        plot(time);    
        fulltime = toc;

    output.embedding = embedding;
    output.losses = losses;
    output.time = time;
    output.info = info;
    output.fulltime = fulltime;
    output.parameter = parameter;
    output.data = data;

end


function show_plot(input_par,embeddings,desc, tsne_label)
    figure;
    set(gca,'defaultTextInterpreter','none')
    rectangleDims = findRectangleDimensions(length(input_par));
    t = tiledlayout(rectangleDims(1),rectangleDims(2),'TileSpacing','Compact','Padding','Compact');
    t.Units = 'centimeters';

    capitalize = @(c) upper(extractBefore(c, 2)) + extractAfter(c, 1);
    txt = title(t,sprintf('Parameter Exploration: %s',capitalize(desc)));
    txt.FontName = 'LM Sans 12';
    txt.Interpreter = 'none';
    txt.FontSize = 12;

    % Credit capitalize function: https://stackoverflow.com/questions/50064269/matlab-capitalize-first-letter-in-string-array

    for i = 1:length(input_par)
        nexttile
        %subplot(rectangleDims(1),rectangleDims(2),i);
        gscatter(embeddings{i}(:, 1), embeddings{i}(:, 2),tsne_label);
        subtxt = title(sprintf('%s = %s', string(desc), string(input_par(i))));
        subtxt.FontName = 'LM Sans 12';
        subtxt.FontWeight = 'normal';
        subtxt.FontSize = 10;
        legend("off")    
    end
end

function rectangleDims = findRectangleDimensions(number)
    % Start with an initial guess of the square root of the number
    initialGuess = sqrt(number);

    % Round the initial guess to the nearest integer
    side1 = round(initialGuess);
    
    % Calculate the second side of the rectangle
    side2 = ceil(number / side1);
    
    % Output the dimensions of the rectangle
    rectangleDims = [side1, side2];
end

function time_per_worker(struc)
    fmt = "hh:mm:ss";
    fprintf("Worker  Parameter   Time     Loss    \n")

    for i = 1:length(struc.data)
        d = seconds(struc.time(i).ItStop);
        t_fmt = string(d,fmt);
        fprintf("%2.0f %15s %s %s \n", ...
            struc.time(i).Worker, string(struc.data(i)), t_fmt, string(struc.losses(i)));
    end
    %output = table(struc.time.Worker,cell2table(struc.data), struc.time.ItStop, cell2mat(struc.losses))
end


