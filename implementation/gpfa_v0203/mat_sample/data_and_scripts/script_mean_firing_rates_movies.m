%  This script contains three parts:
%   1. Convert spike times to 1ms bins.
%   2. Remove bad/very low firing units.
%   3. Compute the trial-averaged population activity (PSTHs).
%
%  S and mean_FRs are used to store the data:
%    S(itrial).spikes  (num_units x num_1ms_timebins)
%    S(itrial).counts  (num_units x num_20ms_timebins)
%    mean_FRs (num_units x num_20ms_timebins)
%   
%  Author: Ben Cowley, bcowley@cs.cmu.edu, Oct. 2016
%
% Notes:
%   - files were spike sorted together
%   - automatically saves 'S' and 'mean_FRs' in ./spikes_movies/

%% parameters

    SNR_threshold = 2.0;
    firing_rate_threshold = 1.0;  % 1.0 spikes/sec
    binWidth = 20;  % in ms


%% parameters relevant to experiment

    length_of_movie = 30;  % each movie was 30 seconds
    
    filenames{1,1} = './spikes_movies/data_monkey1_gratings_movie.mat';
    filenames{1,2} = './spikes_movies/data_monkey1_natural_movie.mat';
    filenames{1,3} = './spikes_movies/data_monkey1_noise_movie.mat';
    filenames{2,1} = './spikes_movies/data_monkey2_gratings_movie.mat';
    filenames{2,2} = './spikes_movies/data_monkey2_natural_movie.mat';
    filenames{2,3} = './spikes_movies/data_monkey2_noise_movie.mat';

    monkeys = {'monkey1', 'monkey2'};
    movies = {'gratings_movie', 'natural_movie', 'noise_movie'};
    
    
%% match channels and units across movies

    for imonkey = 1:length(monkeys)
        channels = [];
        for imovie = 1:length(movies)
            load(filenames{imonkey, imovie});
                % returns data.CHANNELS
                
            channels{imovie} = [data.CHANNELS(:,1) + 1000 * data.CHANNELS(:,2)];
        end
        
        intersect_channels = intersect(channels{1}, channels{2});
        intersect_channels = intersect(intersect_channels, channels{3});
        
        for imovie = 1:length(movies)
            load(filenames{imonkey, imovie});
                % returns data.CHANNELS
                
            channels = [data.CHANNELS(:,1) + 1000 * data.CHANNELS(:,2)];
            keepChannels = ismember(channels, intersect_channels);
            
            data.EVENTS = data.EVENTS(keepChannels,:);
            data.CHANNELS = data.CHANNELS(keepChannels,:);
            data.SNR = data.SNR(keepChannels);
            
            save(filenames{imonkey, imovie}, 'data', '-v7.3');
        end
        
    end
   

%%  spike times --> 1ms bins

    for imonkey = 1:length(monkeys)
        for imovie = 1:length(movies)
            S = [];
            
            fprintf('binning spikes for %s %s\n', monkeys{imonkey}, movies{imovie});
            
            load(filenames{imonkey, imovie});
                % returns data.EVENTS
                
            num_neurons = size(data.EVENTS,1);
            num_trials = size(data.EVENTS,2);
            
            edges = 0:0.001:30;  % take 1ms bins
            
            for itrial = 1:num_trials
                for ineuron = 1:num_neurons
                    S(itrial).spikes(ineuron,:) = histc(data.EVENTS{ineuron, itrial}, edges);
                end
                S(itrial).spikes = S(itrial).spikes(:,1:end-1);  % remove extraneous bin at the end
            end
                
            save(sprintf('./spikes_movies/S_%s_%s.mat', monkeys{imonkey}, movies{imovie}), 'S', '-v7.3');
        end
    end
    




