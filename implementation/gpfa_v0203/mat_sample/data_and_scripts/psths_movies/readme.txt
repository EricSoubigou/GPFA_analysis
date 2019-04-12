These data files contain the peri-stimulus time histograms (PSTHs) of the
V1 neurons in response to individual gratings.  Number of neurons and time duration
are exact same as that in Cowley et al., 2016; there may be discrepancies with the
mean firing rates computed with spikes_movies because Cowley et al., 2016 used
different criteria to select neurons. 

load('psths_monkey1_gratings_movie.mat')
% returns paths (num_neurons x num_timepoints)


Old naming conventions:
monkey1 is m103
monkey2 is m102