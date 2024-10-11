# Define the base image with metadata labels for maintainability
# Using Debian 12 (Bookworm) slim image as a minimal base
FROM debian:bookworm-slim AS base

# Metadata labels
LABEL maintainer="Your Name <youremail@example.com>" \
      description="Dockerfile for setting up Stable Diffusion WebUI with CUDA on Debian Slim." \
      version="1.0"

# Define build arguments for versioning and use them to keep the image configurable.
ARG CUDA_VERSION=12-4
ARG PYTHON_VERSION=3.11
ARG PYTORCH_VERSION=124

# Set up environment variables for default configurations
ENV DEBIAN_FRONTEND=noninteractive \
    LD_PRELOAD=libtcmalloc.so \
    COMMANDLINE_ARGS="--enable-insecure-extension-access --listen --xformers"

# Update, upgrade, and install necessary packages in one RUN command to reduce layers and clean up afterwards
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
        software-properties-common \
        wget \
        git \
        libgoogle-perftools-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Stage to add NVIDIA repository
FROM base AS nvidia-setup

# Download and install the CUDA keyring package to access the NVIDIA repository securely
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    rm -f cuda-keyring_1.1-1_all.deb

# Configure the repository and install CUDA Toolkit
FROM nvidia-setup AS cuda-install

# Add the "contrib" repository, update, and install CUDA in one command to reduce layers
RUN add-apt-repository contrib && \
    apt-get update && \
    apt-get -y install cuda-toolkit-${CUDA_VERSION} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Final stage for setting up the application and user environment
FROM cuda-install AS automatic1111-forge

# Create a group and user for running the application
RUN groupadd -r aigroup && useradd -r -m -g aigroup aiuser

# Install Python and create a virtual environment
RUN apt-get update && \
    apt-get install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-venv python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch to the newly created user
USER aiuser

# Set working directory to user's home directory
WORKDIR /home/aiuser/

# Clone the required repository into the user's home directory
RUN git clone https://github.com/lllyasviel/stable-diffusion-webui-forge.git

# Set the working directory to the cloned repository's directory
WORKDIR /home/aiuser/stable-diffusion-webui-forge

# Modify the `webui-user.sh` script using environment variables for flexibility
RUN echo "python_cmd=\"python$PYTHON_VERSION\"" >> webui-user.sh && \
    echo "export COMMANDLINE_ARGS=\"$COMMANDLINE_ARGS\"" >> webui-user.sh && \
    echo "export LD_PRELOAD=\"$LD_PRELOAD\"" >> webui-user.sh && \
    echo "export TORCH_COMMAND=\"pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu$PYTORCH_VERSION\"" >> webui-user.sh

# Expose port 7860 for the web UI
EXPOSE 7860

# Add a health check to ensure the web UI is running
HEALTHCHECK CMD curl --fail http://localhost:7860 || exit 1

# Set the entrypoint to run the web UI script
ENTRYPOINT ["./webui.sh"]
