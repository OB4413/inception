FROM debian:bullseye

RUN apt update && apt install -y vsftpd

COPY ./vsftpd.conf /etc/vsftpd.conf
COPY ./init.sh /init.sh

RUN chmod +x /init.sh

ENTRYPOINT [ "/init.sh" ]