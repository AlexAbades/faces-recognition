function [X, stats] = featureNorm(X)
%TIMENORM Normalized the time respone for each person.
%   X is the original results table

% Calculate the mean and the standard deviation for the
% different persons.

% We are going to also calculate the logarithmic scale on the time and
% normalize that, to see if which one fits better the data.


% Create new column with the logarithmic time.
X.logTime = log(X.time);

stats = grpstats(X(:,{'id', 'time', 'logTime'}), 'id', {'mean', 'std'});

X = outerjoin(X, stats, 'Type', 'Left', 'MergeKeys', 1);

% Create a new column with the normalized time
X.norm = (X.time-X.mean_time)./X.std_time;

% Create a new column with the normalized time
X.logNorm = (X.logTime-X.mean_logTime)./X.std_logTime;



X(:,{'GroupCount', 'mean_time', 'std_time', 'mean_logTime', 'std_logTime'}) = [];
stats = grpstats(X(:,{'id', 'norm', 'logNorm'}), 'id', {'mean', 'std'});


end





