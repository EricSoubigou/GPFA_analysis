%% Example script for using spontaneous spiking activity
%     Plots histogram of significant noise correlations
%     Author: Ryan Williamson, Oct. 2016

clear all
%% params (bin parameters chosen to match Smith & Kohn 2008 Fig
spikecountbinsize = 1;
spacebetweenbins = 0;
alpha = 0.05;
snr = 2.75;
datanames = [{'spiketimesmonkey1spont'} {'spiketimesmonkey2spont'} {'spiketimesmonkey3spont'}...
              {'spiketimesmonkey4spont'} {'spiketimesmonkey5spont'} {'spiketimesmonkey6spont'}];
%% Compute pairwise correlations
rhosig = [];
for n = 1:length(datanames)
% Load data    
    load(['./spikes_spontaneous/',datanames{n}]);
    theseevents =  data.EVENTS(data.SNR>snr);
    
% Compute Spike Counts
    counts = computeSpontCounts(theseevents,spikecountbinsize,spacebetweenbins);
    counts = counts(mean(counts,2)>2*spikecountbinsize,:);
% Compute pairwise correlations
    [rho, pval] = corr(counts');
    lowind = tril(ones(size(rho)),-1);
    rholow = rho(lowind==1);
    pvallow = pval(lowind==1);

 % Keep significant pvals
    rhosig = [rhosig; rholow(pvallow< alpha)];
end

%% histogram of significant pairwise correlations
figure
[a, b] = hist(rhosig, 10);
bar(b,a);
xlabel('Correlation Coefficient')
ylabel('Number of Pairs')
