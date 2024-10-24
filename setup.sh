#!/bin/bash

echo "For Development Purposes!"

docker build -t dev-image .

docker compose up -d

echo "=========================================="
echo "Application exposed on port 80"