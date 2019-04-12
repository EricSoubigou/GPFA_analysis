function ravel_movie = from_images_2_vectors(movie)
%% Return a set of 1D vectors representing one image of the movie.
    % Perform the permutation of dimension
    movie_perm = permute(movie, [1 3 2]);
    % Perform the reshape of the  vector
    ravel_movie = reshape(movie_perm, 1600, 750);
end