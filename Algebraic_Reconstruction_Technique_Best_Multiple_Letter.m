matlab
clear; clc; close;

% Prompt the user to enter a letter
Letter = inputdlg('Enter a letter (E, A, or I):', 'Letter Input', [1 50]);
if isempty(Letter)
    error('You did not enter a letter. Exiting.');
end
Letter = upper(Letter{1}); % Convert to uppercase

% Create an 8x8 zero matrix
matrix = zeros(8);

% Create the matrix based on the letter
switch Letter
    case 'E'
        matrix(2:7, 2) = randi([100, 255], 6, 1); % Left vertical line
        matrix(2, 3:5) = randi([100, 255], 1, 3); % Top horizontal line
        matrix(4, 3:4) = randi([100, 255], 1, 2); % Middle horizontal line
        matrix(7, 3:5) = randi([100, 255], 1, 3); % Bottom horizontal line
    case 'A'
        matrix(2:7, 2) = randi([100, 255], 6, 1); % Left vertical line
        matrix(2:7, 6) = randi([100, 255], 6, 1); % Right vertical line
        matrix(2, 2:6) = randi([100, 255], 1, 5); % Top horizontal line
        matrix(4, 2:6) = randi([100, 255], 1, 5); % Middle horizontal line
    case 'I'
        matrix(2:7, 4) = randi([100, 255], 6, 1); % Vertical line
        matrix(2, 3:5) = randi([100, 255], 1, 3); % Top horizontal line
        matrix(7, 3:5) = randi([100, 255], 1, 3); % Bottom horizontal line
    otherwise
        error('Unsupported letter! Only E, A, and I are supported.');
end

figure('Position', [100, 100, 800, 800]); % Increase figure size
imshow(matrix,[0 255], 'InitialMagnification', 10000); % Use 1000 to enlarge pixels
colormap gray; % Display in grayscale
axis on; % Show axes
axis image; % Preserve image dimensions
title('Letter Matrix');

% Calculate row and column sums
rowSums = sum(matrix, 2); % Row sums
colSums = sum(matrix, 1); % Column sums

% Calculate diagonal sums
mainDiagSum = sum(diag(matrix)); % Main diagonal (top-left to bottom-right)
antiDiagSum = sum(diag(flipud(matrix))); % Anti-diagonal (top-right to bottom-left)

% Initialize result matrix for ART
% Instead of a zero matrix, we use an initial matrix considering the averages of rowSums, colSums, and diagonal sums.
result_matrix = mean([rowSums(:); colSums(:)]) * ones(8);

% ART iterations
max_iter = 100; % Maximum number of iterations
for iter = 1:max_iter
    % 1. Vertical (Column) Update
    for j = 1:8
        for i = 1:8
            result_matrix_colSums = sum(result_matrix, 1);
            col_update = (colSums(j) - result_matrix_colSums(j)) / 8;
            result_matrix(i, j) = result_matrix(i, j) + col_update;
        end
    end

    % Clamp negative values to zero
    result_matrix(result_matrix < 0) = 0;

    % 2. Horizontal (Row) Update
    for i = 1:8
        for j = 1:8
            result_matrix_rowSums = sum(result_matrix, 2);
            row_update = (rowSums(i) - result_matrix_rowSums(i)) / 8;
            result_matrix(i, j) = result_matrix(i, j) + row_update;
        end
    end

    % Clamp negative values to zero
    result_matrix(result_matrix < 0) = 0;

    % 3. Diagonal Updates
    for i = 1:8
        for j = 1:8
            if i == j
                result_matrix_mainDiagSum = sum(diag(result_matrix));
                diag_update = (mainDiagSum - result_matrix_mainDiagSum) / 8; % Diagonal updates may have lower priority than others.
                result_matrix(i, j) = result_matrix(i, j) + diag_update;
            elseif i + j == 9
                result_matrix_antiDiagSum = sum(diag(flipud(result_matrix)));
                anti_diag_update = (antiDiagSum - result_matrix_antiDiagSum) / 8; % Diagonal updates may have lower priority than others.
                result_matrix(i, j) = result_matrix(i, j) + anti_diag_update;
            end
        end
    end

    % Clamp negative values to zero
    result_matrix(result_matrix < 0) = 0;
end

% Display the matrix
disp([Letter, ' Matrix:']);
disp(matrix);

% Display the result matrix
disp('original Output of ART algorithm:');
disp(result_matrix);

