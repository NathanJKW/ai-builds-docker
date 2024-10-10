# Stage 1: Base Setup
# -------------------
# Start from the Debian 12 (Bookworm) slim image, which is a minimal base image
FROM debian:bookworm-slim AS base

# Update the package list to ensure we have the latest information on available packages
RUN apt-get update -y && apt-get upgrade -y

# Install software-properties-common for managing repositories and wget for downloading files
RUN apt-get install -y software-properties-common wget

# Stage 2: Add NVIDIA Repository
# ------------------------------
# Start from the base setup stage to ensure continuity
FROM base AS nvidia-setup

# Download the CUDA keyring package to add NVIDIA’s package repository
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb

# Install the CUDA keyring package to enable secure access to the CUDA repository
RUN dpkg -i cuda-keyring_1.1-1_all.deb

# Stage 3: Configure Repositories
# -------------------------------
# Continue from the NVIDIA setup stage
FROM nvidia-setup AS repo-setup

# Add the "contrib" repository, which includes additional software not part of the main Debian distribution
RUN add-apt-repository contrib

# Update the package list again to include the newly added contrib repository
RUN apt-get update

# Stage 4: Install CUDA Toolkit
# -----------------------------
# Start from the repository configuration stage
FROM repo-setup AS cuda-install

# Install the specified version of the CUDA toolkit (in this case, CUDA Toolkit 12.4)
RUN apt-get -y install cuda-toolkit-12-4

# Stage 5: Final Image Setup
# --------------------------
# Create the final stage by copying all necessary files from previous stages
FROM cuda-install AS final

# Uncomment the line below to verify if the NVIDIA GPU is detected successfully inside the container
#RUN nvidia-smi

# Set the default command to run bash when the container starts
CMD ["bash"]