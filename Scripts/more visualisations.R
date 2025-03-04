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

# Update "N" in Country to "UK"
country_counters <- country_counters %>%
  mutate(Country = ifelse(Country == "N", "UK", Country))

# Function to group categories with counts below a threshold into 'Other'
group_small_samples <- function(data, category_col, count_col, threshold = 30) {
  data %>%
    mutate(!!sym(category_col) := ifelse(!!sym(count_col) < threshold, "Other", !!sym(category_col))) %>%
    group_by(!!sym(category_col)) %>%
    summarize(!!sym(count_col) := sum(!!sym(count_col), na.rm = TRUE)) %>%
    ungroup()
}

# Function to reorder factor levels with 'Other' at the end and sort by count
reorder_with_other_last <- function(data, category_col, count_col) {
  data <- data %>%
    arrange(desc(!!sym(count_col))) %>%
    mutate(!!sym(category_col) := factor(!!sym(category_col), levels = c(setdiff(unique(!!sym(category_col)), "Other"), "Other")))
  return(data)
}

# Apply transformations
region_counters <- region_counters %>%
  group_small_samples("Region", "Region_Count") %>%
  reorder_with_other_last("Region", "Region_Count")

country_counters <- country_counters %>%
  mutate(Country = ifelse(Country == "N", "UK", Country)) %>%
  group_small_samples("Country", "Country_Count") %>%
  reorder_with_other_last("Country", "Country_Count")

stx_counters <- stx_counters %>%
  group_small_samples("Stx", "Stx_Count") %>%
  reorder_with_other_last("Stx", "Stx_Count")

pt_counters <- pt_counters %>%
  group_small_samples("PT", "PT_Count") %>%
  reorder_with_other_last("PT", "PT_Count")

# ======== Custom Theme ======== #
custom_theme <- theme_minimal(base_size = 14) + 
  theme(
    plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
    axis.text.y = element_text(size = 12),
    axis.title = element_text(size = 14),
    legend.position = "none",
    panel.grid.major = element_line(color = "grey90"),
    panel.grid.minor = element_blank()
  )

# ======== Create Bar Charts ======== #
# Region Bar-chart
p1 <- ggplot(region_counters, aes(x = Region, y = Region_Count, fill = Region_Count)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Region-wide Sample Distribution", x = "Region", y = "Sample Count") +
  scale_fill_gradient(low = "lightblue", high = "steelblue") +
  custom_theme

# Country Bar-chart
p2 <- ggplot(country_counters, aes(x = Country, y = Country_Count, fill = Country_Count)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Country-wide Sample Distribution", x = "Country", y = "Sample Count") +
  scale_fill_gradient(low = "lightblue", high = "steelblue") +
  custom_theme

# Stx Bar-chart
p3 <- ggplot(stx_counters, aes(x = Stx, y = Stx_Count, fill = Stx_Count)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Stx-wide Sample Distribution", x = "Stx Type", y = "Sample Count") +
  scale_fill_gradient(low = "lightblue", high = "steelblue") +
  custom_theme

# PT Bar-chart  
p4 <- ggplot(pt_counters, aes(x = PT, y = PT_Count, fill = PT_Count)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "PT-wide Sample Distribution", x = "PT Type", y = "Sample Count") +
  scale_fill_gradient(low = "lightblue", high = "steelblue") +
  custom_theme

# ======== Multi-paneled Figure ======== #
multi_paneled_figure <- ggarrange(
  p1, p2, p3, p4,
  labels = c("A", "B", "C", "D"),
  ncol = 2, nrow = 2,
  common.legend = FALSE
)

# Display figure
multi_paneled_figure

# Save figure
ggsave("professional_multi_paneled_figure.png", plot = multi_paneled_figure, width = 12, height = 10, dpi = 300)
