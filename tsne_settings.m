%tsne_settings.m
%Ask user what tsne settings should be applied
%
%(c) Johannes Picker
%=========================================================================%
% Version history
%13.04.2023     Johannes Picker     creation of file
%=========================================================================%
% Usage:
%   [perplexity, distance, max_iter] = tsne_settings()
%Inputs:
%   
%Outputs:
%   perplexity
%   distance
%   max_iter
%Globals:
%   none
%=========================================================================%
% Notes:

function [perplexity, distance, max_iter] = tsne_settings()
    
    prompt = {'Enter Perplexity:',...
              'Enter Distance Argorithm:',...
              'Enter Max- Iteration Number'};
    dlgtitle = 't-SNE Settings';
    
    dims = [1 50];
    definput = {'30','euclidean','1000'};
    
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    
    perplexity = str2num(answer{1}); %#ok<ST2NM> 
    distance = answer{2};
    max_iter = str2num(answer{3}); %#ok<ST2NM> 

end