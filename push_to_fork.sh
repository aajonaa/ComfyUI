#!/bin/bash

# Remove upstream if it exists (since you only want your own version)
if git remote | grep -q "upstream"; then
    echo "Removing upstream remote..."
    git remote remove upstream
fi

# Ensure origin points to your fork
if ! git remote | grep -q "origin"; then
    echo "Adding origin remote..."
    git remote add origin https://github.com/aajonaa/ComfyUI.git
else
    echo "Ensuring origin is correct..."
    git remote set-url origin https://github.com/aajonaa/ComfyUI.git
fi

# Verify remotes
echo "Current remotes:"
git remote -v

# Stage all changes
echo "Staging changes..."
git add setup_wsl.sh run_wsl.sh download_model.py list_hf_files.py push_to_fork.sh

# Commit changes
echo "Committing changes..."
git commit -m "Add WSL setup scripts and model downloader with China mirrors"

# Push to origin
echo "Pushing to GitHub..."
git push -u origin master

echo "Done! Your fork is now updated and upstream is removed."
