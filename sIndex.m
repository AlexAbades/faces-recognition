function [M] = sIndex(X,nsigma)
%SIND Creates a continuous strength index from the time responeses.
%   Detailed explanation goes here

if nargin < 2
    nsigma = 3;
end

% Delete unecessary info
X(:,2:end-1) = [];
% Obtain the real categories using the f_ext
X = realCateg(X);
% Split The Data into two tables, Happy and Sad, so we can make our
% strencgth index. 
Hap = X(ismember(X.RealCat, 'R-Happy'),:);
Sad = X(ismember(X.RealCat, 'R-Sad'),:);
% Delete unecesary columns
Hap(:,'RealCat') = [];
Sad(:,'RealCat') = [];

% Calculate sigma and standard deviations: Calculated with the happy and
% sad matrices. It can also be calculated as a hole. From X 
% Mean and std from Happy
% Hap_mu = mean(Hap.mean);
v = ~isnan(Hap.mean);
u = ~isnan(Sad.mean);

Hap_std = std(Hap(v,:).mean);
% Mean and std from Sad
% Sad_mu = mean(Sad.mean);
Sad_std = std(Sad(u,:).mean);


% Change some labels for better understanding.
Hap.Properties.VariableNames = {'f_ext', 'time'};
figure()
subplot(1,2,1)
histfit(Hap.time)
Sad.Properties.VariableNames = {'f_ext', 'time'};
subplot(1,2,2)
histfit(Sad.time)
% Create a new column on each table class for the strngth indicator
Hap.sindex = zeros(length(Hap.time),1);
Sad.sindex = zeros(length(Sad.time),1);

% Create the stength indicator for happy photos
for i = 1:length(Hap.time)
    if Hap{i,'time'} <  0
        Hap.sindex(i) = 1;
    elseif (Hap{i,'time'} < nsigma*Hap_std) && (Hap{i,'time'} > 0)
        Hap.sindex(i) = 1 - (Hap{i,'time'}/(nsigma*Hap_std));
    elseif Hap{i,'time'} > nsigma*Hap_std
        Hap.sindex(i) = 0;
    else 
        Hap.sindex(i) = NaN;
    end 
end 

% Create the strength indicator for Sad photos
for i = 1:length(Sad.time)
    if Sad{i,'time'} <  0
        Sad.sindex(i) = -1;
    elseif (Sad{i,'time'} < nsigma*Sad_std) && (Sad{i,'time'} > 0)
            Sad.sindex(i) = -1 + (Sad{i,'time'}/(nsigma*Sad_std));
    elseif Sad{i,'time'} > nsigma*Sad_std
        Sad.sindex(i) = 0;
    else 
        Sad.sindex(i) = NaN;
    end 
end 



% Join both tables
M = [Hap; Sad];
% Drop the time column
M(:,{'time'}) = [];
% Sort rows on sindex values
M = sortrows(M,2);




end

