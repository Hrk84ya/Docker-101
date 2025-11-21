#!/bin/bash

# Development Environment Setup Script
# Sets up a complete Docker development environment

echo "Setting up Docker development environment..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create development network
echo "Creating development network..."
docker network create dev-network 2>/dev/null || echo "Network already exists"

# Create development volumes
echo "Creating development volumes..."
docker volume create dev-postgres-data 2>/dev/null || echo "Volume already exists"
docker volume create dev-redis-data 2>/dev/null || echo "Volume already exists"

# Pull common development images
echo "Pulling common development images..."
docker pull postgres:15-alpine
docker pull redis:7-alpine
docker pull nginx:alpine
docker pull node:18-alpine
docker pull python:3.11-slim

# Create development docker-compose.yml
echo "Creating development docker-compose.yml..."
cat > docker-compose.dev.yml << EOF
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: devdb
      POSTGRES_USER: devuser
      POSTGRES_PASSWORD: devpass
    ports:
      - "5432:5432"
    volumes:
      - dev-postgres-data:/var/lib/postgresql/data
    networks:
      - dev-network

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - dev-redis-data:/data
    networks:
      - dev-network

volumes:
  dev-postgres-data:
    external: true
  dev-redis-data:
    external: true

networks:
  dev-network:
    external: true
EOF

echo "Development environment setup completed!"
echo "Available services:"
echo "  - PostgreSQL: localhost:5432 (devuser/devpass)"
echo "  - Redis: localhost:6379"
echo ""
echo "Start services with: docker-compose -f docker-compose.dev.yml up -d"