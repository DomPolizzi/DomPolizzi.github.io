---
title: Deploy Open WebUI in Docker Swarm with Chroma DB and Ollama 
subtitle: Streamline AI Model Hosting with Docker Swarm, Chroma DB, and Ollama
description: Learn how to deploy Open WebUI seamlessly within a Docker Swarm deployment, integrating Chroma DB for efficient vector database management and Ollama for AI model hosting. This step-by-step guide covers setting up containers, configuring dependencies, and optimizing your deployment for scalable and robust performance. Perfect for developers and AI enthusiasts looking to streamline their machine learning workflows.
date: 2024-11-16 00:00:00
featured_image: /images/site-assets/sidebar-3.jpg
---


# Deploy OpenWebUI, Ollama, and Chroma Containers to a Docker Swarm

Deploying AI tools like OpenWebUI, Ollama, and ChromaDB in a Docker Swarm can seem daunting. This guide simplifies the process by providing a streamlined method using a Docker stack file to deploy three containers as services. Whether you're using GPU or CPU, this guide ensures a smooth setup.

## Overview

This deployment method leverages Docker Swarm to create isolated services for OpenWebUI, Ollama, and ChromaDB. With pre-configured environment variables and detailed instructions, you can get your AI tools running with minimal effort.

## Prerequisites

1. Basic understanding of Docker Swarm.
2. Docker Swarm configured on your host system.
3. Proper directories or volumes created for data storage:
   ```bash
   mkdir -p data/open-webui data/chromadb data/ollama
   ```
4. GPU support (optional) with NVIDIA Container Toolkit installed and configured.

---

## Deployment Steps

### Step 1: Prepare Your Environment

- **With GPU Support**:
  Ensure your host system has GPU support configured:
  - Enable CUDA for your OS and GPU.
  - Install the [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html).
  - Edit `/etc/docker/daemon.json` to include:
    ```json
    {
      "NVIDIA-GPU": "GPU-<YOUR_GPU_NUMBER>"
    }
    ```
  - Enable GPU resource advertising in `/etc/nvidia-container-runtime/config.toml` by uncommenting:
    ```
    swarm-resource = "DOCKER_RESOURCE_GPU"
    ```
  - Restart the Docker daemon:
    ```bash
    sudo service docker restart
    ```

- **With CPU Support**:
  Modify the `docker-stack.yaml` file to remove GPU-specific lines (lines 70-76).

### Step 2: Configure the Docker Stack

Below is a sample `docker-stack.yaml` file for deploying the three services:

```yaml
version: '3.9'
services:
  openWebUI:
    image: ghcr.io/open-webui/open-webui:main
    depends_on:
      - chromadb
      - ollama
    volumes:
      - ./data/open-webui:/app/backend/data
    environment:
      DATA_DIR: /app/backend/data
      OLLAMA_BASE_URLS: http://ollama:11434
      CHROMA_HTTP_PORT: 8000
      CHROMA_HTTP_HOST: chromadb
      CHROMA_TENANT: default_tenant
      VECTOR_DB: chroma
      WEBUI_NAME: Awesome ChatBot
      CORS_ALLOW_ORIGIN: "*"
      RAG_EMBEDDING_ENGINE: ollama
      RAG_EMBEDDING_MODEL: nomic-embed-text-v1.5
      RAG_EMBEDDING_MODEL_TRUST_REMOTE_CODE: "True"
    ports:
      - target: 8080
        published: 8080
        mode: overlay
    deploy:
      replicas: 1
      restart_policy:
        condition: any
        delay: 5s
        max_attempts: 3

  chromadb:
    hostname: chromadb
    image: chromadb/chroma:0.5.15
    volumes:
      - ./data/chromadb:/chroma/chroma
    environment:
      - IS_PERSISTENT=TRUE
      - ALLOW_RESET=TRUE
      - PERSIST_DIRECTORY=/chroma/chroma
    ports: 
      - target: 8000
        published: 8000
        mode: overlay
    deploy:
      replicas: 1
      restart_policy:
        condition: any
        delay: 5s
        max_attempts: 3
    healthcheck: 
      test: ["CMD-SHELL", "curl localhost:8000/api/v1/heartbeat || exit 1"]
      interval: 10s
      retries: 2
      start_period: 5s
      timeout: 10s

  ollama:
    image: ollama/ollama:latest
    hostname: ollama
    ports:
      - target: 11434
        published: 11434
        mode: overlay
    deploy:
      resources:
        reservations:
          generic_resources:
            - discrete_resource_spec:
                kind: "NVIDIA-GPU"
                value: 0
      replicas: 1
      restart_policy:
        condition: any
        delay: 5s
        max_attempts: 3
    volumes:
      - ./data/ollama:/root/.ollama
```

### Step 3: Deploy the Stack

- Deploy the stack with GPU support:
  ```bash
  docker stack deploy -c docker-stack.yaml -d super-awesome-ai
  ```

- Deploy with CPU support (after modifying the stack file):
  ```bash
  docker stack deploy -c docker-stack.yaml -d super-awesome-ai
  ```

---

## Additional Resources

- [OpenWebUI GitHub](https://github.com/open-webui/open-webui)
- [ChromaDB GitHub](https://github.com/chroma-core/chroma)
- [Ollama GitHub](https://github.com/chroma-core/chroma)

---

Feel free to reach out if you have any questions or need support!  

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://buymeacoffee.com/dompolizzi)
