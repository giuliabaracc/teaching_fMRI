# Your turn to make some pretty brain plots and have a swing at functional MRI analyses :) 
rm(list=ls()) #clear your environment

#install and load packages
install.packages("ggseg")
install.packages("remotes")
remotes::install_github("ggseg/ggsegSchaefer")
install.packages("dplyr")
install.packages("tidyverse")
install.packages("superheat")
library(ggseg)
library(ggsegSchaefer)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(superheat)

###We are going to use data from subject 101309 in Scahefer 200-17 space
df <- read.table("../data/sub-101309_Schaefer20017.txt") #read in your data
atlas <- read.csv("../data/margulies2016_fcgradient01_20017Schaefer.csv")$region #our 200-17 regions important for plotting later

###First step, we need to normalise their time series data
df_z <- scale(df, center = TRUE, scale = TRUE) 
df_z <- as.data.frame(df_z) #make data frame
  
#Plot df_z
# Add a Time column so we can create a nice labelled plot
df_z$Time <- 1:nrow(df_z)

#Reshape data frame to long format
df_z_long <- pivot_longer(df_z, 
                          cols = -Time, 
                          names_to = "Region", 
                          values_to = "Signal")
#Plot
ggplot(df_z_long, aes(x = Time, y = Signal, color = Region)) +
  geom_line(alpha = 0.6) +
  theme_minimal() +
  labs(title = "ROI Time Series", x = "Time (TRs)", y = "fMRI BOLD Signal") +
  theme(legend.position = "none")

###Second step, we are going to calculate their FC matrix
matrix_df <- as.matrix(df) #convert to matrix format to do calculations

# Pearson's correlation
cor_mat <- cor(matrix_df) #compute FC on matrix format variable

#Look at distribution of FC values
hist(cor_mat) #add here
  
###Third step, we are going to normalise their FC values
z_mat <- atanh(cor_mat) #add here
# Clean matrix: replace Inf values that come from Fisher z-transform
z_mat[!is.finite(z_mat)] <- NA

###Fourth step, we are going to roughly visualise their FC matrix
reds <- colorRampPalette(c("#fee5d9", "#fcae91", "#fb6a4a", "#de2d26", "#a50f15"))(100)
superheat(z_mat,
          scale = FALSE,
          heat.pal = reds,
          # make the legend bigger
          legend.height = 0.25,
          legend.width = 2,
          legend.text.size = 10)

###Fifth step, we are going to calculate nodal strength
node_strength <- rowSums(z_mat, na.rm = TRUE)

node_strength <- as.data.frame(node_strength)
rownames(node_strength) <- seq(1:200)

node_strength[,2] <- atlas

colnames(node_strength)[1] <- "Value"
colnames(node_strength)[2] <- "region"

#Visualize
node_strength %>%
  ggplot() +
  geom_brain(atlas = schaefer17_200,
             position = position_brain(hemi ~ side),
             mapping = aes(fill=Value, geometry=geometry)) +
  scale_fill_viridis_c(limits = c(50, 90), oob = scales::squish)

###Sixth step, we are going to relate their nodal strength measures to measures of brain organisation and gene organisation
brain_organisation <- read.csv("../data/margulies2016_fcgradient01_20017Schaefer.csv")
gene_organisation <- read.csv("../data/gene_pc1_20017Schaefer.csv")

#visualise them both following node_strength plot above
brain_organisation %>%
  ggplot() +
  geom_brain(atlas = schaefer17_200,
             position = position_brain(hemi ~ side),
             mapping = aes(fill=Value, geometry=geometry)) +
  scale_fill_viridis_c(limits = c(-6, 6), oob = scales::squish)

gene_organisation %>%
  ggplot() +
  geom_brain(atlas = schaefer17_200,
             position = position_brain(hemi ~ side),
             mapping = aes(fill=Value, geometry=geometry)) +
  scale_fill_viridis_c(limits = c(-100, 100), oob = scales::squish)

#Compute correlation amongst these vectors: nodal strength, brain organisation and gene organisation
corr_node_brainorg <- cor(node_strength$Value,brain_organisation$Value, method = 'spearman') 
corr_node_geneorg <- cor(node_strength$Value,gene_organisation$Value, method = 'spearman')

