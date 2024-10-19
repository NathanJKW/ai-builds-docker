# LLM Docker Setup

## **Step 1: Create a Custom Docker Network**

This network allows the containers to communicate using their container names.

```bash
# Create a custom Docker network named 'openai_network'
docker network create openai_network

# For reference
## View networks
docker network ls

## Remove  network
docker network rm <network_name>
```

---

## **Step 2: Run the Containers**

### **Run the `ollama` Container**

# Run the 'ollama' container
```bash
docker run -d \
  --name ollama \
  --network openai_network \
  -p 11434:11434 \
  -v ".:/app/data" \
  --gpus all \
  ollama/ollama
```

### **Explanation of Each Line**

1. **`docker run -d`**  
   Runs the container in detached mode, meaning it will run in the background and free up your terminal.
2. **`--name ollama`**  
   Assigns the name "ollama" to the container, allowing easy reference when managing the container (e.g., stopping or restarting it).
3. **`--network openai_network`**  
   Connects the container to the `openai_network` Docker network. This allows communication between this container and other containers on the same network.
4. **`-p 11434:11434`**  
   Maps port 11434 from inside the container to port 11434 on the host machine. This allows external access to the container's service on this port.
5. **`-v "$OLLAMA_DATA_DIR:/app/data"`**  
   Mounts a directory from the host (`$OLLAMA_DATA_DIR`, which should be an absolute path) to `/app/data` inside the container. This ensures data persistence by storing it on the host machine.
6. **`--gpus all`**  
   Enables GPU access for the container, allowing the container to use all available GPUs for tasks that require GPU processing.
7. **`ollama/ollama`**  
   Specifies the Docker image to use for the container. In this case, it's the `ollama/ollama` image.



### **Run the `pipelines` Container**

```bash
# Run the 'pipelines' container
docker run -d \
  --name pipelines \
  --network openai_network \
  -p 5002:9099 \
  -v pipelines:/app/pipelines \
  ghcr.io/open-webui/pipelines:main

# Run the 'pipelines' container
# Use the 'openai_network' network
# Expose port 5002 on the host and the container
# Mount the volume 'pipelines' to the /app/pipelines directory in the container
# Use the 'ghcr.io/open-webui/pipelines:main' image
```

### **Run the `open-webui` Container**

Set environment variables so `open-webui` can communicate with `ollama` and `pipelines`.

```bash
# Run the 'open-webui' container
docker run -d \
  --name open-webui \
  --network openai_network \
  -p 5001:8080 \
  -e PIPELINES_URL="http://pipelines:5002" \
  -e OLLAMA_URL="http://ollama:11434" \
  ghcr.io/open-webui/open-webui:main

# Run the 'open-webui' container
# Connect to the custom 'openai_network' network
# Map port 5001 on the container to port 5001 on the host
# Set the 'PIPELINES_URL' environment variable to "http://pipelines:5002"
# Set the 'OLLAMA_URL' environment variable to "http://ollama:11434"
# Use the 'ghcr.io/open-webui/open-webui:main' image
```

---

## **Step 3: Verify the Setup**

### **Check Running Containers**

```bash
# List all running containers
docker ps
```

You should see `ollama`, `pipelines`, and `open-webui` containers running.

### **Access Open-WebUI**

- Open your web browser and go to: `http://localhost:5001`

---

## **Additional Configuration**

### **GPU Support (If Needed)**

If any containers require GPU access, include the `--gpus all` flag.

```bash
# Example: Run 'open-webui' with GPU support
docker run -d \
  --name open-webui \
  --network openai_network \
  -p 5001:5001 \
  -e PIPELINES_URL="http://pipelines:5002" \
  -e OLLAMA_URL="http://ollama:11434" \
  --gpus all \                       # Enable GPU support
  openwebui/openwebui:latest
```

---

## **Troubleshooting**

### **Check Container Logs**

```bash
# View logs for a container (replace 'container_name' as needed)
docker logs container_name
```

### **Test Connectivity Between Containers**

```bash
# Open a shell inside the 'open-webui' container
docker exec -it open-webui sh

# Inside the container, test connectivity
ping pipelines    # Should reach the 'pipelines' container
ping ollama       # Should reach the 'ollama' container

# Exit the container shell
exit
```

---

## **Stopping and Cleaning Up**

### **Stop and Remove Containers**

```bash
# Stop the containers
docker stop ollama pipelines open-webui

# Remove the containers
docker rm ollama pipelines open-webui
```

### **Remove the Custom Docker Network**

```bash
# Remove the 'openai_network' network
docker network rm openai_network
```

---

## **Summary**

- **Create** a custom Docker network for inter-container communication.
- **Run** each container (`ollama`, `pipelines`, `open-webui`) connected to this network.
- **Verify** that the containers are running and accessible.
- **Troubleshoot** if necessary using logs and connectivity tests.
- **Clean up** by stopping and removing containers and the network when done.

---

Feel free to adjust the paths and commands according to your environment!