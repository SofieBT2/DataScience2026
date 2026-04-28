#!/usr/bin/env bash
set -e 

# ── Homebrew ───────────────────────────────────────────────
# Add Homebrew to PATH (Apple Silicon = /opt/homebrew, Intel = /usr/local)
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Re-export after install
    export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
fi

# ── System dependencies ────────────────────────────────────
brew install libomp

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