# Developer Documentation (Inception)

This document explains how to set up, build, run, and maintain the project as a developer.

## 1) Prerequisites

### Required software

- **Docker Engine** (daemon running)
- **Docker Compose** CLI
  - This repository’s `Makefile` uses the `docker-compose` command (Compose v1 style).
  - If your system only has `docker compose` (Compose v2 plugin), either install `docker-compose` or adapt the `Makefile`.
- **GNU Make**

### Required permissions / host requirements

- Ability to bind to ports **443**, **21**, and **30000–30009** on the host.
- Ability to create and write persistent directories under:
  - `/home/kali/data/mariadb`
  - `/home/kali/data/wordpress`
  - `/home/kali/data/portainer`

## 2) Configuration and “secrets”

### Environment file

The project loads variables from:

- `srcs/.env`

It is used by multiple services via `env_file` in `srcs/docker-compose.yml`.

Variables include (non-exhaustive):

- MariaDB: `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`
- WordPress: `DB_HOST`, `WP_URL`, `WP_TITLE`, `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`, `WP_ADMIN_EMAIL`, `WP_USER*`
- FTP: `ftp_user`, `ftp_pass`

Security note: in a real project you typically do **not** commit secrets. For this educational project it may be acceptable, but treat `srcs/.env` as sensitive.

### Hostnames and TLS

NGINX is configured for the hostname `obarais.42.fr`:

- NGINX `server_name` is set in `srcs/requirements/nginx/conf/nginx.conf`.
- A self-signed certificate is generated inside the NGINX image with CN `obarais.42.fr` (see `srcs/requirements/nginx/Dockerfile`).
- WordPress installs itself using `WP_URL` from `srcs/.env`.

For local development, map the hostname(s) to `127.0.0.1`:

```bash
sudo sh -c 'printf "\n127.0.0.1 obarais.42.fr static.obarais.42.fr\n" >> /etc/hosts'
```

If you change hostnames, update both the NGINX config and `WP_URL`.

## 3) Build and launch (Makefile + Docker Compose)

### Makefile entry points

From repo root:

- Build images + start containers:

```bash
make
```

- Build only:

```bash
make build
```

- Stop containers:

```bash
make down
```

- Restart (down then up):

```bash
make re
```

- View logs:

```bash
make logs
```

- Full cleanup:

```bash
make fclean
```

`make fclean` will:

- remove Docker images
- prune volumes
- run `docker-compose down -v`
- delete `/home/kali/data`

### Direct Compose usage

All compose operations target `srcs/docker-compose.yml`:

```bash
docker-compose -f srcs/docker-compose.yml ps
```

Useful commands:

- Follow logs for one service:

```bash
docker-compose -f srcs/docker-compose.yml logs -f nginx
```

- Open a shell in a running container:

```bash
docker-compose -f srcs/docker-compose.yml exec wordpress sh
```

- Restart one service:

```bash
docker-compose -f srcs/docker-compose.yml restart nginx
```

## 4) Where data is stored (persistence)

This project persists data using **bind-mounted host directories** (declared as volumes in Compose).

### Persistent paths on the host

- MariaDB data directory:
  - Host: `/home/kali/data/mariadb`
  - Container: `/var/lib/mysql`

- WordPress files (site + uploads + generated config):
  - Host: `/home/kali/data/wordpress`
  - Container: `/var/www/html`

- Portainer data:
  - Host: `/home/kali/data/portainer`
  - Container: `/data`

These are defined in `srcs/docker-compose.yml` under `volumes:` using `driver_opts` with `type: none` and `o: bind`.

### What persists across restarts?

- Container restarts and `make down` do **not** remove the host directories.
- WordPress installation state (files and config) persists in `/home/kali/data/wordpress`.
- MariaDB tables persist in `/home/kali/data/mariadb`.

### How to reset to a clean state

To fully reset (delete database + WordPress files):

```bash
make fclean
make
```

Be careful: this deletes `/home/kali/data`.

## 5) Service internals (where to look when debugging)

- WordPress bootstrap logic: `srcs/requirements/wordpress/tools/init.sh`
  - waits for DB, downloads WP, creates `wp-config.php`, installs WP, enables Redis cache.

- MariaDB initialization: `srcs/requirements/mariadb/tools/init.sh`
  - initializes datadir on first run, creates the DB/user from `.env`.

- Reverse proxy routes: `srcs/requirements/nginx/conf/nginx.conf`
  - `/adminer/` → Adminer
  - `/portainer/` → Portainer
  - `/static-website/` → bonus website

If WordPress keeps reinstalling or credentials don’t match, check whether `/home/kali/data/*` already contains old state.
