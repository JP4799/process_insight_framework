%status_logging.m
%creation of logging table
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
%   logging_table
%Globals:
%   none
%=========================================================================%
% Notes:

function logging_table = status_logging
    varTypes = ["string", "double", "string","string"];
    varNames = ["Status", "Elapsed Time","Info","Path"];
    row_names = {'Files Loaded';'t-SNE Matrix';'t-SNE Calculation';'Backtransformation';'Imported Data'};
    sz = [length(row_names) length(varNames)];
    logging_table = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
    logging_table.Properties.RowNames = row_names;
end
% Indexing to retrieve the row with the name "step 1"
%%
% logging("Step 1",:) = table("finished", "5", "dir");

%fig = uifigure("Position",[500 500 760 360]);
%uit = uitable(fig,"Data",logging,...
%"Position",[20 20 720 320]);
% logging_table = logging(logging_table, "Files Loaded","test", "20", "test");
%logging_table("t-SNE Matrix",["Status", "Elapsed Time", "Path"]) = table(...
%                              "test"  , "10"          , "test");

%disp(logging_table)
%
%function logging_table = logging(tbl,row, status, elapsed_time, path)
%    tbl(row,:) = table(string(status), double(elapsed_time), string(path));
%    logging_table = tbl;
%end
%%
