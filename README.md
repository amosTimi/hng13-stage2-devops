# Blue-Green Deployment Demo

This project demonstrates a Blue-Green deployment pattern using Docker, Nginx, health checks, failover, and chaos testing.

---

## Concept
- Blue = Primary deployment
- Green = Secondary deployment
- Only one pool serves traffic through Nginx
- Toggle switches pools during deployment
- Chaos simulator forces failures to validate failover

---

## Requirements
- Docker
- Docker Compose
- Bash (for scripts)

---

## Start the Environment
```bash
./render-and-start.sh
