#!/bin/bash

# Add any pre-start configuration here
# For example, you might want to download models or set up directories

# Start ComfyUI
conda run -n comfy python main.py --listen 0.0.0.0 --port 3000