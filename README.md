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
This project explores classification and implementation of a novel subdivision within the Nova 4 group of ultra-processed foods, as well as imputation of NOVA labels for the Open Food Facts database. The pipeline covers data preprocessing, feature engineering, model training and tuning, imputation, K-means clustering and visualisation of results.

Models explored include gradient boosting approaches (LightGBM) and ordinal regression (mord), with model explanations via SHAP.

All results and visualisations are saved to the `output/` and `plots/` folders.

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
├── output/
│   ├── missing_data_pattern.png
│   ├── nova_group_distribution.png
│   ├── nova_nutriscore_heatmap.png
│   └── nutriscore_by_nova.png
│
├── plots/
│   └── [generated figures and visualisations]
│
├── src/
│   ├── [TODO: Notebook 1 name].ipynb
│   ├── [TODO: Notebook 2 name].ipynb
│   └── ...
│
├── .gitignore
├── README.md
├── requirements.txt
└── setup.sh
```

## Installation
To get started with this project, follow these steps:

1. Clone the repository and navigate into it:
   ```bash
   git clone https://github.com/SofieBT2/DataScience2026.git
   cd DataScience2026
   ```
2. Ensure you have Python 3.10+ installed. On macOS, Homebrew is required — `setup.sh` will install it automatically if it is not already present.
3. If any scripts require an OpenAI API key, follow the instructions under [Dependencies](#dependencies).
4. Run `./setup.sh` to create a Python virtual environment and install all dependencies from `requirements.txt`.
   - If you encounter a permission error, run `chmod +x setup.sh` and try again.
5. Activate the environment and launch Jupyter:
   ```bash
   source ./env/bin/activate
   jupyter notebook
   ```
   Run the notebooks inside `src/` in numerical order.


## Dependencies
A full list of package requirements can be found in `requirements.txt`.

The `setup.sh` script handles the following automatically:
- Installing [Homebrew](https://brew.sh/) (macOS only) and `libomp` (required by LightGBM)
- Creating a Python virtual environment under `env/`
- Installing all packages from `requirements.txt`
- Downloading the spaCy English model: `en_core_web_sm`

#### OpenAI API key (if required)
- Create a file named `api_key.txt` in the project root and paste in your API key. This file is listed in `.gitignore` and should **not** be pushed to GitHub.

#### Notable packages
| Package | Purpose |
|---|---|
| `lightgbm`, `xgboost` | Gradient boosting models |
| `mord` | Ordinal regression models |
| `optuna`, `optuna-integration` | Hyperparameter optimisation |
| `shap` | Model explainability |
| `openai` | LLM API calls |
| `sentence-transformers` | Text embeddings |
| `spacy` | NLP preprocessing |
| `langdetect` | Language detection |
| `transformers` | HuggingFace models |
| `scikit-learn` | ML utilities and metrics |
| `missingno` | Missing data visualisation |
| `seaborn`, `matplotlib` | Plotting |


## Data Source
[**TODO: Describe where the data comes from — e.g. a public dataset, a Kaggle competition, a scraped source, etc.**]

_Steps to obtain the data:_
1. [TODO: Step 1 — e.g. download from X and place in `data/`]
2. [TODO: Step 2]
3. The final folder structure should look like:
   ```
   DataScience2026/
   │
   └── data/
       └── [raw data file name]
   ```


## Usage
Open and run the notebooks in `src/` in the order they are numbered. Each notebook saves its outputs to `output/` and/or `plots/` automatically.

Make sure the virtual environment is active before launching Jupyter:
```bash
source ./env/bin/activate
jupyter notebook
```


## File and Pipeline Overview

### [TODO: Phase 1 name — e.g. Data Preprocessing]

**[TODO: notebook name].ipynb**

_Input:_
[TODO: input file(s)]

_Output:_
[TODO: output file(s)]

---

### [TODO: Phase 2 name — e.g. Feature Engineering]

**[TODO: notebook name].ipynb**

_Input:_
[TODO: input file(s)]

_Output:_
[TODO: output file(s)]

---

### [TODO: Phase 3 name — e.g. Modelling]

**[TODO: notebook name].ipynb**

_Input:_
[TODO: input file(s)]

_Outputs:_
[TODO: model files and result CSVs]

---

### [TODO: Phase 4 name — e.g. Explainability & Visualisation]

**[TODO: notebook name].ipynb**

_Input:_
[TODO: input file(s)]

_Outputs:_
[TODO: plots and summary files]


## References
- Chen, T., & Guestrin, C. (2016). XGBoost: A scalable tree boosting system. https://xgboost.readthedocs.io/
- Ke, G., et al. (2017). LightGBM: A highly efficient gradient boosting decision tree. https://lightgbm.readthedocs.io/
- Akiba, T., et al. (2019). Optuna: A next-generation hyperparameter optimization framework. https://optuna.org/
- Lundberg, S. M., & Lee, S.-I. (2017). A unified approach to interpreting model predictions (SHAP). https://shap.readthedocs.io/
- Reimers, N., & Gurevych, I. (2019). Sentence-BERT: Sentence embeddings using Siamese BERT-networks. https://www.sbert.net/
- Honnibal, M., et al. (2025). spaCy. https://spacy.io/
- OpenAI. (2025). OpenAI Python library. https://github.com/openai/openai-python
- Wolf, T., et al. (2020). Transformers: State-of-the-art natural language processing. https://github.com/huggingface/transformers
- Pedregosa, F., et al. (2011). Scikit-learn: Machine learning in Python. https://scikit-learn.org/
- Hunter, J. D. (2007). Matplotlib. https://matplotlib.org/
- Waskom, M. (2021). Seaborn. https://seaborn.pydata.org/
- McKinney, W. (2010). Pandas. https://pandas.pydata.org/
- Harris, C. R., et al. (2020). NumPy. https://numpy.org/
- Virtanen, P., et al. (2020). SciPy. https://scipy.org/
- spaCy Models — en_core_web_sm. https://spacy.io/models/en#en_core_web_sm
