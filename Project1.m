clc; clear all;
%% Read and basic manipulation

% Read the file.txt

% Remember to add to path the Stimulus folder.
X = readtable('cleaned_data.txt');

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

[X, Xdel] = initialThreshold(X);

%% Data normalization
% Outliers have been filtered.

% Normalize data. Apply log to the time and normalize it.
[T, summary] = featureNorm(X);
figure()
histogram(T.norm)

% Check global skewness
X1 = skewness(T(T.id == 3,:).time)
X2 = skewness(T(T.id == 12331,:).time)
X3 = skewness(T(T.id == 12345,:).time)
X4 = skewness(T(T.id == 212174,:).time)
X4 = skewness(T(T.id == 48144163,:).time)

%General skewness
X = skewness(T.time)

% Subplots of different distributions
figure()
subplot(1,2,1)
plotTime(T,'joinTime');
subplot(1,2,2)
plotTime(T,'joinLog');
sgtitle('Comparision of time response');

subplot(2,2,3)
plotTime(T, 'joinNorm');
subplot(2,2,4)
plotTime(T,'joinNLog');

%% Fitt skeweed gaussian distribution
mu = 0;
sd = 1;
x = sort(T(T.id == 3,:).logNorm);
y1 = 1/(2*pi*sd)*exp(-(x1-mu).^2/(2*sd^2));
gaussian = @(x) (1/sqrt((2*pi))*exp(-x.^2/2));
skewedgaussian = @(x,alpha) 2*gaussian(x).*normcdf(alpha*x);

figure()
histogram(x,'Normalization','probability');
hold on
plot(x, skewedgaussian(x, -0.5));
hold off;

% Asure The normal distribution for different users. 
figure()
plot(x1, y1,'r')
hold on;
x2 = sort(T(T.id == 12331,:).logNorm);
y2 = 1/(2*pi*sd)*exp(-(x2-mu).^2/(2*sd^2));
plot(x2, y2,'b')
hold on;

x3 = sort(T(T.id == 12345,:).logNorm);
y3 = 1/(2*pi*sd)*exp(-(x3-mu).^2/(2*sd^2));
plot(x3, y3,'g')

x4 = sort(T(T.id == 212174,:).logNorm);
y4 = 1/(2*pi*sd)*exp(-(x4-mu).^2/(2*sd^2));
plot(x4, y4,'y')

x5 = sort(T(T.id == 212174,:).logNorm);
y5 = 1/(2*pi*sd)*exp(-(x5-mu).^2/(2*sd^2));
plot(x5, y5,'c')


%% Pool histograms

I = poolDist(T, 'mean', 'norm');
I2 = poolDist(T, 'mean2', 'norm');
I3 = poolDist(T, 'mean', 'logNorm');
I4 = poolDist(T, 'mean2', 'logNorm');
figure()
% A = histogram(I.mean, 50);
subplot(2,2,1)
histfit(I.mean, 50);
title('Pooled histograms time using mean technic')

subplot(2,2,3)
histfit(I3.mean, 50);
title('Pooled histograms time unsing mean2 technic')

subplot(2,2,2)
histfit(I3.mean, 50);
title('Pooled histograms log time, mean technic')

subplot(2,2,4)
histfit(I4.mean, 50);
title('Pooled histograms log time, mean2 technic')

%saveas(gcf,('sindex-normtime-mean2Method.png'));
%imwrite(histogram(I.mean, 50), 'sindex-normtime-meanMethod');

%% Compare different sIndex
A1 = sIndex(I);
A2 = sIndex(I2);
A3 = sIndex(I3);
A4 = sIndex(I4);

c =  [64,224,208]/255;

figure()
subplot(2,2,1)
histogram(A1.sindex, 15, 'FaceColor', c)
title('sIndex time using mean techinic')

ylabel('Numer of photos')

subplot(2,2,3)
histogram(A2.sindex, 15, 'FaceColor', c)
title('sIndex time unsing mean2 technic')
xlabel('Strength Index')
ylabel('Numer of photos')

subplot(2,2,2)
histogram(A3.sindex, 15, 'FaceColor', c)
title('sIndex log time, mean techinc')


subplot(2,2,4)
histogram(A4.sindex, 15, 'FaceColor', c)
title('sIndex log time, mean2 techinc')
xlabel('Strength Index')
sgtitle('Comparision os strength indexes');








            
            