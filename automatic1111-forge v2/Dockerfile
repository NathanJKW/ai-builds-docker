# Use a lightweight Debian 12 (Bookworm) slim image as the base for a minimal and efficient container.
FROM debian:bookworm-slim AS base

# Metadata labels provide essential details for image maintainability and version tracking.
LABEL maintainer="Your Name <youremail@example.com>" \
      description="Dockerfile for setting up Stable Diffusion WebUI with CUDA on Debian Slim." \
      version="1.0"

# Build arguments to allow easy configuration of CUDA, Python, and PyTorch versions.
ARG CUDA_VERSION=12-4
ARG PYTHON_VERSION=3.11
ARG PYTORCH_VERSION=124

# Set environment variables:
# - DEBIAN_FRONTEND=noninteractive: prevents prompts during package installations.
# - LD_PRELOAD: preloads the specified library (libtcmalloc) to optimize memory usage.
# - COMMANDLINE_ARGS: used to pass default arguments when launching the web UI.
ENV DEBIAN_FRONTEND=noninteractive \
    LD_PRELOAD=libtcmalloc.so \
    COMMANDLINE_ARGS="--enable-insecure-extension-access --listen --xformers"

# Update package list, upgrade existing packages, and install essential dependencies.
# Clean up cached files afterward to keep the image size minimal.
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
        software-properties-common \
        wget \
        git \
        libgoogle-perftools-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Stage to set up NVIDIA's repository for CUDA.
FROM base AS nvidia-setup

# Download and install NVIDIA's CUDA keyring to enable access to their repository.
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    rm -f cuda-keyring_1.1-1_all.deb

# Add the "contrib" repository, update, and install the CUDA Toolkit, then clean up cached files.
FROM nvidia-setup AS cuda-install

RUN add-apt-repository contrib && \
    apt-get update && \
    apt-get -y install cuda-toolkit-${CUDA_VERSION} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Final stage to set up the environment and application.
FROM cuda-install AS automatic1111-forge

# Create a new group and user for running the application to avoid using the root user.
RUN groupadd -r aigroup && useradd -r -m -g aigroup aiuser

# Install the specified version of Python and set up a virtual environment.
RUN apt-get update && \
    apt-get install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-venv python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch to the non-root user for security best practices.
USER aiuser

# Set the working directory to the user's home directory.
WORKDIR /home/aiuser/

# Clone the Stable Diffusion WebUI repository to the working directory.
RUN git clone https://github.com/lllyasviel/stable-diffusion-webui-forge.git

# Change the working directory to the cloned repository folder.
WORKDIR /home/aiuser/stable-diffusion-webui-forge

# Modify the `webui-user.sh` script to dynamically set Python version, command-line args, and preloaded libraries.
RUN echo "python_cmd=\"python$PYTHON_VERSION\"" >> webui-user.sh && \
    echo "export COMMANDLINE_ARGS=\"$COMMANDLINE_ARGS\"" >> webui-user.sh && \
    echo "export LD_PRELOAD=\"$LD_PRELOAD\"" >> webui-user.sh && \
    echo "export TORCH_COMMAND=\"pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu$PYTORCH_VERSION\"" >> webui-user.sh

# Expose the default port used by the WebUI.
EXPOSE 7860

# Define a health check to ensure the WebUI is running by sending a request to the exposed port.
HEALTHCHECK CMD curl --fail http://localhost:7860 || exit 1

# Set the entrypoint to launch the WebUI script upon container startup.
ENTRYPOINT ["./webui.sh"]
