#!/bin/bash

# Image Optimization Helper Script
# Analyzes and provides suggestions for Docker image optimization

if [ $# -eq 0 ]; then
    echo "Usage: $0 <image-name>"
    exit 1
fi

IMAGE_NAME=$1

echo "Analyzing image: $IMAGE_NAME"

# Check if image exists
if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    echo "Image $IMAGE_NAME not found"
    exit 1
fi

# Show image size
echo "Image size:"
docker images "$IMAGE_NAME" --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"

# Show image layers
echo -e "\n Image layers:"
docker history "$IMAGE_NAME" --format "table {{.CreatedBy}}\t{{.Size}}"

# Show largest layers
echo -e "\n Largest layers:"
docker history "$IMAGE_NAME" --format "table {{.Size}}\t{{.CreatedBy}}" | sort -hr | head -5

# Security scan (if available)
echo -e "\n Security scan:"
if command -v docker &> /dev/null; then
    docker scan "$IMAGE_NAME" 2>/dev/null || echo "Docker scan not available or image not scannable"
fi

echo -e "\n Optimization suggestions:"
echo "1. Use multi-stage builds to reduce final image size"
echo "2. Use alpine-based images when possible"
echo "3. Combine RUN commands to reduce layers"
echo "4. Remove package managers and build tools in final stage"
echo "5. Use .dockerignore to exclude unnecessary files"