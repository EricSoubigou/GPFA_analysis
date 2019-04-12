clear
load('C:\GPFA\data_and_scripts\spikes_movies\data_monkey1_natural_movie.mat')
snr = 1.75;
spikecountbinsize = 0.05;
spacebetweenbins = 0;
field1 = 'trialId';
field2 = 'spikes';
value1 = {};
value2 = {};
theseevents =  data.EVENTS((data.SNR>snr),:);
for i =1:size(theseevents,1)
    spiketimes = rot90(theseevents(i,:),3);
    spikes = computeSpontCounts(spiketimes,spikecountbinsize,spacebetweenbins);
    spikes(find(spikes>1))=1;
    value1{i}=i;
    value2{i}=spikes;
end

dat=struct(field1,value1,field2,value2);

save ('test.mat','dat')



