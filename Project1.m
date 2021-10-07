clc; clear all;
%% Read and basic manipulation

% Read the file.txt

% Remember to add to path the Stimulus folder.
X = readtable('results_All.txt');

%{
R-Happy: 140
R-Sad: 140
R-Neutral: 48
%}


%% Set labels to our data
X = setLabels(X);

%% Get the names from the discarted images and trhow them away from the main table
[X, Im] = discImages(X);

%% Vectorize the images 
P = X(1:20, :);
M = im2mat(P);

%% Delete the images above and below a specific threshold

figure()
plotTime(X, 'joinTime')
title('Normal times') 

[X, Xdel] = initialThreshold(X);



%% Data normalization
% Outliers have been filtered.

figure()
subplot(2,2,1)
plotTime(X, 'joinTime')
title('Normal times') 

% Check if it's better to apply the log to all the data or to the data with
% non-outliers.
% Compute the log of time in a new column
X.log = log(X.time);

% Compare histograms. Apply h
subplot(2,2,2)
plotTime(X, 'joinLog')
title('Logarithm of times without normalization')

% Normalize normal data 
[T, summary] = featureNorm(X);


X_temp = T([1:5, 370:374], :);

%{
s = accumarray(ci, X.time, [], @std);
ci = [0 0 0 0 0 1 1 1 1 1];
c = accarray(ci, X_temp.time, [], X_temp.norm > 0.8);
%}
% Plot normalized time
subplot(2,2,3:4)
plotTime(T, 'joinNorm')
title('Normalized time')
sgtitle('max = 2.5 seconds')






%%

[T, summary] = featureNorm(X);

% Check the 10 first rows
T(1:10,:)
% check the sumary
summary

%% Create Real categories
T = realCateg(T);
% check the first 10 rowz
T(end-10:end,:)

%% Plot some data
% Look ot histograms are not really histograms, we should specify that
% folowws normalization and probability as below. Not sure, in the
% normalization data we already have it normalized 
plotTime(T, 'time');
plotTime(T, 'norm');
plotTime(T, 'join');

% Plot probability density function (pdf) for skewed gaussian distribution
figure()
x = summary(1,:).id;
y = T(T.id == summary(1,:).id,:).time;
pd = fitdist(y,'Norm');
x_values = 0:0.01:7;
p = pdf(pd,x_values);
plot(x_values,p)
hold on 
histogram(T(T.id == summary(1,:).id,:).time, 'Normalization','probability')
% Not exactly the same. 

% Useful links
% https://stats.stackexchange.com/questions/435114/generating-skew-normal-distribution-in-matlab
% https://se.mathworks.com/help/stats/pearsrnd.html
% https://se.mathworks.com/help/stats/fitdist.html#btu538h-distname

% It could be easier if we have the pdf of each histogram to make a better
% mapping

%{
As we can see in the plots, the distribution tends to follow a Gaussian
normal distribution skewwes to the lefs, that¡s why we can normalize it in
the norm distribution Z = x-mu(k)/sigma(k) beeing k subindex the person id.

As each one tends to have sligthly different values of mu and sigma, and we
want a continuous strength indicator, we can map the probability densifty
functions, in that case the histograms, into a range from 0 to 1 with the
equation: 'maping equation.PNG'. so we'll have a strength indicator, from
now on Si, Si(k). for each person. Once we have Si for each one we'll
calculate the mean  sum(Si(1) to Si(k))/k.
Look out, we'll need one for the Happy and one different to Sad. Our truly
range goes from [-1,1] but as the time respone will be in the same
conficdece interval and some in a while in the same value, we need to
separate them within the two categories. 
%}
I = imread('maping equation.PNG');
figure()
imshow(I)

%% Tasks 
%{
- Try to identify the missclassifications. In each experiment we will have
missclasifications, meaning that the person doing the actual experiment
wanted to classy the image as a happy image but he/she actually hit the
wrong key. 
% With the time response.

- Identify weird pre-clasifications. If we pre-classified a Neutral image
as Sad or Happy and none of the people that have done the experiment has
actually classified that especific image as the pre-classified category it
should be better to: change the category or either throw it to the bin.

- Get rid from the images that have been discharged. When we filtered our
data, either on the normalization (because it was out of range) or in some
of the missclassification errors. The problem is that we have only a few
experiments, say 5, so if one of the images has been thown away only once
when we calculate the Si mean the value will be reduced a lot. In addition,
if a image has been discharged because of the reponse time, there is a high
probability that some of the other people has also took to many time to
categorize it, so when doing the Si mean the value will be more reduced.

- Create a function that maps the data into a Si depending on the actual
category following the maping equation. So if by chance we find a better
way to do it it's easier to change.

-PCA. 
Patch transfer is a class to vectorize an image, only have to specify the
patch dimension, in this case i think is 1x1, it should also work with that

- Verify all images have the same size (it shouldn't be a problem for the
class) 
%}
            
            