# Dockerfile README

This README provides detailed instructions for using the Dockerfile to build and run a Docker container for the Stable Diffusion WebUI with CUDA on a Debian 12 (Bookworm) slim base image. The Dockerfile is structured into multiple stages for modularity and maintainability. This document will guide you through building the Docker image, running the container, and executing useful Docker commands to interact with the running container.

## Prerequisites

Ensure that you have the following installed on your system:
- Docker: Version 19.03 or later is recommended.
- NVIDIA Docker Runtime: For leveraging GPU acceleration with CUDA. Follow [NVIDIA's guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html) to set it up.

## Dockerfile Stages Overview

The Dockerfile is structured into the following stages:

1. **Base Stage (`base`)**: Initializes the Debian 12 slim image and installs common packages.
2. **NVIDIA Setup Stage (`nvidia-setup`)**: Adds the NVIDIA repository and installs CUDA dependencies.
3. **CUDA Install Stage (`cuda-install`)**: Installs the CUDA toolkit required for GPU acceleration.
4. **Final Stage (`automatic1111-forge`)**: Sets up the environment for running the Stable Diffusion WebUI, installs Python, and clones the WebUI repository.

## Building the Docker Image

To build the Docker image, use the following command:

```bash
docker build -t stable-diffusion-webui:1.0 .
```

This command will create a Docker image named `stable-diffusion-webui` with the version tag `1.0`.

### Build Arguments

You can customize the build with the following arguments:

- `CUDA_VERSION`: Specifies the CUDA toolkit version. Default is `12-4`.
- `PYTHON_VERSION`: Specifies the Python version to be installed. Default is `3.11`.

For example, to build with a different CUDA and Python version:

```bash
docker build --build-arg CUDA_VERSION=12-2 --build-arg PYTHON_VERSION=3.10 -t stable-diffusion-webui:1.0 .
```

## Running the Container

To run the container with GPU support and expose the WebUI on port `7860`, use the following command:

```bash
docker run --gpus all -d --name stable-diffusion-webui -p 7860:7860 stable-diffusion-webui:1.0
```

### Docker Run Options Explained:

- `--gpus all`: Allocates all available GPUs to the container.
- `-d`: Runs the container in detached mode (in the background).
- `--name stable-diffusion-webui`: Assigns a name (`stable-diffusion-webui`) to the container.
- `-p 7860:7860`: Maps port 7860 on the host to port 7860 in the container.

After running the command, the Stable Diffusion WebUI should be accessible in your browser at `http://localhost:7860`.

## Executing Commands Inside the Container

To execute commands inside the running container, use `docker exec`:

### Accessing the Container's Shell

```bash
docker exec -it stable-diffusion-webui /bin/bash
```

This command opens an interactive bash shell inside the container, allowing you to run additional commands or scripts.

### Checking the Container's Health

The Dockerfile includes a health check to verify if the WebUI is running. To check the health status, use:

```bash
docker inspect --format='{{.State.Health.Status}}' stable-diffusion-webui
```

If the WebUI is running correctly, the output should be `healthy`.

### Stopping and Removing the Container

To stop the running container:

```bash
docker stop stable-diffusion-webui
```

To remove the container:

```bash
docker rm stable-diffusion-webui
```

### Removing the Docker Image

If you want to remove the Docker image from your system:

```bash
docker rmi stable-diffusion-webui:1.0
```

## Customizing the Container Environment

The Dockerfile allows for the following customizations using environment variables:

- `COMMANDLINE_ARGS`: Modify this variable in the `docker run` command to pass additional arguments to the WebUI. For example:

  ```bash
  docker run --gpus all -d --name stable-diffusion-webui -p 7860:7860 -e COMMANDLINE_ARGS="--no-half --api" stable-diffusion-webui:1.0
  ```

- `LD_PRELOAD`: Set to use a specific library, such as `libtcmalloc.so` for memory optimization.

## Troubleshooting

- **Issue**: Cannot access the WebUI.
  - **Solution**: Ensure the container is running and the port `7860` is not being blocked by a firewall.

- **Issue**: CUDA errors.
  - **Solution**: Verify that the host system has the appropriate NVIDIA drivers installed, and ensure that the Docker runtime is set up for GPU support.

## Conclusion

This Dockerfile and corresponding guide provide a structured and modular way to set up the Stable Diffusion WebUI on a Debian slim base image with GPU acceleration. With the included stages and configurations, you can build and run the container, execute commands inside it, and customize its environment to suit your needs.

For further details, refer to the Dockerfile comments or the [Stable Diffusion WebUI repository](https://github.com/lllyasviel/stable-diffusion-webui-forge).

---