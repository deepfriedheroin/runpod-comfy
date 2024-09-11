#!/bin/bash

# Source conda
source /root/miniconda3/etc/profile.d/conda.sh

# Activate comfy environment
conda activate comfy

# Start NGINX
nginx

# Run pre-start script
/pre_start.sh

# Keep the container running
tail -f /dev/null