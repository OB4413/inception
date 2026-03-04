# USER Documentation (Inception)

This project runs a small web infrastructure using Docker Compose.

## 1) What services are provided?

Your stack provides these containers:

- **NGINX (TLS reverse proxy)**: entrypoint for the platform on port **443**.
- **WordPress (PHP-FPM)**: the main website/CMS.
- **MariaDB**: database used by WordPress.
- **Redis**: object cache used by WordPress (via the `redis-cache` plugin).
- **FTP (vsftpd)**: optional file access to the WordPress files.
- **Adminer**: lightweight database administration web UI.
- **Portainer**: web UI to manage Docker containers.
- **Static website**: small bonus website served by its own NGINX.

## 2) First-time hostname setup (important)

This project is configured for the hostname **`obarais.42.fr`** (see TLS certificate CN and NGINX `server_name`). To access it locally, add it to your hosts file:

```bash
sudo sh -c 'printf "\n127.0.0.1 obarais.42.fr static.obarais.42.fr\n" >> /etc/hosts'
```

If you change the hostname, you must update it in:

- `srcs/.env` (`WP_URL=...`)
- `srcs/requirements/nginx/conf/nginx.conf` (`server_name ...`)

## 3) Start and stop the project

From the repository root:

- Start (build + run):

```bash
make
```

- Stop:

```bash
make down
```

- Rebuild and restart:

```bash
make re
```

- Remove everything (containers/images/volumes + persistent data directory):

```bash
make fclean
```

Note: `make` creates persistent directories under `/home/obarais/data/`.

## 4) Access the website and admin panels

### Main website (WordPress)

- Website: `https://obarais.42.fr/`
- WordPress admin panel: `https://obarais.42.fr/wp-admin/`

Because TLS uses a self-signed certificate, your browser will show a warning. Proceed/accept it.

### Adminer (database UI)

You can access Adminer in two ways:

- Behind the reverse proxy: `https://obarais.42.fr/adminer/`
- Directly via port mapping: `http://localhost:8081/`

Connection info for Adminer:

- **System**: MySQL / MariaDB
- **Server**: `mariadb`
- **Username**: value of `MYSQL_USER` in `srcs/.env`
- **Password**: value of `MYSQL_PASSWORD` in `srcs/.env`
- **Database**: value of `MYSQL_DATABASE` in `srcs/.env`

### Portainer (container management UI)

- Behind the reverse proxy: `https://obarais.42.fr/portainer/`
- Directly via port mapping: `http://localhost:9001/`

First visit: Portainer will ask you to create an admin user/password.

### Static website

- Behind the reverse proxy: `https://obarais.42.fr/static-website/`
- Directly via port mapping: `http://localhost:8080/`

### FTP access (optional)

FTP is exposed on:

- Control port: **21**
- Passive ports: **30000–30009**

Use any FTP client and connect to `localhost` (or your host IP) with the credentials in `srcs/.env`:

- `ftp_user`
- `ftp_pass`

Uploaded/edited files are inside the WordPress shared volume (same files served by NGINX/WordPress).

## 5) Locate and manage credentials

All initial credentials are stored in:

- `srcs/.env`

This file includes:

- MariaDB database name/user/password (`MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`)
- WordPress site URL/title and admin account (`WP_URL`, `WP_TITLE`, `WP_ADMIN_*`)
- Additional WordPress user (`WP_USER*`)
- FTP user/password (`ftp_user`, `ftp_pass`)

### Changing credentials safely

- **WordPress admin password**: can be changed from the WordPress admin UI.
- **Database / FTP credentials**: changing values in `srcs/.env` may require a full reset to re-initialize services using the new credentials.

Typical approaches:

- Restart containers after changing `.env`:

```bash
make re
```

- If you changed DB initialization credentials and want a clean re-init:

```bash
make fclean
make
```

Warning: `make fclean` deletes `/home/obarais/data/` (your persisted database and WordPress files).

## 6) Check that services are running correctly

### Quick checks

- Container status:

```bash
docker ps
```

- Compose status:

```bash
docker-compose -f srcs/docker-compose.yml ps
```

- Logs:

```bash
make logs
```

### Endpoint checks

- NGINX/WordPress (ignore TLS warning with `-k`):

```bash
curl -kI https://obarais.42.fr/
```

- Adminer:

```bash
curl -I http://localhost:8081/
```

- Portainer:

```bash
curl -I http://localhost:9001/
```

If something fails, start with `make logs` and then focus on the failing service logs.
