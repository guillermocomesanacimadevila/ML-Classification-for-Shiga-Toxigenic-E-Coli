# ======== Call libraries ======== #

import os
import numpy as np
import pandas as pd

# ======== Function accumulator ======== #

def read_file(location):
    with open(os.path.expanduser(location), "r") as file:
        return pd.read_csv(file, sep=",")

def gini_index(values):
    total = sum(values)
    proportions = [val / total for val in values]
    gini = 1 - sum(p ** 2 for p in proportions)
    return gini

def entropy_coef(values):
    p = [val for val in values]
    p_log = -np.log2(p)
    total_entropy = p * p_log
    return total_entropy

# ======== Outputs ======== #
# Gini index
metadata = read_file("~/Desktop/(MSc) BIOINFORMATICS/APPLIED DATA SCIENCE IN BIOLOGY/Coursework/Applied Data Science CW 1 (Script)/Scripts/Final analysis/XX50235metadata")
region_value_dict = metadata['Region'].value_counts().to_dict()
country_value_dict = metadata['Country'].value_counts().to_dict()
stx_value_dict = metadata["Stx"].value_counts().to_dict()
pt_value_dict = metadata["PT"].value_counts().to_dict()

gi_regions = gini_index(region_value_dict.values())
gi_country = gini_index(country_value_dict.values())
gi_stx = gini_index(stx_value_dict.values())
gi_pt = gini_index(pt_value_dict.values())

# print(metadata.head())
print(stx_value_dict) # Correct for this one
# print(region_value_dict, country_value_dict, stx_value_dict, pt_value_dict)
# Entropy (rate of disorder)
# H(x) = Sigma[p(x) . -log2p(x)] - High H(x) = greater randomness

entropy_region = sum(entropy_coef([val / sum(region_value_dict.values()) for val in region_value_dict.values()]))
entropy_country = sum(entropy_coef([val / sum(country_value_dict.values()) for val in country_value_dict.values()]))
entropy_stx = sum(entropy_coef([val / sum(stx_value_dict.values()) for val in stx_value_dict.values()]))
entropy_pt = sum(entropy_coef([val / sum(pt_value_dict.values()) for val in pt_value_dict.values()]))

print(f"Gini index for all required classes: {gi_regions, gi_country, gi_stx, gi_pt}")
print(f"Entropy coefficient per class: {entropy_region, entropy_country, entropy_stx, entropy_pt}")

print(metadata["Stx"].unique())
print((len([val for val in metadata["Region"] if val == "UK"]) / len(metadata["Region"])) * 100)
print((len([val for val in metadata["Country"] if val == "N"]) / len(metadata["Country"])) * 100)
print([sorted((str(key), str(val))) for key, val in pt_value_dict.items()] [::-1])
