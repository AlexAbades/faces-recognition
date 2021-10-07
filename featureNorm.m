function [X_out, output] = featureNorm(X)
%TIMENORM Normalized the time respone for each person.
%   X is the original results table

% Calculate the mean and the standard deviation for the
% different persons.

% We are going to also calculate the logarithmic scale on the time and
% normalize that, to see if which one fits better the data.

% Search for unique id's
[C, ~, ci] = unique(X(:, 'id'));

% Create new column eith the logarithmic time 
X.logTime = log(X.time);
mu_log = accumarray(ci, X.logTime, [], @mean);
% Calculate the normal standard deviation 
s_log = accumarray(ci, X.logTime, [], @std);
% Create a table with the means and standard deviation for each id
output_log = [C num2cell([mu_log s_log])];


% Calculte the normal time mean for each different id.
mu = accumarray(ci, X.time, [], @mean);
% Calculate the normal standard deviation 
s = accumarray(ci, X.time, [], @std);
% Create a table with the means and standard deviation for each id
output_time = [C num2cell([mu s])];

output = [output_log output_time]

% Set the variable names of the table
output.Properties.VariableNames = {'id', 'mean', 'std', 'mean_log', 'std_log'};

% Create a inner join to add for each row the correspondent mu and sigma
% and standard deviation.
X_out = innerjoin(X,output);

% Create a new column with the normalized time
X_out.norm = (X_out.time-X_out.mean);
X_out.norm = X_out.norm./X_out.std;

% Create a new column with the normalized time
X_out.logNorm = (X_out.logTime-X_out.mean_log);
X_out.logNorm = X_out.lognorm./X_out.std;



% Remove variables we no longer need
X_out = removevars(X_out,{'mean' , 'std'});

%


% We can now check if there are some outliers with the standard deviation.
% Depends on which is our confindece interval. s, 2s, or 3s. 
% Rememeber that on our discretization of the data qe'll have to use some
% rule for the discratization.


end





