#!/bin/bash

# Enable strict error handling
set -euo pipefail

echo "Starting the environment for Development Purposes!"

# Stop and remove all services
echo "Stopping and removing all Docker services..."
docker compose down

# Perform system prune
echo "Cleaning up old Docker resources..."
docker system prune -a -f

# Uncomment the line below if you need to build the Docker image
# echo "Building Docker image for development..."
# docker build -t dev-image .

# Start services in detached mode
echo "Starting Docker services..."
docker compose up -d

echo "=========================================="
echo "Application is now running and exposed on port 80"
