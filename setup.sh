#!/usr/bin/env bash
set -e 

# create virtual env
python -m venv env

# activate env
source ./env/bin/activate

# install requirements
pip install --upgrade pip
pip install -r requirements.txt
python -m spacy download en_core_web_sm

pip install pandas==2.2.0

python -c "import pandas; print(pandas.__version__)"

# close the environment
deactivate