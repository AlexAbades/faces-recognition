function  [M] = im2mat(X)
%IM2MAT Gets all the images used on the experiment by looking at the column
%X.file_ext and vectorizes each image into a column vector inside a matrix
%of dimensions:
%   The images can't be in different size. The output matrix (M) size is
%   (x, y) beeing:
%   x = image_columns*row_columns
%   y = number of images.

% Get your current directori 
cdir = fileparts(mfilename('fullpath'));
% Specify where are the images on your directory 
im_folder = fullfile(cdir, '/Stimulus/stimuli');

% Get all the unique files extensions from the data set.
files = unique(X.file_ext);
% substract the length to specify cell matrix dimesions. 
y = length(files);

% Get the dimensions of the image
temp_path = fullfile(im_folder, files{1});
I_temp = imread(temp_path);
[M, N, ~] = size(I_temp);
% Calculate the row dimensions of the matrix
x = M*N;
% Create a matrix on length x, y
M = zeros(x,y);
% Specify the patch dimesions. 
p = [1, 1];
% Loop through all the unique files of our data
for i = 1:y
    % Specify the image path
    im_path = fullfile(im_folder, files{i})
    % read the image
    im = imread(im_path);
    % Transform the rgb image to gray scale
    bim = rgb2gray(im);
    % Initializiate the class with that specific image 
    I = PatchTranf(bim, [1,1]);
    % Vectorize the image
    I_vec = I.vectorize;
    % Add vectorized image 
    M(:,i) = I_vec;
    clear im bim I I_vec

end

    
    