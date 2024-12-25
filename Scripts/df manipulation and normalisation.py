import os
import numpy as np
import pandas as pd

def open_file(location):
    file = open(os.path.expanduser(location), "r")
    return pd.read_csv(file, sep=",")

metadata_base = open_file("~/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/Scripts/Final analysis/XX50235metadata")
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

UK_counter = 0
for value in metadata_base["Country"]:
    if value == "N":
        UK_counter += 1

UK_counter_region = 0
for value in metadata_base["Region"]:
    if value == "UK":
        UK_counter_region += 1

print(UK_counter)
print((UK_counter / len(metadata_base["Country"])) * 100)
print((UK_counter_region / len(metadata_base["Region"])) * 100)
print(np.shape(metadata_base))
unique_pt = (metadata_base["PT"].unique().tolist())
unique_stx = (metadata_base["Stx"].unique()).tolist()
stx_dict = {' stx2a': 0, ' stx2c stx1a': 0, ' stx2a stx2c stx1a' : 0, ' stx2a stx2c': 0, ' stx2c': 0,
            ' stx2a stx1a': 0, ' -': 0, ' stx1a' : 0, ' stx1a stx2c' : 0, ' stx1a stx2a stx2c' : 0,
            ' stx1a stx2a' : 0, ' stx1a stx1c stx2c' : 0, ' stx1a stx2c stx2d' : 0, "N/A" : 0
            }

for toxin in metadata_base["Stx"]:
    if toxin in stx_dict:
        stx_dict[toxin] += 1

print(unique_stx)
print(stx_dict)
print({value for key, value in stx_dict.items()}, sum(stx_dict.values()))
print(len(metadata_base["Stx"]) - sum(stx_dict.values()))

print(metadata["PT"].unique())
pt_dict = {'PT 32': 0, 'PT 2': 0, 'PT 8': 0, 'PT 21/28': 0, 'PT 34': 0, 'PT 54': 0, 'PT 4' : 0, 'PT 31' : 0, 'PT 14': 0,
 'PT 33' : 0, 'RDNC' : 0, 'PT 1' : 0, 'PT 24' : 0, 'PT 46' : 0, 'PT 51' : 0, 'PT 56' : 0, 'PT 90' : 0, 'PT 70' : 0,
 'PT 87' : 0, 'PT 42' : 0, 'PT 38' : 0, 'PT 74' : 0, 'PT 88' : 0, 'PT 23' : 0, 'PT 91' : 0, 'PT 67' : 0, 'PT 63' : 0,
 'PT 10' : 0, 'PT 43' : 0, 'PT 45' : 0, 'PT 89' : 0}

for pt in metadata["PT"]:
    if pt in pt_dict:
        pt_dict[pt] += 1
print(pt_dict, sum(pt_dict.values()))

