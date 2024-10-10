# Dockerfile README

This README provides an in-depth explanation of a Dockerfile designed for creating a Debian-based container with NVIDIA CUDA Toolkit 12.4. It also includes steps for setting up the container environment, adding the necessary repositories, and installing CUDA components. 

The Dockerfile is divided into multiple stages for modularity, ensuring that each part is built separately and can be optimized for smaller image sizes and faster builds.

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Dockerfile Breakdown](#dockerfile-breakdown)
   - [Stage 1: Base Setup](#stage-1-base-setup)
   - [Stage 2: Add NVIDIA Repository](#stage-2-add-nvidia-repository)
   - [Stage 3: Configure Repositories](#stage-3-configure-repositories)
   - [Stage 4: Install CUDA Toolkit](#stage-4-install-cuda-toolkit)
   - [Stage 5: Final Image Setup](#stage-5-final-image-setup)
4. [Usage Instructions](#usage-instructions)
5. [Common Docker Commands](#common-docker-commands)
6. [References](#references)

## Overview
This Dockerfile is built using the official [Debian 12 (Bookworm) slim image](https://hub.docker.com/_/debian/tags?page=1) as a base. It installs the NVIDIA CUDA Toolkit 12.4 by adding NVIDIA’s CUDA repository to the system and configuring it correctly.

The multi-stage build approach ensures that each task is executed in isolation, helping to maintain a clean and efficient final image. This setup is particularly useful for applications requiring GPU acceleration, such as machine learning or scientific computing.

## Prerequisites
Before building or running this Dockerfile, ensure that you have the following:
1. Docker installed on your system. If not, refer to the [Docker installation guide](https://docs.docker.com/get-docker/).
2. A compatible NVIDIA GPU and the NVIDIA Container Toolkit installed. Follow the [NVIDIA Container Toolkit setup](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) instructions to get started.

## Dockerfile Breakdown
This Dockerfile uses a multi-stage build process, with each stage performing a distinct setup step. Below is a detailed explanation of each stage.

### Stage 1: Base Setup
```dockerfile
FROM debian:bookworm-slim AS base

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y software-properties-common wget
```
**Description:**  
This stage starts with the `debian:bookworm-slim` image and performs a system update and upgrade to ensure all packages are up-to-date. It also installs `software-properties-common` for managing repositories and `wget` for downloading files.

**Purpose:**  
- Setting up a minimal Debian environment.
- Ensuring that the image has the necessary tools for adding repositories and downloading files.

### Stage 2: Add NVIDIA Repository
```dockerfile
FROM base AS nvidia-setup

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
RUN dpkg -i cuda-keyring_1.1-1_all.deb
```
**Description:**  
This stage downloads and installs the NVIDIA CUDA keyring package, which is necessary for adding NVIDIA’s CUDA repository to the Debian system securely.

**Purpose:**  
- Adding the NVIDIA CUDA repository for Debian 12.
- Ensuring secure access to the repository using a keyring.

### Stage 3: Configure Repositories
```dockerfile
FROM nvidia-setup AS repo-setup

RUN add-apt-repository contrib
RUN apt-get update
```
**Description:**  
This stage configures the Debian system to include the `contrib` repository, which provides additional software packages not included in the main Debian distribution.

**Purpose:**  
- Adding the `contrib` repository, which contains useful software like CUDA and other drivers.
- Updating the package list to include the newly added repository.

### Stage 4: Install CUDA Toolkit
```dockerfile
FROM repo-setup AS cuda-install

RUN apt-get -y install cuda-toolkit-12-4
```
**Description:**  
This stage installs the NVIDIA CUDA Toolkit version 12.4, which provides tools and libraries necessary for GPU-accelerated applications.

**Purpose:**  
- Installing CUDA 12.4 to enable GPU computing capabilities.
- Preparing the environment for CUDA-based applications.

### Stage 5: Final Image Setup
```dockerfile
FROM cuda-install AS final

CMD ["bash"]
```
**Description:**  
This final stage sets up the container to launch `bash` when it starts. This gives the user a command-line interface for further configuration and running applications inside the container.

**Purpose:**  
- Creating a final, ready-to-use container image with CUDA installed.
- Providing a shell interface for interactive use.

## Usage Instructions
1. **Build the Docker Image**  
   Navigate to the directory containing your Dockerfile and run:
   ```bash
   docker build -t cuda-debian-image .
   ```
   This command builds the Docker image and tags it as `cuda-debian-image`.

2. **Run the Docker Container**  
   Once the image is built, run a container using:
   ```bash
   docker run --gpus all -it cuda-debian-image
   ```
   This command starts the container with GPU access and provides an interactive terminal.

3. **Verify CUDA Installation**  
   Inside the running container, you can verify the CUDA installation using:
   ```bash
   nvcc --version
   ```
   This should display information about the installed CUDA Toolkit.

## Common Docker Commands
Here are some commonly used Docker commands to interact with your container:

- **List running containers:**
  ```bash
  docker ps
  ```
- **Execute a command inside a running container:**
  ```bash
  docker exec -it <container_id_or_name> bash
  ```
  This command starts an interactive bash shell in the specified container.

- **Copy files to/from a container:**
  ```bash
  docker cp <file_path> <container_id_or_name>:<container_path>
  ```
  This command copies files between the host and container.

- **View files inside the container:**
  ```bash
  docker exec -it <container_id_or_name> ls /path/inside/container
  ```
  Use this to check the contents of a directory inside the container.

- **Stop a running container:**
  ```bash
  docker stop <container_id_or_name>
  ```

- **Remove a container:**
  ```bash
  docker rm <container_id_or_name>
  ```

## References
The following resources were used to create this Dockerfile:

- [Debian Docker Hub Repository](https://hub.docker.com/_/debian/tags?page=1)
- [NVIDIA CUDA Install Guide](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#debian)
- [NVIDIA CUDA Download Links](https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Debian&target_version=12&target_type=deb_network)

Feel free to modify the Dockerfile as needed to suit your specific requirements.