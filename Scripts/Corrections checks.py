# =========== Call libraries =========== #

import os
import numpy as np
import pandas as pd

# =========== Open file as a pandas data frame =========== #

def format_file(location):
    with open(os.path.expanduser(location), 'r') as file:
        return pd.read_csv(file, sep=",", header=0)

metadata = format_file("~/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/Updated_dataframe")
print(metadata.head())

if "Stx" in metadata.columns:
    unique_values_stx = metadata["Stx"].unique()
    print("Unique values in 'Stx':", unique_values_stx)
else:
    print("The 'Stx' column is not in the data frame.")

if "PT" in metadata.columns:
    unique_values_pt = metadata["PT"].unique()
    print("Unique values in 'PT':", unique_values_pt)
else:
    print("The 'PT' column is not in the data frame.")

if "Region" in metadata.columns:
    unique_values_region = metadata["Region"].unique()
    print("Unique values in 'Region':", unique_values_region)
else:
    print("The 'Region' column is not in the data frame.")

untypable_counter = 0
for value in metadata["PT"]:
    if value == "untypable":
        untypable_counter += 1
print(untypable_counter)

# ========= Code below ========= #
stx_dictionary_counter = {
    "stx2a": 0,
    "stx2c stx1a": 0,
    "stx2a stx2c stx1a": 0,
    "stx2c": 0,
    "stx1a": 0
}

stx_dictionary_counter2 = {
    "stx2a": 0,
    "stx2c": 0,
    "stx1a": 0,
}

null_counter = 0
for column in metadata.columns:
    for value in metadata["Stx"]:
        if value in stx_dictionary_counter:
            stx_dictionary_counter[value] += 1

for column in metadata.columns:
    for value in metadata["Stx"]:
        if value in stx_dictionary_counter2:
            stx_dictionary_counter2[value] += 1
        else:
            null_counter += 1

print(stx_dictionary_counter)
print(stx_dictionary_counter2)
print(null_counter)
print(sum(stx_dictionary_counter2.values()))
print(np.shape(format_file("~/Desktop/DS in Bio/tableA.csv")))

if "Year" in metadata.columns:
    unique_values_year= metadata["Year"].unique()
    print("Unique values in 'Year':", unique_values_year)
else:
    print("The 'Year' column is not in the data frame.")