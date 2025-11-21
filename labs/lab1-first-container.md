# Lab 1: Building Your First Container

## Objective
Learn to create and run your first Docker container from scratch.

## Prerequisites
- Docker installed on your system
- Basic command line knowledge

## Steps

### 1. Create a Simple Application
Create a directory and add a simple HTML file:
```bash
mkdir my-first-app
cd my-first-app
echo '<h1>Hello Docker!</h1>' > index.html
```

### 2. Create a Dockerfile
```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
```

### 3. Build the Image
```bash
docker build -t my-first-app .
```

### 4. Run the Container
```bash
docker run -d -p 8080:80 --name my-app my-first-app
```

### 5. Test Your Application
Open http://localhost:8080 in your browser.

## Exercises
1. Modify the HTML content and rebuild
2. Run multiple containers on different ports
3. Stop and remove containers

## Expected Output
You should see "Hello Docker!" in your browser when accessing localhost:8080.