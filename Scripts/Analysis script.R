###### UPDATE DIRECTORY

install.packages("ggplot2", "readr", "dplyr")

library(ggplot2)
library(readr)
library(dplyr)


setwd("/Users/guillermocomesanacimadevila/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework")
csv_table <- read_csv("/Users/guillermocomesanacimadevila/Desktop/XX50235metadata")
write_csv(csv_table, "/Users/guillermocomesanacimadevila/Desktop/cleaned_table.csv")

# ======= Code ======= #
metadata <- read.csv("/Users/guillermocomesanacimadevila/Desktop/cleaned_table.csv", header = TRUE)
print(dim(metadata)) # Ensure shape == correct

ggplot(metadata, aes(x = PT, y = Stx, colour = Region)) +
  geom_point()

# Plot number of samples per year
# Plot the number of samples per geographical region
# Add the count column 

# Bar charts for total number per region
# Table gathered = eliminated "-" - Stx

counter_table <- read.csv("/Users/guillermocomesanacimadevila/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/FINAL TABLE (COUNTERS).csv", header = TRUE)
bar_chart <- ggplot(counter_table, aes(x=Region, y=Counter, fill=Region)) + 
  geom_bar(stat="identity", position=position_dodge()) +
  scale_fill_brewer(palette="Paired") +
  theme_minimal() +
  labs(title="Regional Counters", x="Region", y="Counter")

print(bar_chart)

# Updated csv
# Numbers do not match 
csv_table <- read.csv("/Users/guillermocomesanacimadevila/Desktop/cleaned_table.csv", header = TRUE)
csv_cleaned <- csv_table %>%
  filter(Stx != "-", PT != "untypable")
write_csv(csv_cleaned, "/Users/guillermocomesanacimadevila/Desktop/table1.csv")
print(dim(csv_cleaned))


# Heatmap PT and Stx gene frequency
# First examine dimensions
total_unique_stx <- length(unique(na.omit(csv_table$Stx)))
total_unique_pt <- length(unique(na.omit(csv_table$PT)))
cat(total_unique_pt)
cat(total_unique_stx) # 13x33 matrix then

heatmap_data <- csv_cleaned %>%
  group_by(Stx, PT) %>%
  summarise(Freq = n()) %>%
  ungroup()

heatmap_plot <- ggplot(heatmap_data, aes(x = Stx, y = PT, fill = Freq)) +
  geom_tile(color = "white") + 
  scale_fill_gradient(low = "white", high = "steelblue") + 
  theme_minimal() + 
  labs(x = "Shiga Toxin", y = "Phage Type", title = "Heatmap with Values") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 

heatmap_plot_with_values <- heatmap_plot +
  geom_text(aes(label = Freq), color = "black", size = 3)

print(heatmap_plot_with_values)
