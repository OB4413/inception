FROM debian:bullseye

RUN apt update && \
    apt install -y wget ca-certificates && \
    mkdir -p /opt/portainer && \
    wget https://github.com/portainer/portainer/releases/download/2.20.3/portainer-2.20.3-linux-amd64.tar.gz && \
    tar -xzf portainer-2.20.3-linux-amd64.tar.gz -C /opt/portainer --strip-components=1 && \
    chmod +x /opt/portainer/portainer

EXPOSE 9000

CMD ["/opt/portainer/portainer", "--bind", "0.0.0.0:9000", "--data", "/data"]