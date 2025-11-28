from huggingface_hub import list_repo_files

repo_id = "Tongyi-MAI/Z-Image-Turbo"
try:
    files = list_repo_files(repo_id)
    print(f"Files in {repo_id}:")
    for f in files:
        print(f)
except Exception as e:
    print(f"Error listing files: {e}")

