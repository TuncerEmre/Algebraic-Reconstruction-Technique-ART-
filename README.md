# Image Reconstruction of Letters Using the Algebraic Reconstruction Technique (ART) and the Impact of Filtering Techniques

This repository contains an implementation of the Algebraic Reconstruction Technique (ART) in MATLAB for reconstructing letters represented as 8×8 matrices, as well as an analysis of different post-processing filters (Laplacian, Gamma Correction, and Histogram Equalization) applied to the reconstruction results.

## Contents

1. **Article Title**   
   “Image Reconstruction of Letters Using Algebraic Reconstruction Technique (ART) and the Impact of Filtering Techniques”

2. **Folders and Files**  
   - Article text (PDF or MD, as you prefer)  
   - MATLAB script(s) (e.g., reconstruction.m)  
   - Sample images (optional)  

3. **Brief Overview**  
   - This study explains how to implement the ART algorithm in MATLAB to reconstruct an 8×8 letter matrix from its row, column, and diagonal projections.  
   - Various filtering techniques are applied to the resulting reconstruction to improve image quality.  
   - The performance of each filter is evaluated using the Root Mean Square Error (RMSE) with respect to the original image.

## Setup and Usage

1. **MATLAB Installation**  
   Ensure that MATLAB or a compatible environment is installed. The code uses basic Image Processing Toolbox functions.

2. **Cloning or Downloading the Repository**  
   - Clone this repository:
     ```
     https://github.com/TuncerEmre/Algebraic-Reconstruction-Technique-ART-.git
     ```
   - Or download the .zip file and extract it.

3. **Running the Code**  
   - Open and run the main MATLAB script `reconstruction.m` (or the relevant file) in MATLAB.  
   - Adjust parameters (such as `max_iter`, `gamma_value`, etc.) within the script as needed.  
   - The script performs the following steps:  
     1) Creates the original 8×8 letter matrix.  
     2) Computes sensor values for rows, columns, and diagonals.  
     3) Iterates the ART update rules (columns, rows, diagonals) over a specified number of iterations (default: 100).  
     4) Clamps any negative pixel values to 0 after each update.  
     5) Optionally applies one of the following filters: Laplacian, Gamma Correction, or Histogram Equalization.

4. **Output**  
   - After ART reconstruction, the matrix is normalized (0–255), and pixel intensities below a threshold (e.g., 30) can be set to 0 for noise reduction.  
   - Different filtered images (Laplacian-sharpened, Gamma-corrected, and Histogram-equalized) are generated for comparison.  
   - RMSE values between these images and the original letter matrix are provided to quantify performance.

## Results

- The ART algorithm gradually refines the image by adjusting pixel values so that row, column, and diagonal sums match the measured sensor data.  
- Laplacian filtering typically yields the sharpest edges and, in many cases, provides the best reconstruction quality.  
- Gamma Correction and Histogram Equalization can further enhance contrast but may not always outperform Laplacian filtering in this setup.

## References

1. R. Gordon, R. Bender, and G. T. Herman, “Algebraic Reconstruction Techniques (ART) for three-dimensional electron microscopy and X-ray photography,” *Journal of Theoretical Biology*, vol. 29, no. 3, pp. 471–481, Dec. 1970.  
2. M. A. Badamchizadeh and A. Aghagolzadeh, “Comparative Study of Unsharp Masking Methods for Image Enhancement,” in *Third International Conference on Image and Graphics (ICIG’04)*, 2004.

## Contributing

- Pull requests and suggestions are welcome.  
- You can try adding new filters or testing the algorithm with different matrix sizes and share your analyses.
