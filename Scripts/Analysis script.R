###### UPDATE DIRECTORY

install.packages("ggplot2")
install.packages("readr")

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
  filter(Stx != "-", PT != "untypable", PT != "#N/A")
write_csv(csv_cleaned, "/Users/guillermocomesanacimadevila/Desktop/table1.csv")
print(dim(csv_cleaned))


# Heatmap PT and Stx gene frequency
# First examine dimensions
total_unique_stx <- length(unique(na.omit(csv_table$Stx)))
total_unique_pt <- length(unique(na.omit(csv_table$PT)))
cat(total_unique_pt)
cat(total_unique_stx) # 13x33 matrix then

heatmap_data <- csv_cleaned1 %>%
  group_by(Stx, PT) %>%
  summarise(Freq = n(), .groups = "drop")

# Create the heatmap plot
heatmap_plot <- ggplot(heatmap_data, aes(x = PT, y = Stx, fill = Freq)) +
  geom_tile(color = "grey90") + 
  scale_fill_gradient(
    low = "#D4EBF2", high = "#08306B", 
    name = "Frequency" 
  ) +
  geom_text(aes(label = Freq), color = "black", size = 3, fontface = "bold") + 
  labs(
    x = "Phage Type (PT)", 
    y = "Shiga Toxin (Stx)", 
    title = "Frequency Heatmap of PT vs Stx",
    caption = "Data Source: Cleaned Table | Visualization by G" 
  ) +
  theme_minimal(base_size = 14) + 
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16), 
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10), 
    axis.text.y = element_text(size = 10), 
    legend.position = "right", 
    legend.title = element_text(size = 12, face = "bold"), 
    legend.text = element_text(size = 10) 
  )

print(heatmap_plot)
print(dim(heatmap_data))

# Second heatmap
csv_table1 <- read.csv("/Users/guillermocomesanacimadevila/Desktop/DS in Bio/tableA.csv", header = TRUE)
csv_cleaned1 <- csv_table1 %>%
  filter(Stx != "-", PT != "untypable", PT != "#N/A")
write_csv(csv_cleaned1, "/Users/guillermocomesanacimadevila/Desktop/DS in Bio/tableA_cleaned.csv")

# Count howe many times all stxs are repeated 
stx1a_count <- csv_cleaned1 %>%
  filter(grepl("stx1a", Stx)) %>%
  summarise(count = n())

stx2a_count <- csv_cleaned1 %>%
  filter(grepl("stx2a", Stx)) %>%
  summarise(count = n())

stx2c_count <- csv_cleaned1 %>%
  filter(grepl("stx2c", Stx)) %>%
  summarise(count = n())

stx2d_count <- csv_cleaned1 %>%
  filter(grepl("stx2d", Stx)) %>%
  summarise(count = n())

stx1c_count <- csv_cleaned1 %>%
  filter(grepl("stx1c", Stx)) %>%
  summarise(count = n())

print(stx1a_count)
print(stx1c_count)
print(stx2a_count)
print(stx2c_count)
print(stx2d_count)

stx_table <- data.frame(
  Stx = c("Stx1a", "Stx2a", "Stx2c", "Stx2d", "Stx1c"),
  Values = c(918, 1357, 2070, 1, 1)
)
