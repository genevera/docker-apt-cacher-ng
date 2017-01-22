FROM sameersbn/ubuntu:14.04.20170110
MAINTAINER sameer@damagehead.com

ENV APT_CACHER_NG_VERSION=0.9.3 \
    APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng \
    APT_CACHER_NG_USER=apt-cacher-ng \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-cacher-ng=${APT_CACHER_NG_VERSION}* \
 && sed 's/# ForeGround: 0/ForeGround: 1/' -i /etc/apt-cacher-ng/acng.conf \
 && sed 's/# PassThroughPattern:.*this would allow.*/PassThroughPattern: .* #/' -i /etc/apt-cacher-ng/acng.conf \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

ADD acng.conf /etc/apt-cacher-ng/acng.conf
ADD backends_docker /etc/apt-cacher-ng/backends_docker
EXPOSE 3142/tcp
VOLUME ["${APT_CACHER_NG_CACHE_DIR}"]

CMD ["/usr/sbin/apt-cacher-ng", "-c", "/etc/apt-cacher-ng"]
