# WSL Troubleshooting Guide for ComfyUI

This document contains solutions for common issues when running ComfyUI in Windows Subsystem for Linux (WSL).

---

## Problem: ComfyUI Crashes Silently When Loading Large Models (Lumina2, etc.)

### Symptoms
- ComfyUI starts normally and shows the web interface at `http://127.0.0.1:8188`
- When running a workflow with a large model (e.g., Lumina2, Z-Image), the process dies silently
- No error message is shown in the terminal
- The last output before crash typically shows:
  ```
  model weight dtype torch.bfloat16, manual cast: None
  model_type FLOW
  ```
- Terminal just returns to prompt without any Python traceback

### Root Cause
**Linux OOM (Out of Memory) Killer** terminates the Python process when it tries to allocate more RAM than available.

WSL by default limits memory to approximately 50% of your system RAM. Large models like Lumina2 require significant RAM to load (often 14GB+), which exceeds this default limit.

### How to Diagnose Silent Crashes

Since the OOM killer terminates the process abruptly, Python never gets a chance to print an error. To identify OOM kills:

1. **Check kernel logs with `dmesg`:**
   ```bash
   wsl -d Ubuntu-24.04 -e bash -c "dmesg | tail -50 | grep -i -E 'oom|kill|memory'"
   ```

2. **Look for messages like:**
   ```
   oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0,global_oom,task_memcg=/init.scope,task=python,pid=60701,uid=1000
   Out of memory: Killed process 60701 (python) total-vm:81999372kB, anon-rss:15385156kB, file-rss:292kB, shmem-rss:75680kB, UID:1000
   ```

3. **Key indicators:**
   - `oom-kill` - Confirms OOM killer was triggered
   - `task=python` - Confirms Python was the killed process
   - `anon-rss` - Shows how much RAM the process was using

### Solution: Increase WSL Memory Limit

1. **Edit or create the WSL config file** at `C:\Users\<YourUsername>\.wslconfig`:
   ```ini
   [wsl2]
   memory=14GB
   swap=8GB
   ```

   Adjust `memory` based on your total system RAM:
   - 16GB system: use `memory=14GB`
   - 32GB system: use `memory=28GB`
   - 64GB system: use `memory=56GB`

2. **Restart WSL** (required for changes to take effect):
   ```powershell
   wsl --shutdown
   ```

3. **Verify the new settings:**
   ```bash
   wsl -d Ubuntu-24.04 -e bash -c "free -h"
   ```

### Additional Tips

- **Close other applications** before running large models to free up RAM
- **Use `--lowvram` flag** if you have limited VRAM (but this won't help with RAM issues)
- **Monitor memory usage** during model loading:
  ```bash
  watch -n 1 free -h
  ```

---

## Problem: "Invalid starting directory" Error in Terminal

### Symptoms
```
The terminal process failed to launch: Invalid starting directory "\\wsl.localhost\Ubuntu-24.04\home\jona\ComfyUI", review your terminal.integrated.cwd setting.
```

### Root Cause
The UNC path format (`\\wsl.localhost\...`) doesn't work as a terminal starting directory in some configurations.

### Solution
Run commands via the `wsl` command from PowerShell instead:

```powershell
wsl -d Ubuntu-24.04 -e bash -c "cd /home/jona/ComfyUI && source venv/bin/activate && python main.py"
```

---

## Problem: "unet missing: ['norm_final.weight']" Warning

### Symptoms
When loading Lumina2, you see:
```
model weight dtype torch.bfloat16, manual cast: None
model_type FLOW
unet missing: ['norm_final.weight']
Requested to load Lumina2
```

### Is This an Error?
**No, this is usually benign.** The warning indicates a mismatch between checkpoint contents and model architecture, but it typically doesn't affect functionality because:

1. The `FinalLayer.norm_final` in Lumina uses `LayerNorm` with `elementwise_affine=False`, meaning it intentionally has **no learnable weights**
2. The checkpoint may be from a slightly different format that still works correctly

**If your model loads and generates images successfully, ignore this warning.**

---

## Quick Reference: Running ComfyUI in WSL

### Start ComfyUI from PowerShell:
```powershell
wsl -d Ubuntu-24.04 -e bash -c "cd /home/jona/ComfyUI && source venv/bin/activate && python main.py"
```

### Start with debugging output:
```powershell
wsl -d Ubuntu-24.04 -e bash -c "cd /home/jona/ComfyUI && source venv/bin/activate && python -u main.py 2>&1 | tee /tmp/comfy.log"
```

### Check for OOM after a crash:
```powershell
wsl -d Ubuntu-24.04 -e bash -c "dmesg | grep -i oom | tail -10"
```

### Check current WSL memory allocation:
```powershell
wsl -d Ubuntu-24.04 -e bash -c "free -h"
```

---

## Environment Information

- **OS:** Windows 10/11 with WSL2
- **WSL Distribution:** Ubuntu 24.04
- **GPU:** NVIDIA GeForce RTX 4070 Ti SUPER (16GB VRAM)
- **ComfyUI Version:** 0.3.75
- **PyTorch:** 2.9.1+cu128

