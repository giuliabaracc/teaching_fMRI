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

setwd("C:/neurodesktop-storage/S6_functional") #set working directory

###We are going to use data from subject 101309 in Scahefer 200-17 space
df <- #--> ADD HERE <-- #read in this file: sub-101309_Schaefer20017.txt (hint you have to use read.table cause it is a txt file)
atlas <- read.csv("../data/margulies2016_fcgradient01_20017Schaefer.csv")$region #our 200-17 regions important for plotting later

######### 
###First step, we need to normalise their time series data
df_z <- #--> ADD HERE <-- normalise df 
df_z <- as.data.frame(df_z) #make data frame

#Just some plotting of df_z
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

######### 
###Second step, we are going to calculate their FC matrix
matrix_df <- as.matrix(df) #convert to matrix format to do calculations

# Pearson's correlation
cor_mat <- #--> ADD HERE <-- #compute FC on matrix_df

#Look at distribution of FC values
#--> ADD HERE <-- look at histogram of cor_mat

######### 
###Third step, we are going to normalise their FC values
z_mat <- #--> ADD HERE <-- get Fisher z transform of cor_mat
# Clean matrix: replace Inf values that come from Fisher z-transform
z_mat[!is.finite(z_mat)] <- NA

######### 
###Fourth step, we are going to roughly visualise their FC matrix
reds <- colorRampPalette(c("#fee5d9", "#fcae91", "#fb6a4a", "#de2d26", "#a50f15"))(100)
superheat(z_mat,
          scale = FALSE,
          heat.pal = reds,
          # make the legend bigger
          legend.height = 0.25,
          legend.width = 2,
          legend.text.size = 10)

######### 
###Fifth step, we are going to calculate nodal strength
node_strength <- #--> ADD HERE <-- compute node strength of z_mat

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

######### 
###Sixth step, we are going to relate their nodal strength measures to measures of brain organisation and gene organisation
brain_organisation <- read.csv("../data/margulies2016_fcgradient01_20017Schaefer.csv") #read in file
gene_organisation <- read.csv("../data/gene_pc1_20017Schaefer.csv") #read in file

#Visualise them both following node_strength plot above
#--> ADD HERE <-- ggplots, 1 plot each <-- note that the limits for brain_organisation are c(-6,6) and for gene c(-100, 100)

#Compute correlation amongst these vectors: nodal strength, brain organisation and gene organisation
corr_node_brainorg <- cor(node_strength$Value,brain_organisation$Value, method = 'spearman') 
#--> ADD HERE <-- now do the same between node strength and gene organisation

######### 
#AMAZING!! Great job :)

