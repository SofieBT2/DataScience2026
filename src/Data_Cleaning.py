# Data Cleaning

from datasets import load_dataset

ds = load_dataset("openfoodfacts/product-database")

ds.head()