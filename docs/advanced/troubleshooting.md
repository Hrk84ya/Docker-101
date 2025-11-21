# Docker Troubleshooting Guide

## Common Issues and Solutions

### Container Won't Start

#### Check Logs
```bash
docker logs <container-id>
docker logs --follow <container-id>
```

#### Inspect Container
```bash
docker inspect <container-id>
```

#### Debug with Shell
```bash
docker run -it --entrypoint /bin/sh <image>
```

### Image Build Failures

#### Build Context Too Large
```bash
# Add to .dockerignore
node_modules/
.git/
*.log
```

#### Layer Caching Issues
```bash
docker build --no-cache -t myapp .
```

#### Permission Denied
```dockerfile
# Fix file permissions
COPY --chown=user:group . /app
```

### Network Issues

#### Container Can't Connect
```bash
# Check network configuration
docker network ls
docker network inspect bridge

# Test connectivity
docker exec container1 ping container2
```

#### Port Already in Use
```bash
# Find process using port
lsof -i :8080
# Kill process or use different port
docker run -p 8081:80 myapp
```

### Storage Issues

#### Disk Space Full
```bash
# Clean up unused resources
docker system prune -a
docker volume prune
docker image prune -a
```

#### Volume Mount Issues
```bash
# Check volume exists
docker volume ls
# Inspect volume
docker volume inspect myvolume
```

### Performance Issues

#### High Memory Usage
```bash
# Check container stats
docker stats
# Set memory limits
docker run --memory=512m myapp
```

#### Slow Build Times
```dockerfile
# Optimize layer order
COPY package.json .
RUN npm install
COPY . .
```

## Debugging Tools

### Container Inspection
```bash
# Process list
docker exec <container> ps aux

# File system
docker exec <container> ls -la /app

# Environment variables
docker exec <container> env
```

### System Information
```bash
docker system info
docker system df
docker version
```

### Log Analysis
```bash
# Container logs
docker logs --timestamps <container>

# System logs (Linux)
journalctl -u docker.service
```

## Best Practices for Debugging

1. **Use Health Checks**
```dockerfile
HEALTHCHECK --interval=30s CMD curl -f http://localhost:8080/health
```

2. **Implement Proper Logging**
```javascript
// Log to stdout/stderr
console.log('Application started');
console.error('Error occurred');
```

3. **Use Multi-Stage Builds for Debug**
```dockerfile
FROM node:18 AS debug
RUN npm install -g nodemon
CMD ["nodemon", "server.js"]

FROM node:18-alpine AS production
CMD ["node", "server.js"]
```

4. **Monitor Resource Usage**
```bash
docker stats --no-stream
```

## Emergency Procedures

### Stop All Containers
```bash
docker stop $(docker ps -q)
```

### Remove All Containers
```bash
docker rm $(docker ps -aq)
```

### Clean Everything
```bash
docker system prune -a --volumes
```

### Backup Important Data
```bash
docker run --rm -v myvolume:/data -v $(pwd):/backup alpine tar czf /backup/backup.tar.gz /data
```