# DataScience2026

## Table of Contents
1. [Project Description](#description)
2. [Project Structure](#structure)
3. [Installation](#installation)
4. [Dependencies](#dependencies)
5. [Data Source](#data)
6. [Usage](#usage)
7. [File and Pipeline Overview](#fileoverview)
8. [References](#references)

## Project Description
This project investigates if the NOVA food processing classification system can be predicted from ingredient composition and nutritional scoring alone, and whether NOVA 4 (ultra-processed foods) is itself internally homogeneous or contains a meaningful subdivision.
Using the Open Food Facts database, the pipeline covers data cleaning, E-number classification (natural, synthetic, ambiguous), TF-IDF ingredient feature engineering, ordinal regression, gradient boosting, NOVA score imputation, and unsupervised clustering with SHAP-based explainability.
The key research outputs are:

A trained LightGBM model predicting NOVA group (1–4) from ingredient and nutritional features.
An imputation of missing NOVA scores across the full dataset.
A data-driven subdivision of NOVA 4 into two subgroups: NOVA 4a (cosmetically processed) and NOVA 4b (industrially reformulated)

All results, trained models, and visualisations are saved to the models/, and plots/ folders.

## Repository Structure
```
DataScience2026/
│
├── models/
│   ├── lgbm_nova.pkl
│   ├── mord_encoders.pkl
│   ├── mord_feature_metadata.json
│   ├── mord_logistic_at.pkl
│   ├── mord_performance.json
│   ├── nova_encoders.pkl
│   ├── nova_feature_metadata.json
│   └── nova_model_performance.json
│
├── plots/
│   ├── LightGBM_confusion_test.png
│   ├── LightGBM_confusion_validation.png
│   ├── agreement_by_nutriscore_grade.png
│   ├── ...
│   └── nutriscore_by_nova_comparison.png
│
├── src/
│   ├── 1_DataCleaning.ipynb
│   ├── 2_Modelling.ipynb
│   ├── 3_Imputation.ipynb
│   └── 4_NOVA4subdivision.ipynb
│
├── .DS_Store
├── .gitignore
├── README.md
├── requirements.txt
└── setup.sh
```

Note: The data/ folder is not tracked in this repository due to file size. Raw and processed data files are hosted on HuggingFace — see Data Source.

## Installation
To get started with this project, follow these steps:

Clone the repository and navigate into it:

   git clone https://github.com/SofieBT2/DataScience2026.git
   cd DataScience2026

Ensure you have Python 3.10+ installed. On macOS, Homebrew is required — setup.sh will install it automatically if it is not already present.
Follow the instructions under Dependencies to set up your HuggingFace token before running the notebooks.
Run ./setup.sh to create a Python virtual environment and install all dependencies from requirements.txt.

If you encounter a permission error, run chmod +x setup.sh and try again.


Activate the environment and launch Jupyter:

```bash
source ./env/bin/activate
jupyter notebook
```

Run the notebooks inside `src/` in the following order for Imputation of NOVA scores to OpenFoodFacts dataset:
   1. 1_DataCleaning.ipynb
   2. 2_Modelling.ipynb
   3. 3_Imputation.ipynb

   Run the following notebook in 'src/' for novel NOVA 4 subdivision examination and imputation:
   1. 4_NOVA4subdivision.ipynb

## Dependencies
A full list of package requirements can be found in `requirements.txt`.

The `setup.sh` script handles the following automatically:
- Installing [Homebrew](https://brew.sh/) (macOS only) and `libomp` (required by LightGBM)
- Creating a Python virtual environment under `env/`
- Installing all packages from `requirements.txt`

## HuggingFace Token (required)
Several notebooks load data directly from HuggingFace. To authenticate:

Create a file named token.txt in the project root and paste in your HuggingFace access token.
This file is listed in .gitignore and should not be pushed to GitHub.

#### Notable packages
| Package | Purpose |
|---|---|
| `lightgbm`, `xgboost` | Gradient boosting models |
| `mord` | Ordinal regression models |
| `shap` | Model explainability |
| `sentence-transformers` | Text embeddings |
| `spacy` | NLP preprocessing |
| `langdetect` | Language detection |
| `transformers` | HuggingFace models |
| `scikit-learn` | ML utilities and metrics |
| `missingno` | Missing data visualisation |
| `seaborn`, `matplotlib` | Plotting |


## Data Source
Data is from the Open Food Facts database via HuggingFace (Open Food Facts, 2026). The project works only with the food split and filters for English language products.
Because the raw and processed datasets are too large, they are not stored directly in the repository. Processed versions are found on HuggingFace and loaded directly in the notebooks:

Raw/filtered data: loaded in 1_DataCleaning.ipynb via load_dataset("openfoodfacts/product-database", split="food")
Cleaned data: MattiWhen/filtered_openfood — loaded in 2_FeatureEngineering_Modelling.ipynb and 3_Imputation.ipynb
Imputed data: MattiWhen/ImputedNovaOpenFoodFacts — loaded in 4_NOVA4_Subdivision.ipynb

To regenerate the data locally from scratch:

Run 1.DataCleaning.ipynb — this downloads the raw dataset and saves cleaned_data.parquet to data/
Run 2.FeatureEngineering_Modelling.ipynb — this produces with_nova.parquet and missing_nova.parquet
Run 3.Imputation.ipynb — this produces with_imputed_nova.parquet

If you are using the HuggingFace-hosted versions, ensure your token.txt is in place before running any notebook.

#### Overview of data files
raw_data.parquet: 
Columns of interest extracted from the full Open Food Facts food split

cleaned_data.parquet: 
English-only, deduplicated, ingredient-validated subset with nutriscore grade

with_nova.parquet: 
Products that have an existing NOVA group label, with engineered features

missing_nova.parquet: 
Products without a NOVA group label, with engineered features

with_imputed_nova.parquet: 
Full dataset with NOVA imputed via model ensemble for missing entries

train.csv: 
Stratified 70% training split (from with_nova)

## Usage
Activate the virtual environmental, then open and run the notebooks in `src/` in the order they are numbered, or for specific parts read the Installation section in this README. Each notebook saves its outputs to `plots/` automatically.

Make sure the virtual environment is active before launching Jupyter:
```bash
source ./env/bin/activate
jupyter notebook
```
Make sure token.txt is loaded into the repository before running any notebook that loads from HuggingFace.


## File and Pipeline Overview

### DataCleaning

**1_DataCleaning.ipynb**

Loads the Open Food Facts data from HuggingFace and creates a clean, English only subset for modelling. Visualises data through various plots.

_Input:_
openfoodfacts/product-database (HuggingFace, food split)

_Key steps:_
- Subset to columns of interest: product_name, brands, nova_group, nutriscore_score, nutriscore_grade, lang, languages_tags, ingredients_original_tags, code
- Filter for English-language products (languages_tags and lang)
- Deduplicate on barcode (code), keeping the row with fewest missing values
- Remove rows where nutriscore_grade is missing, unknown, or not-applicable
- Parse and validate ingredients_original_tags: retain en: prefixed tags, keep E-numbers, remove numeric/non-Latin tags, filter non-English ingredient lists via langdetect
- Visualise distributions: NOVA group, Nutri-Score by NOVA, Nutri-Score grade vs NOVA heatmap, missing data pattern

_Output:_
data/raw_data.parquet
data/cleaned_data.parquet
plots/nova_group_distribution.png
plots/nutriscore_by_nova.png
plots/nutrigrade_vs_nova.png
plots/nova_nutriscore_heatmap.png
plots/missing_data_pattern.png

---

### Feature Engineering and Modelling

**2_FeatureEngineering_Modelling.ipynb**

Engineers additive and text features, then trains on an ordinal logistic regression model (MORD) and a LightGVM model to predict NOVA 1-4.

_Input:_
data/cleaned_data.parquet

_Key steps:_
- E-number classification: each E-number in the ingredient list is classified as NATURAL_E, SYNTHETIC_E, or AMBIGUOUS_E based on EU/FSA classifications, and counted per functional category (colourings, preservatives, emulsifiers, antioxidants, sweeteners, etc.)
- Text features: TF-IDF vectorisation (max_features=500, min_df=50) on cleaned ingredient strings, fitted on the training split only
- Feature matrix: sparse concatenation of ordinal-encoded Nutri-Score grade, additive count columns, ingredient count, and TF-IDF weights
- Stratified split: 70% train / 10% validation / 20% test, stratified by NOVA group
- Baseline — Ordinal Logistic Regression (mord.LogisticAT): evaluated on validation and test sets using accuracy and Quadratic Weighted Kappa (QWK)
- Main model — LightGBM (regression objective): continuous NOVA predictions rounded and clipped to 1–4; evaluated by accuracy and QWK
- Confusion matrices, error distance distributions, and predicted probability plots for both models

_Output:_
data/with_nova.parquet
data/missing_nova.parquet
data/train.csv
models/mord_logistic_at.pkl
models/mord_encoders.pkl
models/mord_feature_metadata.json
models/mord_performance.json
models/lgbm_nova.pkl
models/nova_encoders.pkl
models/nova_feature_metadata.json
models/nova_model_performance.json
plots/Mord_confusion_Validation.png
plots/Mord_confusion_Test.png
plots/Mord_error_distance_Validation.png
plots/Mord_error_distance_Test.png
plots/LightGBM_confusion_Validation.png
plots/LightGBM_confusion_Test.png

---

### NOVA Imputation

**3_Imputation.ipynb**

Uses the trained MORD and LightGBM models to impute missing NOVA scores and examine imputations before settling on using the imputed NOVA from the LightGBM.

_Input:_
data/missing_nova.parquet
models/mord_logistic_at.pkl
models/mord_encoders.pkl
models/mord_feature_metadata.json
models/lgbm_nova.pkl

_Key steps:_
- Rebuilds the sparse feature matrix for the missing-NOVA subset using saved encoders and vectoriser
- Generates predictions from both models independently
- Compares distributions, agreement rates, and Nutri-Score profiles across models
- Selects LightGBM predictions as the final imputed NOVA group (MORD as validation reference)
- Merges imputed rows with the labelled data to form the complete dataset

_Outputs:_
data/with_imputed_nova.parquet
plots/nova_distribution_comparison.png
plots/nova_model_confusion.png
plots/nutriscore_by_nova_comparison.png
plots/agreement_by_nutriscore_grade.png

---

### NOVA 4 Subdivision

**4_NOVA4_Subdivision.ipynb**

Investigates whether the NOVA 4 category is internally homogenous by clustering products on additive composition then training a binary classifier and running SHAP to interpret the division.

_Input:_
MattiWhen/ImputedNovaOpenFoodFacts (HuggingFace, requires token.txt)

_Key steps:_
- Subset to NOVA 4 products; explore additive feature distributions and correlations
- Scale features (StandardScaler) and determine optimal k via elbow method and silhouette scores
- Fit K-Means (k=2); label clusters as NOVA 4a (cosmetically processed) and NOVA 4b (industrially reformulated)
- Validate clusters against Nutri-Score grade as an independent external signal
- Train a LightGBM binary classifier on the cluster pseudo-labels (70/10/20 split); evaluate with AUC-ROC and F1
- SHAP beeswarm and bar plots to explain which additive features drive the 4a/4b distinction
- Client communication figure: additive count and Nutri-Score grade distribution across NOVA 1–4 and the new 4a/4b split

_Outputs:_
plots/nova4_k_selection.png
plots/nova4_cluster_profile.png
plots/nova4_feature_distributions.png
plots/nova4_lgbm_confusion_validation.png
plots/nova4_lgbm_confusion_test.png
plots/nova4_shap_beeswarm.png
plots/nova4_shap_bar.png
plots/nova4_client_communication.png


## References
- Monteiro, C. A., et al. (2019). Ultra-processed foods: What they are and how to identify them. Public Health Nutrition, 22(5), 936–941.
- Open Food Facts contributors. (2024). Open Food Facts database. https://world.openfoodfacts.org/
- Open Food Facts HuggingFace dataset. https://huggingface.co/datasets/openfoodfacts/product-database
- MattiWhen. (2025). Filtered Open Food Facts dataset. https://huggingface.co/MattiWhen/filtered_openfood
- MattiWhen. (2025). Imputed NOVA Open Food Facts dataset. https://huggingface.co/MattiWhen/ImputedNovaOpenFoodFacts
- Explore E Numbers. https://www.exploreenumbers.co.uk/
- Ke, G., et al. (2017). LightGBM: A highly efficient gradient boosting decision tree. Advances in Neural Information Processing Systems, 30.
- Lundberg, S. M., & Lee, S.-I. (2017). A unified approach to interpreting model predictions (SHAP). Advances in Neural Information Processing Systems, 30. https://shap.readthedocs.io/
- Agresti, A. (2010). Analysis of Ordinal Categorical Data (2nd ed.). Wiley. — theoretical basis for mord.LogisticAT
- Pedregosa, F., et al. (2011). Scikit-learn: Machine learning in Python. Journal of Machine Learning Research, 12, 2825–2830. https://scikit-learn.org/
- Hunter, J. D. (2007). Matplotlib: A 2D graphics environment. Computing in Science & Engineering, 9(3), 90–95. https://matplotlib.org/
- Waskom, M. (2021). Seaborn: Statistical data visualization. Journal of Open Source Software, 6(60), 3021. https://seaborn.pydata.org/
- McKinney, W. (2010). Data structures for statistical computing in Python. Proceedings of the 9th Python in Science Conference, 445, 51–56. https://pandas.pydata.org/
- Harris, C. R., et al. (2020). Array programming with NumPy. Nature, 585, 357–362. https://numpy.org/
- Álvarez-Esteban, R., et al. (n.d.). mord: Ordinal regression in Python. https://github.com/fabianp/mord
- spaCy Models — en_core_web_sm. https://spacy.io/models/en#en_core_web_sm
- Naous, R. (2023). langdetect: Python port of Google's language-detection library. https://github.com/Mimino666/langdetect
