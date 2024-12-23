import os
import csv
import numpy as np
import pandas as pd

def open_file(location):
    file = open(os.path.expanduser(location), "r")
    return pd.read_csv(file, sep=",")

metadata = open_file("~/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/Scripts/Final analysis/Filtered_metadata.csv")
region_frequency = open_file("~/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/Scripts/Final analysis/region_year_counter.csv")
region_year = open_file("~/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/Scripts/Final analysis/pre_norm_reg.csv")

print(region_year.head())
print(f"Unique regions from baseline metadata: {metadata["Region"].unique()}")
print(f"Unique regions from secondary metadata: {region_year["Region"].unique()}")

# Normalised count = count pre reg, per year / toal count for that region
# Then back to SQL

def calculate_normalized_values(df):
    required_columns = {'Region', 'Year', 'Region_Count'}
    if not required_columns.issubset(df.columns):
        raise ValueError(f"Input DataFrame must contain columns: {required_columns}")
    if not pd.api.types.is_numeric_dtype(df['Region_Count']):
        print("'Region_Count' column is not numeric. Attempting to convert...")
        df['Region_Count'] = pd.to_numeric(df['Region_Count'], errors='coerce')
    if df['Region_Count'].isnull().any():
        raise ValueError("The 'Region_Count' column contains non-numeric values that could not be converted.")
    total_counts = df.groupby('Region')['Region_Count'].transform('sum')
    df['Normalized_Count'] = df['Region_Count'] / total_counts
    return df

output_path = "~/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/Scripts/Final analysis/normalised_df.csv"
normalised_df = calculate_normalized_values(region_year)
normalised_df.to_csv(os.path.expanduser(output_path), index=False)

missing_records = region_year.groupby('Region')['Year'].nunique()
regions_missing_years = missing_records[missing_records < 6].index.tolist()
non_missing_regions = missing_records[missing_records > 5].index.tolist()

print(missing_records)
print(non_missing_regions)
print(regions_missing_years)