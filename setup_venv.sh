#!/usr/bin/bash
# Script to setup python virtual environment
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

python3.8 -m venv $SCRIPT_DIR/venv
source $SCRIPT_DIR/venv/bin/activate
pip install -r $SCRIPT_DIR/requirements.txt