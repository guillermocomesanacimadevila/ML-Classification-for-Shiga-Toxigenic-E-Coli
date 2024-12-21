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


# Now create a pd df and add 5 new columns ranging from 0-1 depends on stx
# log normalise the ting
metadata_norm = format_file("~/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/Scripts/Final analysis/Filtered_metadata.csv")
stx_types = ["stx1a", "stx2a", "stx2c", "stx2d", "stx1c"]
for stx_type in stx_types:
    metadata_norm[stx_type] = [1 if stx_type in value else 0 for value in metadata_norm["Stx"]]
print(metadata_norm[[col for col in metadata_norm.columns if col.startswith("stx")]].head())
#print(metadata_norm["Stx"].unique())
# log base e normalisation (loge(x)) (np.loge(x))

for stx_type in stx_types:
    metadata_norm[f'{stx_type}_log'] = np.log1p(metadata_norm[stx_type])
print(metadata_norm)

otput_location = "~/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/Scripts/Final analysis/log_normalised.csv"
# Save to new csv
metadata_norm.to_csv(otput_location, index=False)
new_file = format_file(otput_location)
print(new_file[[col for col in new_file.columns if col.startswith("log")]].head())
