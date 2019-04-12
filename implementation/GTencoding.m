clear all; close all;
%% Path definition
% For windows version
%load('C:\GPFA\data_and_scripts\spikes_movies\data_monkey1_natural_movie.mat')
% For linx version
% Get the path and load every files.
addpath(genpath("./"));

%% Data loading
load("./data_and_scripts/spikes_movies/data_monkey1_natural_movie.mat");

%% Root results
root_results = "./reshaped_spikes/";
filename_result = "monkey1_natural_movie_reshaped.mat";
file_path_res = strcat(root_results, filename_result);

%% Spike extraction
snr = 1.75;
spikecountbinsize = 0.05;
spacebetweenbins = 0;

field1 = 'trialId'; field2 = 'spikes';
value1 = {}; value2 = {};
theseevents =  data.EVENTS((data.SNR>snr),:);
% Loop on  the different events
for i = 1:size(theseevents,1)
    spiketimes = rot90(theseevents(i,:),3);
    spikes = computeSpontCounts(spiketimes, spikecountbinsize, ...
        spacebetweenbins);
    spikes(find(spikes>1))=1;
    value1{i}=i;
    value2{i}=spikes;
end

dat = struct(field1, value1, field2, value2);

save(file_path_res,'dat')



