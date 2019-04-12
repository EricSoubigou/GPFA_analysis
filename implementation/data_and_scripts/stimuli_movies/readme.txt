Contains three movies:
gratings_movie.mat
natural_movie.mat
noise_movie.mat

Each .mat has a (num_pixels x num_pixels x num_images) matrix,
saved in uint8.  


———————
Code to play the movie:

load('gratings_movie.mat');
num_images = size(M,3);
f = figure;
for iimage = 1:num_images
	imagesc(M(:,:,iimage));
	colormap(gray);
	pause(0.04);
end
———————


theta_gratings_movie.mat contains theta:
theta(igrat) contains the angle (in radians)
for the ith grating in the movie.  Each
grating was shown for 300ms, so theta has
100 elements.  Note that two elements of theta
are nan--they correspond to 300ms of a blank
screen (no gratings was presented).



Old naming convention:
gratings_movie.mat --> gratings_movie.mat
nat2_movie_4515_monkeyswimming.mat --> natural_movie.mat
noise_movie_3801.mat --> noise_movie.mat