result_matrix_normalized = mat2gray(result_matrix);  % Normalize to range 0-1
result_matrix_normalized = uint8(result_matrix_normalized * 255);  % Convert to range 0-255
result_matrix_normalized(result_matrix_normalized < 30) = 0;  % Set values below 40 to 0
%result_matrix_normalized(result_matrix_normalized > 80 & result_matrix_normalized < 170) = 170;  % Set values above 70 to 255
%result_matrix_normalized(result_matrix_normalized > 170 & result_matrix_normalized < 200) = 200;  % Set values above 70 to 255
%result_matrix_normalized(result_matrix_normalized > 201) = 255;  % Set values above 70 to 255

% Display the normalized result matrix
figure('Position', [100, 100, 800, 800]); % Increase figure size
imshow(result_matrix_normalized,[0 255], 'InitialMagnification', 10000); % Use 1000 to enlarge pixels
colormap gray; % Display in grayscale
axis on; % Show axes
axis image; % Preserve image dimensions
title('Orjinal Output of ART algorithm - Grayscale Image');

% Display the normalized result matrix
disp('Normalized Result Matrix:');
disp(result_matrix_normalized);

% Sharpening with Laplacian Filter
h_laplacian = fspecial('laplacian', 0.9);  % Laplacian filter, alpha value 0.5: Higher alpha emphasizes sharper edges.
laplacian_image = imfilter(result_matrix_normalized, h_laplacian, 'same');  % Apply Laplacian filter
sharpened_image_laplacian = result_matrix_normalized - laplacian_image;  % Subtract Laplacian from the original image

% Display the sharpened image
figure('Position', [100, 100, 800, 800]); % Increase figure size
imshow(sharpened_image_laplacian, 'InitialMagnification', 10000); % Use 1000 to enlarge pixels
colormap gray; % Display in grayscale
axis on; % Show axes
axis image; % Preserve image dimensions
title('Sharpened Image by Laplacian filter - Unsharp Mask');

% Display the Laplacian-filtered matrix
disp('Laplacian Filtered Matrix:');
disp(sharpened_image_laplacian);

% Contrast Enhancement with Gamma Correction
gamma_value = 0.5;  % Gamma value
result_matrix_gamma = double(result_matrix_normalized) .^ gamma_value;  % Apply gamma correction
result_matrix_gamma = mat2gray(result_matrix_gamma);  % Normalize to range 0-1
result_matrix_gamma = uint8(result_matrix_gamma * 255);  % Convert to range 0-255

% Display the gamma-corrected image
figure('Position', [100, 100, 800, 800]); % Increase figure size
imshow(result_matrix_gamma, 'InitialMagnification', 10000); % Use 1000 to enlarge pixels
colormap gray; % Display in grayscale
axis on; % Show axes
axis image; % Preserve image dimensions
title(['Gamma Correction (Gamma = ', num2str(gamma_value), ')']);

% Display the gamma-corrected matrix
disp('Gamma-Corrected Matrix:');
disp(result_matrix_gamma);

% Contrast Enhancement with Histogram Equalization
result_matrix_eq = histeq(result_matrix_normalized);  % Apply histogram equalization

% Display the histogram-equalized image
figure('Position', [100, 100, 800, 800]); % Increase figure size
imshow(result_matrix_eq, 'InitialMagnification', 10000); % Use 1000 to enlarge pixels
colormap gray; % Display in grayscale
axis on; % Show axes
axis image; % Preserve image dimensions
title('Histogram Equalized Image');

% Display the histogram-equalized matrix
disp('Histogram Equalized Matrix:');
disp(result_matrix_eq);


% Calculate the difference between the original matrix and the output of the ART algorithm
% This comparison evaluates how well the ART algorithm reconstructs the original image
art_rmse = sqrt(mean((double(matrix(:)) - double(result_matrix(:))).^2));
disp(['Root Mean Square Error (RMSE) between original and ART output: ', num2str(art_rmse)]);

% Calculate the difference between the original matrix and Laplacian sharpened matrix
% Convert both matrices to double for accurate computation
laplacian_rmse = sqrt(mean((double(matrix(:)) - double(sharpened_image_laplacian(:))).^2));
disp(['Root Mean Square Error (RMSE) between original and Laplacian sharpened image: ', num2str(laplacian_rmse)]);

% Calculate the difference between the original matrix and the Gamma corrected matrix
% Again, convert matrices to double to avoid type mismatch errors
gamma_rmse = sqrt(mean((double(matrix(:)) - double(result_matrix_gamma(:))).^2));
disp(['Root Mean Square Error (RMSE) between original and Gamma corrected image: ', num2str(gamma_rmse)]);

% Calculate the difference between the original matrix and the Histogram equalized matrix
% Double conversion ensures compatibility and accurate computations
hist_eq_rmse = sqrt(mean((double(matrix(:)) - double(result_matrix_eq(:))).^2));
disp(['Root Mean Square Error (RMSE) between original and Histogram equalized image: ', num2str(hist_eq_rmse)]);










