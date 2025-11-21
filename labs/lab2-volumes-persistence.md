# Lab 2: Working with Volumes and Data Persistence

## Objective
Understand how to persist data using Docker volumes.

## Steps

### 1. Create a Named Volume
```bash
docker volume create my-data
```

### 2. Run Container with Volume
```bash
docker run -it -v my-data:/data alpine sh
```

### 3. Create Data in Container
```bash
echo "This data will persist" > /data/persistent.txt
exit
```

### 4. Verify Data Persistence
```bash
docker run -it -v my-data:/data alpine cat /data/persistent.txt
```

### 5. Bind Mount Example
```bash
mkdir host-data
docker run -it -v $(pwd)/host-data:/data alpine sh
echo "Host data" > /data/host-file.txt
exit
ls host-data/
```

## Exercises
1. Create multiple containers sharing the same volume
2. Compare named volumes vs bind mounts
3. Backup and restore volume data

## Key Concepts
- Named volumes are managed by Docker
- Bind mounts link host directories to containers
- Data persists beyond container lifecycle