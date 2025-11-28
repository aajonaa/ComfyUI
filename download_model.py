from huggingface_hub import snapshot_download
import os

repo_id = "Tongyi-MAI/Z-Image-Turbo"
# Target directory: models/checkpoints
target_dir = os.path.join("models", "checkpoints")

print(f"Downloading model from {repo_id} to {target_dir}...")

try:
    # Download only .safetensors files
    downloaded_path = snapshot_download(
        repo_id=repo_id,
        allow_patterns=["*.safetensors"],
        local_dir=target_dir,
        local_dir_use_symlinks=False
    )
    print(f"Successfully downloaded to: {downloaded_path}")
except Exception as e:
    print(f"An error occurred: {e}")

