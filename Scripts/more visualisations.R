# ======== Load libraries ======== #
install.packages("ggExtra")
install.packages("remotes")
remotes::install_github("kassambara/ggpubr")

library(ggplot2)
library(ggExtra)
library(readr)
library(dplyr)
library(tidyr)
library(remotes)
library(ggpubr)


setwd("/Users/guillermocomesanacimadevila/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/Scripts/Counter_tables")

metadata_cleaned <- read.csv("cleaned_table_final.csv", header = TRUE)
region_counters <- read.csv("cleaned_region.csv", header = TRUE)
country_counters <- read.csv("cleaned_country.csv", header = TRUE)
stx_counters <- read.csv("cleaned _stx.csv", header = TRUE)
pt_counters <- read.csv("cleaned_pt.csv", header = TRUE)

dim(metadata_cleaned)
dim(region_counters)
dim(country_counters)
dim(stx_counters)
dim(pt_counters)

custom_theme <- theme_minimal(base_size = 12) + 
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"), 
    axis.text.x = element_text(angle = 45, hjust = 1),                
    axis.title = element_text(size = 12),                            
    legend.position = "bottom",                                       
    legend.title = element_text(size = 12),                           
    legend.text = element_text(size = 10)                             
  )

# Region Bar-chart
p1 <- ggplot(region_counters, aes(x = reorder(Region, desc(Region_Count)), y = Region_Count, fill = Region_Count)) +
  geom_bar(stat = "identity", position = position_dodge(), color = "lightblue", fill = "steelblue") +
  labs(title = "Region-wide Sample Distribution", x = "Region", y = "Samples") +
  removeGrid(x = FALSE, y = FALSE)
custom_theme

# Country bar chart
p2 <- ggplot(country_counters, aes(x = reorder(Country, desc(Country_Count)), y = Country_Count, fill = Country_Count)) +
  geom_bar(stat = "identity", position = position_dodge(), color = "lightblue", fill = "steelblue") +
  labs(title = "Region-wide Sample Distribution", x = "Region", y = "Samples") +
  removeGrid(x = FALSE, y = FALSE)
custom_theme

# Stx bar chart
p3 <- ggplot(stx_counters, aes(x = reorder(Stx, desc(Stx_Count)), y = Stx_Count, fill = Stx_Count)) +
  geom_bar(stat = "identity", position = position_dodge(), color = "lightblue", fill = "steelblue") +
  labs(title = "Region-wide Sample Distribution", x = "Region", y = "Samples") +
  removeGrid(x = FALSE, y = FALSE)
custom_theme

# PT Bar chart  
p4 <- ggplot(pt_counters, aes(x = reorder(PT, desc(PT_Count)), y = PT_Count, fill = PT_Count)) +
  geom_bar(stat = "identity", position = position_dodge(), color = "lightblue", fill = "steelblue") +
  labs(title = "Region-wide Sample Distribution", x = "Region", y = "Samples") +
  removeGrid(x = FALSE, y = FALSE)
custom_theme

# ===== Multi-panneled figuremn ===== #
multi_paneled_figure <- ggarrange(
  p1, p2, p3, p4,
  labels = c("plot1", "plot2", "plot3", "plot4"),
  ncol = 2, nrow = 2,
  common.legend = TRUE,
  legend = "bottom"
)

ggsave("professional_multi_paneled_figure.png", plot = multi_paneled_figure, width = 12, height = 10, dpi = 300)
