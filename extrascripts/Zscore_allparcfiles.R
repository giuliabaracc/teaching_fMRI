input_dir <- "/Users/gbar0888/Desktop/Teaching/fMRI_Preprocessing_Connectivity_rest/Practice/data/"      
output_dir <- "/Users/gbar0888/Desktop/Teaching/fMRI_Preprocessing_Connectivity_rest/Practice/xtrascripts/" #

file_paths <- list.files(path = input_dir, pattern = "\\.txt$", full.names = TRUE)

zscore_and_save <- function(file_path) {
  # Read file (no headers)
  df <- read.table(file_path, header = FALSE)
  
  # Z-score each column (region)
  z_df <- as.data.frame(scale(df, center = TRUE, scale = TRUE))
  
  # Create new filename
  file_name <- paste0("z_", basename(file_path))
  output_path <- file.path(output_dir, file_name)
  
  # Save without row/column names
  write.table(z_df, file = output_path, row.names = FALSE, col.names = FALSE)
}

# Apply function to each file
lapply(file_paths, zscore_and_save)
