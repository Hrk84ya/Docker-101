# Lab 4: Multi-Stage Build Practice

## Objective
Learn to optimize images using multi-stage builds.

## Steps

### 1. Create a Go Application
```go
// main.go
package main
import "fmt"
func main() {
    fmt.Println("Hello from optimized container!")
}
```

### 2. Single-Stage Dockerfile (Inefficient)
```dockerfile
FROM golang:1.21
WORKDIR /app
COPY . .
RUN go build -o app main.go
CMD ["./app"]
```

### 3. Multi-Stage Dockerfile (Optimized)
```dockerfile
# Build stage
FROM golang:1.21 AS builder
WORKDIR /app
COPY . .
RUN go build -o app main.go

# Runtime stage
FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/app .
CMD ["./app"]
```

### 4. Compare Image Sizes
```bash
docker build -f Dockerfile.single -t app-single .
docker build -f Dockerfile.multi -t app-multi .
docker images | grep app-
```

## Exercises
1. Build both versions and compare sizes
2. Create multi-stage build for Node.js app
3. Use different base images for build vs runtime

## Key Benefits
- Smaller final images
- Improved security (fewer tools in production)
- Faster deployment and startup times