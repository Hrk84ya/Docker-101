# Docker Swarm Basics

## Introduction
Docker Swarm is Docker's native clustering and orchestration solution for managing multiple Docker hosts.

## Setting Up a Swarm

### Initialize Swarm
```bash
docker swarm init --advertise-addr <MANAGER-IP>
```

### Join Workers
```bash
docker swarm join --token <TOKEN> <MANAGER-IP>:2377
```

### View Nodes
```bash
docker node ls
```

## Services

### Create a Service
```bash
docker service create --name web --publish 8080:80 --replicas 3 nginx
```

### Scale Services
```bash
docker service scale web=5
```

### Update Services
```bash
docker service update --image nginx:alpine web
```

## Stack Deployment

### Docker Compose for Swarm
```yaml
version: '3.8'
services:
  web:
    image: nginx
    ports:
      - "80:80"
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
```

### Deploy Stack
```bash
docker stack deploy -c docker-compose.yml myapp
```

## Load Balancing

### Ingress Network
- Automatic load balancing across replicas
- External access through published ports

### Internal Load Balancing
```bash
docker service create --name db --network backend postgres
```

## High Availability

### Manager Nodes
- Odd number of managers (3, 5, 7)
- Raft consensus algorithm
- Automatic leader election

### Worker Nodes
- Execute tasks assigned by managers
- Can be promoted to managers

## Secrets Management

### Create Secret
```bash
echo "mypassword" | docker secret create db_password -
```

### Use in Service
```bash
docker service create --secret db_password --name app myapp
```

## Monitoring

### Service Status
```bash
docker service ls
docker service ps web
```

### Node Status
```bash
docker node inspect self
```

## Best Practices
1. Use odd number of manager nodes
2. Separate manager and worker roles in production
3. Implement proper health checks
4. Use secrets for sensitive data
5. Monitor cluster health regularly