install.packages("ggplot2")
install.packages("tidyverse")
install.packages("readr")

library(tidyverse)
library(ggplot2)
library(readr)

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

plot <- ggplot(metadata, aes(x=PT, y=Stx, fill=Region)) + 
  geom_bar(stat="identity", position=position_dodge()) +
  geom_errorbar(aes(ymin=len-sd, ymax=len+sd), width=.2,
                position=position_dodge(.9))

plot + scale_fill_brewer(palette="Paired") + theme_minimal()