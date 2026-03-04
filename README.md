*This project has been created as part of the 42 curriculum by obarais.*

# Inception

## Description

Inception is a system administration project based on Docker and container orchestration.

The goal of this project is to design and deploy a small secure infrastructure composed of multiple services running in isolated containers. Each service runs independently while communicating with others through a dedicated Docker network.

The infrastructure includes:

- NGINX (reverse proxy with TLS)
- WordPress (PHP-FPM)
- MariaDB (database)
- Redis (object cache)
- FTP server
- Adminer
- Portainer
- A static website

Each service is built from a custom Dockerfile and orchestrated using Docker Compose. The project demonstrates how containers work internally using Linux namespaces and cgroups, how services communicate over Docker networks, and how persistent data is managed with volumes.

### Use of Docker

Docker is used to containerize each service separately. Instead of running everything directly on the host system, each component runs in an isolated container.

Docker relies on:

- **Namespaces** to isolate processes (PID, network, mount, etc.).
- **Cgroups** to control resource usage (CPU, memory).
- **Layered images** to build lightweight and reusable environments.

Docker Compose is used to define and manage the multi-container architecture.

### Main Design Choices

- One service per container.
- Only NGINX exposes port 443 to the host.
- Internal communication through a custom bridge network.
- Data persistence using Docker volumes.
- Reverse proxy architecture for routing traffic.
- Separation between configuration and runtime data.

---

## Technical Comparisons

### Virtual Machines vs Docker

Virtual Machines:
- Require a full operating system per instance.
- Use hardware-level virtualization.
- Higher resource consumption.
- Slower startup time.

Docker:
- Shares the host kernel.
- Uses OS-level isolation (namespaces and cgroups).
- Lightweight and fast.
- Optimized for microservices.

Docker provides process isolation instead of full system virtualization.

---

### Secrets vs Environment Variables

Environment Variables:
- Easy to configure.
- Commonly used for credentials.
- Visible via container inspection.

Secrets:
- More secure.
- Not stored inside images.
- Better suited for production environments.

Secrets reduce the risk of exposing sensitive data.

---

### Docker Network vs Host Network

Bridge Network:
- Default Docker mode.
- Isolated environment.
- Internal DNS resolution.
- Containers communicate using service names.

Host Network:
- Shares host networking stack.
- Less isolation.
- Not recommended for secure infrastructures.

The project uses a bridge network for security and internal service communication.

---

### Docker Volumes vs Bind Mounts

Docker Volumes:
- Managed by Docker.
- Stored internally under `/var/lib/docker/volumes`.
- Portable and clean.
- Recommended for persistent production data.

Bind Mounts:
- Map specific host directories.
- Useful for development.
- Less portable.

This project uses Docker-managed volumes for data persistence.

---

## Instructions

Clone the repository:

```bash
git clone <repository_url>
cd inception
```

Start the services:

```bash
make
```

Stop the services:

```bash
make down
```

Rebuild everything:

```bash
make re
```

Remove containers and volumes and images:

```bash
make fclean
```

Once running, the main website can be accessed at:

```bash
https://localhost
```

## Resources

The following resources were consulted during the development of this project:

- Official Docker documentation

- Docker Compose documentation

- NGINX documentation

- MariaDB documentation

- WordPress documentation

- Linux namespaces and cgroups documentation

## Use of AI

AI tools were used to:

- Clarify Docker internal concepts.

- Debug networking and volume configuration issues.

- Improve documentation clarity and structure.

All implementation and configuration decisions were manually designed and understood.