FROM debian:jessie
LABEL maintainer ikesato76@gmail.com

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends --no-install-suggests bind9
COPY files/bind /etc/bind
EXPOSE 53

RUN apt-get clean && \
    apt-get autoremove --purge -y && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* \
    /usr/share/man/??_* \
    /usr/share/man/??

CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]
