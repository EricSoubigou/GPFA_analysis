These data files contain the peri-stimulus time histograms (PSTHs) of the
V1 neurons in response to individual gratings.  Number of neurons and time duration
are exact same as that in Cowley et al., 2016; there may be discrepancies with the
mean firing rates computed with spikes_gratings because Cowley et al., 2016 used
different criteria to select neurons. 

load('psths_monkey1_gratings.mat')
% returns paths{istim} (num_neurons x num_timepoints)

Old file naming conventions:
 103r002p01.mat --> psths_monkey1_gratings.mat
 101r001p01.mat --> psths_monkey2_gratings.mat
 102l001p01.mat --> psths_monkey3_gratings.mat
