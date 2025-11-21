# Lab 3: Container Networking

## Objective
Learn how containers communicate with each other.

## Steps

### 1. Create a Custom Network
```bash
docker network create my-network
```

### 2. Run Database Container
```bash
docker run -d --name db --network my-network \
  -e POSTGRES_PASSWORD=password postgres:alpine
```

### 3. Run Application Container
```bash
docker run -d --name app --network my-network \
  -p 3000:3000 -e DATABASE_URL=postgresql://postgres:password@db:5432/postgres \
  your-app-image
```

### 4. Test Communication
```bash
docker exec app ping db
```

### 5. Inspect Network
```bash
docker network inspect my-network
```

## Exercises
1. Create containers on different networks
2. Connect a container to multiple networks
3. Test port mapping and exposure

## Key Concepts
- Containers on same network can communicate by name
- Bridge networks provide isolation
- Port mapping exposes services to host