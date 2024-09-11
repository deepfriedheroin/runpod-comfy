FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/miniconda3/bin:${PATH}"

RUN apt-get update && apt-get install -y \
    git wget curl nginx && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /root/miniconda3 && \
    rm miniconda.sh

# Create conda environment
RUN conda create -n comfy python=3.10 -y

# Activate conda environment
SHELL ["conda", "run", "-n", "comfy", "/bin/bash", "-c"]

# Clone ComfyUI repository
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

WORKDIR /workspace/ComfyUI

# Install ComfyUI dependencies
RUN pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121 && \
    pip install -r requirements.txt && \
    pip install xformers

# Copy start script and pre-start script
COPY start.sh /start.sh
COPY pre_start.sh /pre_start.sh
RUN chmod +x /start.sh /pre_start.sh

# NGINX configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy README
COPY README.md /usr/share/nginx/html/README.md

CMD ["/start.sh"]
