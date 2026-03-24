#!/usr/bin/env bash

# create virtual env
python -m venv env

# activate env
source ./env/bin/activate

# install requirements
pip install --upgrade pip
pip install datasets --upgrade
pip uninstall pandas -y
pip install --no-cache-dir pandas==2.2.0
pip install -r requirements.txt
python -m spacy download en_core_web_sm

python -c "import pandas; print(pandas.__version__)"

# close the environment
deactivate