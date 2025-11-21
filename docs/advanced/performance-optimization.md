# Docker Performance Optimization

## Image Optimization

### Layer Caching
```dockerfile
# Good - dependencies change less frequently
COPY package.json .
RUN npm install
COPY . .

# Bad - invalidates cache on any file change
COPY . .
RUN npm install
```

### Multi-Stage Builds
```dockerfile
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:18-alpine
COPY --from=builder /app/node_modules ./node_modules
COPY . .
CMD ["node", "server.js"]
```

### Minimize Image Size
```dockerfile
# Use alpine variants
FROM node:18-alpine

# Remove package managers
RUN apk add --no-cache curl && \
    apk del apk-tools

# Use .dockerignore
# Add to .dockerignore:
# node_modules
# .git
# *.md
```

## Runtime Performance

### Resource Limits
```bash
docker run --memory=512m --cpus=1.5 myapp
```

### Health Checks
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
```

### Logging Configuration
```bash
docker run --log-driver=json-file --log-opt max-size=10m myapp
```

## Storage Optimization

### Use Volumes for Data
```bash
docker run -v data-volume:/app/data myapp
```

### Choose Appropriate Storage Drivers
- overlay2 for most use cases
- devicemapper for older kernels

## Network Performance

### Use Host Networking (When Appropriate)
```bash
docker run --network=host myapp
```

### Optimize DNS Resolution
```bash
docker run --dns=8.8.8.8 myapp
```

## Monitoring and Profiling

### Container Stats
```bash
docker stats
```

### Resource Usage
```bash
docker system df
docker system prune
```

## Best Practices
1. Use appropriate base images
2. Optimize layer ordering
3. Implement proper health checks
4. Monitor resource usage
5. Regular cleanup of unused resources