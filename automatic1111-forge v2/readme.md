Here’s the updated README that reflects the changes in your Dockerfile:

---

# Dockerfile README

This README provides comprehensive instructions for building and running a Docker container that hosts the Stable Diffusion WebUI with CUDA support on a minimal Debian 12 (Bookworm) slim base image. The Dockerfile is designed with multi-stage builds for better modularity, maintainability, and reduced image size. Below are step-by-step guidelines for building the Docker image, running the container, and managing it effectively.

## Prerequisites

Ensure the following components are installed on your system before building or running the container:

- **Docker**: Version 19.03 or later for compatibility with NVIDIA's GPU support.
- **NVIDIA Docker Runtime**: This is essential for GPU acceleration using CUDA. Follow [NVIDIA's guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) to set it up.

## Dockerfile Overview

The Dockerfile uses a multi-stage approach to optimize the image size and modularity. It includes the following stages:

1. **Base Stage (`base`)**: Initializes a minimal Debian 12 slim image and installs essential packages.
2. **NVIDIA Setup Stage (`nvidia-setup`)**: Adds NVIDIA's repository and keyring for installing CUDA.
3. **CUDA Install Stage (`cuda-install`)**: Installs the specified version of the CUDA toolkit.
4. **Final Stage (`automatic1111-forge`)**: Installs Python, clones the Stable Diffusion WebUI repository, and prepares the environment for running the WebUI.

### Key Features:

- **Environment Variables**:
    - `DEBIAN_FRONTEND=noninteractive`: Ensures that no prompts are shown during the installation of packages.
    - `LD_PRELOAD=libtcmalloc.so`: Preloads the memory optimization library `libtcmalloc` to reduce memory usage.
    - `COMMANDLINE_ARGS`: Passes default command-line arguments to the WebUI (e.g., `--enable-insecure-extension-access`).

- **Build Arguments**:
    - `CUDA_VERSION`: Specifies the CUDA version to be installed. The default is set to `12-4`.
    - `PYTHON_VERSION`: Specifies the Python version for installation. The default is set to `3.11`.
    - `PYTORCH_VERSION`: Specifies the version of PyTorch to install. Default is set to `124`.

## Building the Docker Image

Use the following command to build the Docker image:

```bash
docker build -t stable-diffusion-webui:1.0 .
```

### Build Arguments

You can customize the build by passing arguments for the CUDA, Python, and PyTorch versions:

```bash
docker build --build-arg CUDA_VERSION=12-2 --build-arg PYTHON_VERSION=3.10 --build-arg PYTORCH_VERSION=113 -t stable-diffusion-webui:1.0 .
```

This will build the image with different versions of CUDA, Python, and PyTorch.

## Running the Container

To run the container with GPU support and expose the WebUI on port `7860`, use the following command:

```bash
docker run --gpus all -d --name stable-diffusion-webui -p 7860:7860 stable-diffusion-webui:1.0
```

### Run Options Explained

- `--gpus all`: Allocates all available GPUs to the container.
- `-d`: Runs the container in detached mode.
- `--name stable-diffusion-webui`: Names the container `stable-diffusion-webui`.
- `-p 7860:7860`: Maps port 7860 on the host to port 7860 inside the container.

Once the container starts, you can access the Stable Diffusion WebUI by visiting `http://localhost:7860` in your browser.

## Customizing the Container Environment

### Environment Variables

You can pass additional command-line arguments and modify the environment variables when running the container.

- **`COMMANDLINE_ARGS`**: Custom arguments for the WebUI can be passed through this environment variable. Example:

  ```bash
  docker run --gpus all -d --name stable-diffusion-webui -p 7860:7860 -e COMMANDLINE_ARGS="--no-half --api" stable-diffusion-webui:1.0
  ```

- **`LD_PRELOAD`**: Preload a different library if needed (default is `libtcmalloc.so` for memory optimization).

## Executing Commands Inside the Container

### Accessing the Container Shell

You can execute commands inside the running container using `docker exec`:

```bash
docker exec -it stable-diffusion-webui /bin/bash
```

This will provide an interactive bash shell inside the container, allowing you to inspect logs, modify scripts, or manually run commands.

## Health Check

The Dockerfile includes a health check mechanism to verify if the WebUI is running. To inspect the health status of the container:

```bash
docker inspect --format='{{.State.Health.Status}}' stable-diffusion-webui
```

If the WebUI is running properly, the output should be `healthy`.

## Stopping and Removing the Container

You can stop the running container using:

```bash
docker stop stable-diffusion-webui
```

To remove the stopped container:

```bash
docker rm stable-diffusion-webui
```

## Removing the Docker Image

If you want to delete the Docker image from your system:

```bash
docker rmi stable-diffusion-webui:1.0
```

## Troubleshooting

### Common Issues

- **Cannot access the WebUI**:
    - Ensure the container is running and the port `7860` is not blocked by a firewall.
  
- **CUDA errors**:
    - Make sure that the host system has the correct NVIDIA drivers installed and the NVIDIA Docker runtime is set up correctly.

## Conclusion

This Dockerfile provides a structured and modular approach to building and running a Stable Diffusion WebUI with CUDA support. By using multiple stages and customization options, it allows for a lightweight, flexible, and efficient setup.

For further details, refer to the comments in the Dockerfile or visit the official [Stable Diffusion WebUI repository](https://github.com/lllyasviel/stable-diffusion-webui-forge).

--- 