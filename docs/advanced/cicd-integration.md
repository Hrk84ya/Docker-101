# CI/CD Integration with Docker

## GitHub Actions

### Build and Push Workflow
```yaml
name: Docker Build and Push

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2
    
    - name: Login to DockerHub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKERHUB_USERNAME }}
        password: ${{ secrets.DOCKERHUB_TOKEN }}
    
    - name: Build and push
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: user/app:latest
```

## Jenkins Pipeline

### Jenkinsfile
```groovy
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                script {
                    docker.build("myapp:${env.BUILD_ID}")
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    docker.image("myapp:${env.BUILD_ID}").inside {
                        sh 'npm test'
                    }
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    docker.image("myapp:${env.BUILD_ID}").push()
                }
            }
        }
    }
}
```

## Best Practices

### Multi-Stage Builds for CI
```dockerfile
FROM node:18 AS test
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

### Security Scanning
```yaml
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: 'myapp:latest'
    format: 'sarif'
    output: 'trivy-results.sarif'
```

### Image Tagging Strategy
- Use semantic versioning
- Tag with commit SHA
- Separate tags for environments

### Environment-Specific Configs
```bash
# Development
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# Production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
```

## Deployment Strategies

### Blue-Green Deployment
1. Deploy new version alongside current
2. Switch traffic to new version
3. Remove old version

### Rolling Updates
```bash
docker service update --image myapp:v2 --update-parallelism 1 --update-delay 10s myapp
```

### Canary Deployment
- Deploy to subset of instances
- Monitor metrics
- Gradually increase traffic