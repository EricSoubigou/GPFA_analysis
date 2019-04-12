close all; clear all;

%% Project ECE/BME 6790
% Author : Eric Soubigou
% 
%% Load data

load('mat_sample/sample_dat');
data_movie_spike = ... 
    load('./mat_sample/data_and_scripts/spikes_movies/data_monkey1_natural_movie.mat');
data_movie = ...
    load('./mat_sample/data_and_scripts/stimuli_movies/gratings_movie.mat');

%% Study of the data
events = data_movie_spike.data.EVENTS;
% Register the spike moment of every neurons measure

channels = data_movie_spike.data.CHANNELS;
% Register the units(rows) and the associated channel number (first col)
% and the number of unit in this channel (second col)
map = data_movie_spike.data.MAP;

[nb_col, nb_rows] = size(events);

trial = [];
% Shape data : 
for i = 1:nb_col
    for j = 1:nb_rows
        converted_events = cell2mat(events(i,j)).';
        spikes = zeros(1,50/0.02);
        converted_events = converted_events ./ 0.02;
        for k = 1:length(converted_events)
            spikes(ceil(converted_events(k))) = 1;
        end
        trial = [trial; spikes];
    end
end

%% Project run
% Results will be saved in mat_results/runXXX/, where XXX is runIdx.
% % Use a new runIdx for each dataset.
% runIdx = 1;
% 
% % Select method to extract neural trajectories:
% % 'gpfa' -- Gaussian-process factor analysis
% % 'fa'   -- Smooth and factor analysis
% % 'ppca' -- Smooth and probabilistic principal components analysis
% % 'pca'  -- Smooth and principal components analysis
% method = 'gpfa';
% 
% % Select number of latent dimensions
% xDim = 8;
% % NOTE: The optimal dimensionality should be found using 
% %       cross-validation (Section 2) below.
% 
% % If using a two-stage method ('fa', 'ppca', or 'pca'), select
% % standard deviation (in msec) of Gaussian smoothing kernel.
% kernSD = 30;
% % NOTE: The optimal kernel width should be found using 
% %       cross-validation (Section 2) below.
% 
% % Extract neural trajectories
% result = neuralTraj(runIdx, dat, 'method', method, 'xDim', xDim,... 
%                     'kernSDList', kernSD);
% % NOTE: This function does most of the heavy lifting.
% 
% % Orthonormalize neural trajectories
% [estParams, seqTrain] = postprocess(result, 'kernSD', kernSD);
% % NOTE: The importance of orthnormalization is described on 
% %       pp.621-622 of Yu et al., J Neurophysiol, 2009.
% 
% % Plot neural trajectories in 3D space
% plot3D(seqTrain, 'xorth', 'dimsToPlot', 1:3);
% % NOTES:
% % - This figure shows the time-evolution of neural population
% %   activity on a single-trial basis.  Each trajectory is extracted from
% %   the activity of all units on a single trial.
% % - This particular example is based on multi-electrode recordings
% %   in premotor and motor cortices within a 400 ms period starting 300 ms 
% %   before movement onset.  The extracted trajectories appear to
% %   follow the same general path, but there are clear trial-to-trial
% %   differences that can be related to the physical arm movement. 
% % - Analogous to Figure 8 in Yu et al., J Neurophysiol, 2009.
% % WARNING:
% % - If the optimal dimensionality (as assessed by cross-validation in 
% %   Section 2) is greater than 3, then this plot may mask important 
% %   features of the neural trajectories in the dimensions not plotted.  
% %   This motivates looking at the next plot, which shows all latent 
% %   dimensions.
% 
% % Plot each dimension of neural trajectories versus time
% plotEachDimVsTime(seqTrain, 'xorth', result.binWidth);
% % NOTES:
% % - These are the same neural trajectories as in the previous figure.
% %   The advantage of this figure is that we can see all latent
% %   dimensions (one per panel), not just three selected dimensions.  
% %   As with the previous figure, each trajectory is extracted from the 
% %   population activity on a single trial.  The activity of each unit 
% %   is some linear combination of each of the panels.  The panels are
% %   ordered, starting with the dimension of greatest covariance
% %   (in the case of 'gpfa' and 'fa') or variance (in the case of
% %   'ppca' and 'pca').
% % - From this figure, we can roughly estimate the optimal
% %   dimensionality by counting the number of top dimensions that have
% %   'meaningful' temporal structure.   In this example, the optimal 
% %   dimensionality appears to be about 5.  This can be assessed
% %   quantitatively using cross-validation in Section 2.
% % - Analogous to Figure 7 in Yu et al., J Neurophysiol, 2009.
% 
% fprintf('\n');
% fprintf('Basic extraction and plotting of neural trajectories is complete.\n');
% fprintf('Press any key to start cross-validation...\n');
% fprintf('[Depending on the dataset, this can take many minutes to hours.]\n');
% pause;
