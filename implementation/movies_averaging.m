clear all; close all;
%% Path definition
% For linx version !
% Get the path and load every files.
addpath(genpath("./"));

% Root definition
root = "./data_and_scripts/stimuli_movies/";

% filename_movie = "gratings_movie.mat"; 
% filename_movie = "natural_movie.mat";
filename_movie = "noise_movie.mat";

%% 
root_results = "./data_and_scripts/averaged_stimuli_movies/";
filename_result = strcat("avg_", filename_movie);
file_path_res = strcat(root_results, filename_result);

%% Data loading
movie = load(strcat(root, filename_movie));

%% Check the images
figure();
imagesc(movie.M(:,:,700)); 
colorbar; colormap gray;
hold off;

%% Perform the avergaging
% Following the dimension used by the authors and descrbed in the Methods 
% section
avg_movie = zeros(40, 40, 750); 

% Loop on images
for img = 1:750
    % Loop on rows
    for row = 1:40
        % Loop on col
        for col = 1:40
            % Average section of 8 x 8
            avg_movie(row, col, img) = mean( ...
                movie.M(8 * (row-1) +1 : 8 * row, ...
                    8 * (col-1) +1 : 8 * col, ...
                    img), ... 
                'all');
        end
    end
end

%% Check the averagin process
figure();
imagesc(avg_movie(:,:,700));
colorbar; colormap gray;
hold off;

%% Save averaged movies
res = struct("avg_movie", avg_movie);

save(file_path_res,'res')