# Testing Strategies for Containerized Applications

## Container Testing Approaches

### 1. Unit Testing in Containers
```dockerfile
FROM node:18-alpine AS test
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm test

FROM node:18-alpine AS production
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
CMD ["npm", "start"]
```

### 2. Integration Testing
```bash
# Start test environment
docker-compose -f docker-compose.test.yml up -d

# Run integration tests
docker run --network test-network test-runner npm run test:integration

# Cleanup
docker-compose -f docker-compose.test.yml down
```

### 3. Health Check Testing
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1
```

## Test Automation

### GitHub Actions Example
```yaml
name: Container Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Build test image
      run: docker build --target test -t myapp:test .
    
    - name: Run unit tests
      run: docker run --rm myapp:test
    
    - name: Start services for integration tests
      run: docker-compose -f docker-compose.test.yml up -d
    
    - name: Run integration tests
      run: docker run --network test_default --rm myapp:test npm run test:integration
    
    - name: Cleanup
      run: docker-compose -f docker-compose.test.yml down
```

## Security Testing

### Container Scanning
```bash
# Trivy security scanner
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image myapp:latest

# Clair scanner
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  quay.io/coreos/clair:latest
```

### Runtime Security Testing
```bash
# Check for running processes
docker exec container ps aux

# Verify non-root user
docker exec container whoami

# Check file permissions
docker exec container ls -la /app
```

## Performance Testing

### Load Testing with Docker
```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "3000:3000"
  
  loadtest:
    image: loadimpact/k6
    volumes:
      - ./tests:/scripts
    command: run /scripts/load-test.js
    depends_on:
      - app
```

### Resource Monitoring
```bash
# Monitor container resources during tests
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}"
```

## Test Data Management

### Test Database Setup
```yaml
services:
  test-db:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: testdb
      POSTGRES_USER: testuser
      POSTGRES_PASSWORD: testpass
    volumes:
      - ./test-data:/docker-entrypoint-initdb.d
```

### Data Seeding
```bash
# Seed test data
docker exec test-db psql -U testuser -d testdb -f /docker-entrypoint-initdb.d/seed.sql
```

## Best Practices

1. **Separate Test Stages**
   - Use multi-stage builds for test isolation
   - Keep test dependencies separate from production

2. **Test Environment Consistency**
   - Use same base images for dev/test/prod
   - Version pin all dependencies

3. **Automated Testing Pipeline**
   - Run tests on every commit
   - Include security and performance tests

4. **Test Data Management**
   - Use fixtures and factories
   - Clean up test data between runs

5. **Monitoring and Observability**
   - Include health checks
   - Monitor resource usage during tests