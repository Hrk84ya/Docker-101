# Dockerfile Guide

## Introduction

A Dockerfile is a text file containing instructions to build a Docker image. It defines the base image, environment settings, and commands needed to configure and run your application in a container.

## Essential Instructions

### FROM
Specifies the base image for your Docker image.
```dockerfile
FROM node:18-alpine
FROM python:3.11-slim
```

### WORKDIR
Sets the working directory for subsequent instructions.
```dockerfile
WORKDIR /app
```

### COPY & ADD
Copies files from host to container filesystem.
```dockerfile
COPY package*.json ./
COPY . .
ADD https://example.com/file.tar.gz /tmp/
```

### RUN
Executes commands during the build process.
```dockerfile
RUN npm install
RUN apt-get update && apt-get install -y curl
```

### CMD vs ENTRYPOINT
- **CMD**: Default command when container starts (can be overridden)
- **ENTRYPOINT**: Always executed command (cannot be overridden)

```dockerfile
CMD ["node", "server.js"]
ENTRYPOINT ["npm", "start"]
```

### EXPOSE
Documents which ports the container listens on.
```dockerfile
EXPOSE 3000 8080
```

### ENV & ARG
- **ENV**: Sets runtime environment variables
- **ARG**: Sets build-time variables

```dockerfile
ARG NODE_VERSION=18
ENV NODE_ENV=production
ENV PORT=3000
```

## Best Practices

### 1. Use Official Base Images
```dockerfile
# Good
FROM node:18-alpine
FROM python:3.11-slim

# Avoid
FROM ubuntu:latest
```

### 2. Optimize Layer Caching
Place frequently changing instructions at the end.
```dockerfile
# Copy dependencies first
COPY package*.json ./
RUN npm install

# Copy source code last
COPY . .
```

### 3. Combine RUN Instructions
```dockerfile
# Good
RUN apt-get update && \
    apt-get install -y curl vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Avoid
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y vim
```

### 4. Use Multi-Stage Builds
```dockerfile
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Production stage
FROM node:18-alpine AS production
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
CMD ["node", "server.js"]
```

### 5. Use .dockerignore
Create a `.dockerignore` file to exclude unnecessary files:
```
node_modules
.git
*.md
.env
```

### 6. Security Best Practices
```dockerfile
# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Switch to non-root user
USER nextjs

# Use specific versions
FROM node:18.17.0-alpine
```

### 7. Health Checks
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
```

## Complete Example

```dockerfile
# Multi-stage Node.js application
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json ./

# Development dependencies
FROM base AS dev-deps
RUN npm ci

# Production dependencies
FROM base AS prod-deps
RUN npm ci --only=production

# Build stage
FROM dev-deps AS build
COPY . .
RUN npm run build

# Production stage
FROM node:18-alpine AS production
WORKDIR /app

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Copy production files
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY package*.json ./

# Set ownership and switch user
RUN chown -R nextjs:nodejs /app
USER nextjs

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD node healthcheck.js

EXPOSE 3000
CMD ["node", "dist/server.js"]
```

## Common Patterns

### Node.js Application
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

### Python Flask Application
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
```

### Static Website with Nginx
```dockerfile
FROM nginx:alpine
COPY dist/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```