%%  Pre-processing:  Remove bad/very low firing units

    % remove units based on SNR <= SNR_threshold
    
    for imonkey = 1:length(monkeys)
        keepNeurons = [];
        for imovie = 1:length(movies)
            load(filenames{imonkey, imovie});
                % returns data.SNR
            if (isempty(keepNeurons))
                keepNeurons = data.SNR >= SNR_threshold;
            else
                keepNeurons = keepNeurons & data.SNR >= SNR_threshold;  % SNRs are different across movies
            end
        end
        clear data;
        
        for imovie = 1:length(movies)
            S = [];
            
            fprintf('keeping units with SNRs >= %f for %s %s\n', SNR_threshold, monkeys{imonkey}, movies{imovie});

            load(sprintf('./spikes_movies/S_%s_%s.mat', monkeys{imonkey}, movies{imovie}));
                % returns S(itrial).spikes
                
            num_trials = length(S);

            for itrial = 1:num_trials
                S(itrial).spikes = S(itrial).spikes(keepNeurons,:);  
            end
                
            save(sprintf('./spikes_movies/S_%s_%s.mat', monkeys{imonkey}, movies{imovie}), 'S', '-v7.3');
        end
    end
    
    % remove units with mean firing rates < firing rate threshold
    
    for imonkey = 1:length(monkeys)
        mean_FRs_movies = [];
        for imovie = 1:length(movies)
            S = [];
            
            load(sprintf('./spikes_movies/S_%s_%s.mat', monkeys{imonkey}, movies{imovie}));
                % returns S(itrial).spikes
                
            num_trials = length(S);
            mean_FRs = [];
            for itrial = 1:num_trials
                mean_FRs(:,itrial) = sum(S(itrial).spikes,2)/30.0;  % divide by length of movie
            end
            
            mean_FRs_movies = [mean_FRs_movies mean_FRs];
        end
        
        mean_FRs_movies = mean(mean_FRs_movies,2);
        
        keepNeurons = mean_FRs_movies >= firing_rate_threshold;
        
        for imovie = 1:length(movies)
            fprintf('keeping units with mean firing rates >= %d spikes/sec for %s %s\n', firing_rate_threshold, monkeys{imonkey}, movies{imovie});

            load(sprintf('./spikes_movies/S_%s_%s.mat', monkeys{imonkey}, movies{imovie}));
                % returns S(itrial).spikes

            num_trials = length(S);

            for itrial = 1:num_trials
                S(itrial).spikes = S(itrial).spikes(keepNeurons,:);
            end

            save(sprintf('./spikes_movies/S_%s_%s.mat', monkeys{imonkey}, movies{imovie}), 'S', '-v7.3');
        end

    end

    
%%  Take spike counts in 20ms bins
    for imonkey = 1:length(monkeys)
        for imovie = 1:length(movies)
            fprintf('spike counts in 20ms bins for %s %s\n', monkeys{imonkey}, movies{imovie});

            load(sprintf('./spikes_movies/S_%s_%s.mat', monkeys{imonkey}, movies{imovie}));
                % returns S(itrial).spikes
                
            num_trials = length(S);
            for itrial = 1:num_trials
                S(itrial).counts = bin_spikes(S(itrial).spikes, 20);
            end
            
            save(sprintf('./spikes_movies/S_%s_%s.mat', monkeys{imonkey}, movies{imovie}), 'S', '-v7.3');
        end
    end
    
%%  Compute trial-averaged population activity (PSTHs)

    for imonkey = 1:length(monkeys)
        for imovie = 1:length(movies)
            fprintf('computing PSTHs for %s %s\n', monkeys{imonkey}, movies{imovie});

            load(sprintf('./spikes_movies/S_%s_%s.mat', monkeys{imonkey}, movies{imovie}));
                % returns S(itrial).counts
                
            mean_FRs = zeros(size(S(1).counts));
            num_trials = length(S);
            for itrial = 1:num_trials
                mean_FRs = mean_FRs + S(itrial).counts;
            end
            mean_FRs = mean_FRs / num_trials;
            
            save(sprintf('./spikes_movies/mean_FRs_%s_%s.mat', ...
                monkeys{imonkey}, movies{imovie}), 'mean_FRs', '-v7.3');
        end
    end
        

