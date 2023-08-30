%tsne_calc_v2.m
%Calculate tsne with more options for settings
%
%(c) Johannes Picker
%=========================================================================%
% Version history
%13.04.2023     Johannes Picker     creation of file
%=========================================================================%
% Usage:
%   tsne_calc_v2(tsne_matrix, perplexity, distance, max_iter)
%Inputs:
%   tsne_matrix
%   perplexity
%   distance
%   max_iter
%Outputs:
%   tsne_result
%Globals:
%   none
%=========================================================================%
% Notes: https://de.mathworks.com/help/stats/t-sne-output-function.html

function tsne_result = tsne_calc_v2(tsne_matrix, perplexity, distance, max_iter)

    arguments
        tsne_matrix
        perplexity (1,:) double = 30
        distance (1,1) string = 'euclidean'
        max_iter (1,:) double = 1000
    end
    
    opts = statset('OutputFcn',@outfun,'MaxIter',max_iter);
    
    tsne_result = tsne(tsne_matrix,'Options',opts,...
        'NumPrint', 50, 'Perplexity',perplexity, 'Distance',distance, ...
        'Standardize',false);
    
    function [stop, iterations, kllog_data] = outfun(optimValues,state)
        persistent kllog iters
        stop = false; % do not stop by default
            switch state
                case 'init'
                    % Set up plots or open files
                    fprintf("Init \n")
                    kllog = [];
                    iters = [];
                case 'iter'
                    % Draw plots or update variables
                    kllog = [kllog; optimValues.fval,log(norm(optimValues.grad))];
                    iters = [iters; optimValues.iteration];
            
                    formatSpec = 'Iteration: %5d KLD: %5.4f\n';
                    fprintf(formatSpec,optimValues.iteration,optimValues.fval)
            
                case 'done'
                    % Clean up plots or files
                    iterations = iters;
                    kllog_data = kllog;
            end
    end
end
