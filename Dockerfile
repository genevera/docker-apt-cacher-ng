FROM quay.io/genevera/ubuntu:xenial-daily
MAINTAINER Genevera <genevera.codes@gmail.com> (@genevera)

ARG APT_CACHER_NG_CACHE_DIR
ARG APT_CACHER_NG_LOG_DIR
ARG APT_CACHER_NG_USER

ENV APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng \
    APT_CACHER_NG_USER=apt-cacher-ng \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y apt-cacher-ng \
 && sed 's/# ForeGround: 0/ForeGround: 1/' -i /etc/apt-cacher-ng/acng.conf \
 && sed 's/# PassThroughPattern:.*this would allow.*/PassThroughPattern: .* #/' -i /etc/apt-cacher-ng/acng.conf \
 && rm -rf /var/lib/apt/lists/* \
 && ln -fs /dev/stdout /var/log/apt-cacher-ng/apt-cacher.log \
 && ln -fs /dev/stderr /var/log/apt-cacher-ng/apt-cacher.err 

COPY acng.conf /etc/apt-cacher-ng/acng.conf
COPY backends_docker /etc/apt-cacher-ng/backends_docker
VOLUME ["${APT_CACHER_NG_CACHE_DIR}"]

EXPOSE 3142/tcp

CMD ["/usr/sbin/apt-cacher-ng", "-c", "/etc/apt-cacher-ng"]
