rm(list=ls())

# install.packages("ggseg")
# install.packages("remotes")
# remotes::install_github("ggseg/ggsegSchaefer")
library(ggseg)
library(ggsegSchaefer)
library(ggplot2)
library(dplyr)

# Load network file
palette <- read.csv("Palette.csv")  # this file has: Region, Network, Hex_code

# Extract atlas data frame
schaefer_df <- as.data.frame(schaefer7_200)

# Join with palette to add network info
schaefer_annotated <- left_join(schaefer_df, palette, by = c("region" = "Region"))

# Define desired order of networks from the palette
network_order <- unique(palette$Network)  # otherwise it orders everything alphabetically
palette$Network <- factor(palette$Network, levels = network_order)
schaefer_annotated$Network <- factor(schaefer_annotated$Network, levels = network_order)

# Create named color vector from Network names and their hex codes
network_colors <- setNames(palette$Hex_code, palette$Network)

# Plot by network
ggplot() +
  geom_brain(atlas = schaefer_annotated,
             mapping = aes(fill = Network, geometry = geometry),
             position = position_brain(hemi ~ side)) +
  scale_fill_manual(values = network_colors,
                    na.translate = FALSE) +
  theme_void() +
  labs(title = "Schaefer 200-7 Parcellation by Network",
       fill = "Network")
