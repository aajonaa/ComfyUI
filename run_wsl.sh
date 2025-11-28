#!/bin/bash
source venv/bin/activate
export HF_ENDPOINT=https://hf-mirror.com
echo "Starting ComfyUI..."
python main.py
