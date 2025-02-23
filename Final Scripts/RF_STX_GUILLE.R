# ==== Install Packages ==== # 
install.packages("randomForest")
install.packages("plyr")
install.packages("tidyverse")
install.packages("pheatmap")

# ==== Load Libraries ==== #
library(randomForest)
library(plyr)
library(tidyverse)
library(pheatmap)

# Read kmer data
kmer_table <- read.table("shared-team/kmer_table.txt", sep="\t", header=T, row.names=1, stringsAsFactors=FALSE, comment.char="")

# Read Metadata
metadata <- read.table("shared-team/XX50235metadata", sep=",", header=T, row.names=1, stringsAsFactors=TRUE, comment.char="")

# Check Shape
dim(metadata) # 50k features
dim(kmer_table)

# Tell us what the labels are - classes
str(metadata)

# Counts of each classes for the metadata
summary(metadata)

# Data Preprocessing
# Only make use of features that are important for the model - avoid overfitting
# Which kmers or columns are empty

kmer_nonzero_counts <- apply(kmer_table, 1, function(y) sum(length(which(y > 0))))
hist(kmer_nonzero_counts, breaks=100, col="grey", main="", ylab="Number of kmers", xlab="Number of Non-Zero Values")

# The ones that are in everything - core genes
# Core and accesory genes
# If not many observations - maybe remove 
# Check for base error - sequencing machine have got it wrong
# Get rid of rare kmer features

# Keep the rows which have more than 0 entries - cut off 0.2 - 20%
remove_rare <- function( table , cutoff_pro ) {
  row2keep <- c()
  cutoff <- ceiling( cutoff_pro * ncol(table) )
  for ( i in 1:nrow(table) ) {
    row_nonzero <- length( which( table[ i , ] > 0 ) )
    if ( row_nonzero > cutoff ) {
      row2keep <- c( row2keep , i)
    }
  }
  return( table [ row2keep , , drop=F ])
}

kmer_table_rare_removed <- remove_rare(table=kmer_table, cutoff_pro=0.2) # 20% arbitrary 

# Check shape
dim(kmer_table_rare_removed)

# Normalise features (0-1 scale)
kmer_table_rare_removed_norm <- sweep(kmer_table_rare_removed, 2, colSums(kmer_table_rare_removed) , '/')*100


# Transform the data
# Help make features more comparable 
# Subtracting each sample mean x - SD = Z-score
kmer_table_scaled <- scale(kmer_table_rare_removed_norm, center = TRUE, scale = TRUE)

# Add labels to the matrix from the metadata
# Adding metadata labels Stx
kmer_table_scaled_stx <- data.frame(t(kmer_table_scaled))
kmer_table_scaled_stx$stx <- metadata[rownames(kmer_table_scaled_stx),"Stx"]

# Run RF
# Confusion Matrix
RF_stx_classify <- randomForest( x=kmer_table_scaled_stx[,1:(ncol(kmer_table_scaled_stx)-1)] , y=kmer_table_scaled_stx[ , ncol(kmer_table_scaled_stx)] , ntree=501, importance=TRUE, proximities=TRUE )
RF_stx_classify

# Plot heatmap for confusion matrix

saveRDS( file = "shared-team/GCC_RF_stx_model.rda" , RF_stx_classify )