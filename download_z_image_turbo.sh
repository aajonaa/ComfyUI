#!/bin/bash
# Download Z-Image-Turbo model files for ComfyUI
# This script downloads the correct files to the correct locations

# Set HF mirror for China
export HF_ENDPOINT=https://hf-mirror.com

echo "=== Cleaning up old/wrong files ==="

# Remove wrong files from previous downloads
if [ -d "models/checkpoints/text_encoder" ]; then
    echo "Removing models/checkpoints/text_encoder/..."
    rm -rf models/checkpoints/text_encoder
fi

if [ -d "models/checkpoints/transformer" ]; then
    echo "Removing models/checkpoints/transformer/..."
    rm -rf models/checkpoints/transformer
fi

if [ -d "models/checkpoints/vae" ]; then
    echo "Removing models/checkpoints/vae/..."
    rm -rf models/checkpoints/vae
fi

if [ -d "models/diffusers/Z-Image-Turbo" ]; then
    echo "Removing models/diffusers/Z-Image-Turbo/..."
    rm -rf models/diffusers/Z-Image-Turbo
fi

echo "Cleanup complete!"
echo ""

echo "=== Downloading Z-Image-Turbo for ComfyUI ==="

# Activate venv
source venv/bin/activate

# The files are under split_files/ in the repo, need to download and move them

echo ""
echo "[1/3] Downloading Text Encoder (qwen_3_4b.safetensors)..."
python -c "
from huggingface_hub import hf_hub_download
import os
import shutil

os.makedirs('models/text_encoders', exist_ok=True)
path = hf_hub_download(
    repo_id='Comfy-Org/z_image_turbo',
    filename='split_files/text_encoders/qwen_3_4b.safetensors',
    local_dir='temp_download',
    local_dir_use_symlinks=False
)
# Move to correct location
shutil.move('temp_download/split_files/text_encoders/qwen_3_4b.safetensors', 'models/text_encoders/qwen_3_4b.safetensors')
print('Text encoder downloaded!')
"

echo ""
echo "[2/3] Downloading Diffusion Model (z_image_turbo_bf16.safetensors)..."
python -c "
from huggingface_hub import hf_hub_download
import os
import shutil

os.makedirs('models/diffusion_models', exist_ok=True)
path = hf_hub_download(
    repo_id='Comfy-Org/z_image_turbo',
    filename='split_files/diffusion_models/z_image_turbo_bf16.safetensors',
    local_dir='temp_download',
    local_dir_use_symlinks=False
)
# Move to correct location
shutil.move('temp_download/split_files/diffusion_models/z_image_turbo_bf16.safetensors', 'models/diffusion_models/z_image_turbo_bf16.safetensors')
print('Diffusion model downloaded!')
"

echo ""
echo "[3/3] Downloading VAE (ae.safetensors)..."
python -c "
from huggingface_hub import hf_hub_download
import os
import shutil

os.makedirs('models/vae', exist_ok=True)
path = hf_hub_download(
    repo_id='Comfy-Org/z_image_turbo',
    filename='split_files/vae/ae.safetensors',
    local_dir='temp_download',
    local_dir_use_symlinks=False
)
# Move to correct location
shutil.move('temp_download/split_files/vae/ae.safetensors', 'models/vae/ae.safetensors')
print('VAE downloaded!')
"

# Cleanup temp folder
rm -rf temp_download

echo ""
echo "=== All downloads complete! ==="
echo ""
echo "Files downloaded:"
ls -lh models/text_encoders/qwen_3_4b.safetensors 2>/dev/null || echo "  - models/text_encoders/qwen_3_4b.safetensors (MISSING!)"
ls -lh models/diffusion_models/z_image_turbo_bf16.safetensors 2>/dev/null || echo "  - models/diffusion_models/z_image_turbo_bf16.safetensors (MISSING!)"
ls -lh models/vae/ae.safetensors 2>/dev/null || echo "  - models/vae/ae.safetensors (MISSING!)"
echo ""
echo "You can now start ComfyUI with: bash run_wsl.sh"
echo "Then load the Z-Image-Turbo workflow from: https://docs.comfy.org/tutorials/image/z-image/z-image-turbo"
