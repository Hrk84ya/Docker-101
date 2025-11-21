# Docker Security Best Practices

## Image Security

### Use Official Base Images
- Always start with official images from Docker Hub
- Regularly update base images to get security patches
- Use specific version tags, avoid `latest`

### Minimize Attack Surface
```dockerfile
# Use minimal base images
FROM alpine:3.18
# Remove unnecessary packages
RUN apk del build-dependencies
```

## Runtime Security

### Run as Non-Root User
```dockerfile
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup
USER appuser
```

### Use Read-Only Filesystems
```bash
docker run --read-only --tmpfs /tmp myapp
```

### Limit Resources
```bash
docker run --memory=512m --cpus=1 myapp
```

## Secrets Management

### Never Hardcode Secrets
```dockerfile
# Bad
ENV API_KEY=secret123

# Good - use runtime environment
ENV API_KEY=""
```

### Use Docker Secrets (Swarm)
```bash
echo "mysecret" | docker secret create api_key -
docker service create --secret api_key myapp
```

## Network Security

### Use Custom Networks
```bash
docker network create --driver bridge isolated-network
```

### Limit Port Exposure
```dockerfile
# Only expose necessary ports
EXPOSE 8080
```

## Scanning and Monitoring

### Scan Images for Vulnerabilities
```bash
docker scan myapp:latest
```

### Use Security Scanning Tools
- Trivy
- Clair
- Snyk

## Key Principles
1. Principle of least privilege
2. Defense in depth
3. Regular updates and patching
4. Continuous monitoring