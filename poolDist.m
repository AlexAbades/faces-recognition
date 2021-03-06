function [T] = poolDist(X, m, n)
%POOLDIST Pools different gaussian distributions into one.
%   Possible values for m, second argument:
%   mean--> Avarages the time responses for each photo, not considering the
%   fotos where we have 0 values. (DEFAULT)
%   mean2--> Avarages the time responses for each photo, considering the
%   fotos where we have 0 values. Always sum(t)/N
%   conf--> Avarages the time responses for each photo, with the conf
%   function.
%   Possible values for n, third argument:
%   norm--> Uses the normalized times of each subject. (DEFAULT)
%   logNorm --> Uses the logarithmic times of each sbject.


% Set some default values 
if nargin == 0
    error('Please intoriduce your normalized data');
elseif nargin < 2
    n = 'norm';
    m = 'mean';
elseif nargin < 3
    n ='norm';
end

% Get your current directori 
cdir = fileparts(mfilename('fullpath'));

% Specify where are the images on your directory 
im_folder = fullfile(cdir, '/Stimulus/stimuli');

% Get all the files from that dir
files = dir(im_folder);
% Store files names in a list 
f = {files.name}';
% Discard the file names that we don't wont
f_ext = f(3:end, :);
% Create a table with those files extensions
T = table(f_ext);


id = unique(X(:,1));
z = length(id.id);


if strcmp(n, 'logNorm')
    % Create a table with the normalized logarithmic time.
    X_temp = X(:, {'id', 'file_ext', 'logNorm'});
    for i = 1:z
        J = X_temp(X_temp.id == id{i,:},{'file_ext', 'logNorm'});
        a = sprintf('User %d', i);
        J.Properties.VariableNames = {'f_ext', a};
        T = outerjoin(T, J, 'Type', 'Left', 'MergeKeys', 1);
    end
    disp('Table with logarithmic times normalized has been created');
    
    
    % Create a table with the normalized times.
elseif strcmp(n, 'norm')
    X_temp = X(:, {'id', 'file_ext', 'norm'});
    for i = 1:z
        J = X_temp(X_temp.id == id{i,:},{'file_ext', 'norm'});
        a = sprintf('User %d', i);
        J.Properties.VariableNames = {'f_ext', a};
        T = outerjoin(T, J, 'Type', 'Left', 'MergeKeys', 1);
    end
    disp('Table with times normalized has been created');
else 
    error('Please select between: norm, logNomr');
end



% Create a new column with the means of the time responses. The mean is
% calculated with the data that we have. If some value is missing due a
% classification, error, the total number will be N-1

if strcmp(m, 'mean')
    T = fillmissing(T, 'constant', 0, 'DataVariables', @isnumeric);
    T.sum = sum(T{:,2:end},2);
    T.count = sum(T{:,2:end-1}~=0,2);
    T.mean = T.sum./T.count;
    T(:,{'sum', 'count'}) = [];
elseif strcmp(m, 'mean2')
    T = fillmissing(T, 'constant', 0, 'DataVariables', @isnumeric);
    % It calculates the mean dividing with the total number of instances
    T.sum = sum(T{:,2:end},2);
    T.count = sum(T{:,2:end-1}== 0|T{:,2:end-1}~= 0 ,2);
    T.mean = T.sum./T.count;
    T(:,{'sum', 'count'}) = [];
elseif strcmp(m,'conf')
    T1 = T.f_ext;
    T(:,{'f_ext'}) = [];
    T = T{:,:};
    T = fillmissing(T, 'linear');
    T = array2table(T)
    T = [T1 T];
    T.prod = prod(T{:,2:end},2);
    a = sum(T.prod);
    T.mean = T.prod/a;
    T(:,{'prod'}) = [];
else
    error('Please select between: mean, mean2 & conf')
end
    

    




end



