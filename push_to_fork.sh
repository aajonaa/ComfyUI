#!/bin/bash

# Rename original remote to upstream if it hasn't been done yet
if ! git remote | grep -q "upstream"; then
    echo "Renaming origin to upstream..."
    git remote rename origin upstream
fi

# Add the new origin pointing to your fork
if ! git remote | grep -q "origin"; then
    echo "Adding new origin remote..."
    git remote add origin https://github.com/aajonaa/ComfyUI.git
else
    echo "Updating origin remote..."
    git remote set-url origin https://github.com/aajonaa/ComfyUI.git
fi

# Verify remotes
echo "Current remotes:"
git remote -v

# Stage all changes (including the new scripts)
echo "Staging changes..."
git add setup_wsl.sh run_wsl.sh download_model.py list_hf_files.py push_to_fork.sh

# Commit changes
echo "Committing changes..."
git commit -m "Add WSL setup scripts and model downloader with China mirrors"

# Push to the new origin
echo "Pushing to GitHub..."
git push -u origin master

echo "Done! Your fork is now updated."

