# ComfyUI Container Template

This container provides a ready-to-use environment for running ComfyUI with CUDA support and the ComfyUI-Manager installed.

## Features

- CUDA 12.1.1 with cuDNN 8
- Python 3.10
- Latest compatible PyTorch and xformers
- ComfyUI (latest version)
- ComfyUI-Manager installed as a custom node

## Usage

1. Start the container
2. Access ComfyUI through the exposed port (default: 3000)
3. Use ComfyUI-Manager to install additional custom nodes and models as needed

## Configuration

- The ComfyUI interface is accessible on port 3000
- Models and outputs are stored in the `/workspace/ComfyUI` directory

## Customization

You can modify the `pre_start.sh` script to add custom initialization steps, such as downloading specific models or setting up directories.

## Support

For issues related to this container, please open an issue on the GitHub repository.
For ComfyUI-specific questions, refer to the [ComfyUI GitHub repository](https://github.com/comfyanonymous/ComfyUI).