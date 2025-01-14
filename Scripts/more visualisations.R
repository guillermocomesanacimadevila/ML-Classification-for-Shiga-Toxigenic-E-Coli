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

# Update "N" in Country to "UK"
country_counters <- country_counters %>%
  mutate(Country = ifelse(Country == "N", "UK", Country))

# Group small samples into "Other"
group_small_samples <- function(data, category_col, count_col) {
  data %>%
    mutate(!!sym(category_col) := ifelse(!!sym(count_col) < 30, "Other", !!sym(category_col))) %>%
    group_by(!!sym(category_col)) %>%
    summarize(!!sym(count_col) := sum(!!sym(count_col))) %>%
    ungroup()
}

reorder_with_other_last <- function(data, category_col, count_col) {
  # Order by count in descending order
  ordered_levels <- data %>%
    arrange(desc(!!sym(count_col))) %>%
    pull(!!sym(category_col))
  
  # Ensure "Other" is the last level
  ordered_levels <- c(setdiff(ordered_levels, "Other"), "Other")
  
  # Update the factor levels
  data %>%
    mutate(!!sym(category_col) := factor(!!sym(category_col), levels = ordered_levels))
}

# Apply transformations to datasets
region_counters <- group_small_samples(region_counters, "Region", "Region_Count") %>%
  reorder_with_other_last("Region", "Region_Count")

country_counters <- group_small_samples(country_counters, "Country", "Country_Count") %>%
  reorder_with_other_last("Country", "Country_Count")

stx_counters <- group_small_samples(stx_counters, "Stx", "Stx_Count") %>%
  reorder_with_other_last("Stx", "Stx_Count")

pt_counters <- group_small_samples(pt_counters, "PT", "PT_Count") %>%
  reorder_with_other_last("PT", "PT_Count")

# ======== Custom Theme ======== #
custom_theme <- theme_minimal(base_size = 12) + 
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"), 
    axis.text.x = element_text(angle = 45, hjust = 1),                
    axis.title = element_text(size = 12),                            
    legend.position = "bottom",                                       
    legend.title = element_text(size = 12),                           
    legend.text = element_text(size = 10)                             
  )

# ======== Create Bar Charts ======== #
# Region Bar-chart
p1 <- ggplot(region_counters, aes(x = Region, y = Region_Count, fill = Region_Count)) +
  geom_bar(stat = "identity", position = position_dodge(), color = "lightblue", fill = "steelblue") +
  labs(title = "Region-wide Sample Distribution", x = "Region", y = "Samples") +
  removeGrid(x = FALSE, y = FALSE) +
  custom_theme

# Country Bar-chart
p2 <- ggplot(country_counters, aes(x = Country, y = Country_Count, fill = Country_Count)) +
  geom_bar(stat = "identity", position = position_dodge(), color = "lightblue", fill = "steelblue") +
  labs(title = "Country-wide Sample Distribution", x = "Country", y = "Samples") +
  removeGrid(x = FALSE, y = FALSE) +
  custom_theme

# Stx Bar-chart
p3 <- ggplot(stx_counters, aes(x = Stx, y = Stx_Count, fill = Stx_Count)) +
  geom_bar(stat = "identity", position = position_dodge(), color = "lightblue", fill = "steelblue") +
  labs(title = "Stx-wide Sample Distribution", x = "Stx", y = "Samples") +
  removeGrid(x = FALSE, y = FALSE) +
  custom_theme

# PT Bar-chart  
p4 <- ggplot(pt_counters, aes(x = PT, y = PT_Count, fill = PT_Count)) +
  geom_bar(stat = "identity", position = position_dodge(), color = "lightblue", fill = "steelblue") +
  labs(title = "PT-wide Sample Distribution", x = "PT", y = "Samples") +
  removeGrid(x = FALSE, y = FALSE) +
  custom_theme

# ======== Multi-paneled Figure ======== #
multi_paneled_figure <- ggarrange(
  p1, p2, p3, p4,
  labels = c("Plot 1", "Plot 2", "Plot 3", "Plot 4"),
  ncol = 2, nrow = 2,
  common.legend = TRUE,
  legend = "bottom"
)

# Display figure
multi_paneled_figure

# Save figure
ggsave("professional_multi_paneled_figure.png", plot = multi_paneled_figure, width = 12, height = 10, dpi = 300)
