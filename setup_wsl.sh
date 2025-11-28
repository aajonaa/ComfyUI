#!/bin/bash

echo "Setting up ComfyUI for WSL (China Optimized)..."

# Remove existing venv if it exists
if [ -d "venv" ]; then
    echo "Removing existing venv..."
    rm -rf venv
fi

# Create new venv
echo "Creating Python virtual environment..."
python3 -m venv venv

# Activate venv
source venv/bin/activate

# Configure pip to use Tsinghua mirror
echo "Configuring pip to use Tsinghua mirror..."
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# Upgrade pip
pip install --upgrade pip

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt

# Download model using HF Mirror
echo "Downloading model using hf-mirror.com..."
export HF_ENDPOINT=https://hf-mirror.com
python download_model.py

echo "Setup complete!"
echo "To start ComfyUI, run: bash run_wsl.sh"
