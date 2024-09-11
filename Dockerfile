# Base image
FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHON_VERSION=3.10
ENV PYTORCH_VERSION=2.1.2
ENV CUDA_VERSION=121
ENV XFORMERS_VERSION=0.0.23

# Install system dependencies and Python
RUN apt-get update && apt-get install -y --no-install-recommends \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-dev \
    python3-pip \
    git \
    wget \
    curl \
    nginx \
    openssh-server \
    net-tools \
    && ln -sf /usr/bin/python${PYTHON_VERSION} /usr/bin/python3 \
    && ln -sf /usr/bin/python${PYTHON_VERSION} /usr/bin/python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python packages
RUN python3 -m pip install --no-cache-dir --upgrade pip && \
    python3 -m pip install --no-cache-dir \
    torch==${PYTORCH_VERSION}+cu${CUDA_VERSION} \
    torchvision \
    torchaudio \
    --extra-index-url https://download.pytorch.org/whl/cu${CUDA_VERSION} && \
    python3 -m pip install --no-cache-dir xformers==${XFORMERS_VERSION} jupyterlab

# Set up SSH
RUN mkdir /var/run/sshd && \
    echo 'root:runpod' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Set environment variables
ENV PATH="/usr/local/cuda/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"

# Clone ComfyUI repository
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI

WORKDIR /workspace/ComfyUI

# Install ComfyUI dependencies
RUN pip install -r requirements.txt

# Copy start script and pre-start script
COPY start.sh /start.sh
COPY pre_start.sh /pre_start.sh
RUN chmod +x /start.sh /pre_start.sh

# NGINX configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose ports for SSH, Jupyter, and code-server
EXPOSE 22 8888 8080

CMD ["/start.sh"]
