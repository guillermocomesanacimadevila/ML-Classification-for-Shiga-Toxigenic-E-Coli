# ======== Install packages ======== #

install.packages("ggplot2")
install.packages("readr")
install.packages("dyplr")
install.packages("pheatmap")
install.packages("tidyr")
install.packages("reshape2")

library(ggplot2)
library(pheatmap)
library(reshape2)
library(readr)
library(dplyr)
library(tidyr)

metadata <- read.csv("/Users/guillermocomesanacimadevila/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/Scripts/Final analysis/Filtered_metadata.csv", header = TRUE)
counter_region <- read.csv("/Users/guillermocomesanacimadevila/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/Scripts/Final analysis/region_specific.csv", header = TRUE)
pre_normalised_region_year <- read.csv("/Users/guillermocomesanacimadevila/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/Scripts/Final analysis/pre_norm_reg.csv", header = TRUE)
normalised_region_year <- read.csv("/Users/guillermocomesanacimadevila/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/Scripts/Final analysis/normalised_df.csv", header = TRUE)

# What charts will describe the data best
# What do we need to clean
# Display it and perfection them/it
# Sample size needs to equal 30 if not not normal distribution

p1 <- ggplot(normalised_region_year, aes(x = Year, y = Normalized_Count, fill = Region)) +
  geom_bar(stat = "identity") +
  labs(title = "Stacked Bar Chart of Normalised Values", x = "Year", y = "Normalised Values") +
  theme_minimal()

p2 <- ggplot(pre_normalised_region_year, aes(x = Year, y = Region_Count, fill = Region)) +
  geom_bar(stat = "identity") +
  labs(title = "Stacked Bar Chart of Un-Normalised Values", x = "Year", y = "Region Count") +
  theme_minimal()

print(p1)
print(p2)

#####

excluded_regions <- c('Asia', 'Australasia', 'C. America', 'C. Europe', 'N. Africa', 'N. Europe', 'S. America')

filtered_data <- subset(normalised_region_year, !(Region %in% excluded_regions))

ggplot(filtered_data, aes(x = Year, y = Normalized_Count, color = Region)) +
  geom_line(size = 1) +  
  geom_point(size = 2) +
  labs(
    title = "Normalized Count per Region Over Time (Excluding Specific Regions)",
    x = "Year",
    y = "Normalized Count"
  ) +
  theme_minimal() + 
  theme(
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10),
    plot.title = element_text(hjust = 0.5, size = 16)
  )