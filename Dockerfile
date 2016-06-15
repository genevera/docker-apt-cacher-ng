FROM ubuntu:xenial
MAINTAINER Genevera <genevera.codes@gmail.com> (@genevera)

ENV APT_CACHER_NG_VERSION=0.9.1 \
    APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    APT_CACHER_NG_LOG_DIR=/var/log/apt-cacher-ng \
    APT_CACHER_NG_USER=apt-cacher-ng \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    vim.tiny wget sudo net-tools ca-certificates unzip \
    apt-cacher-ng=${APT_CACHER_NG_VERSION}* \
    && rm -rf /var/lib/apt/lists/* \
    && ln -fs /dev/stdout /var/log/apt-cacher-ng/apt-cacher.log \
    && ln -fs /dev/stderr /var/log/apt-cacher-ng/apt-cacher.err

ADD acng.conf /etc/apt-cacher-ng/acng.conf
EXPOSE 3142/tcp
VOLUME ["${APT_CACHER_NG_CACHE_DIR}"]

CMD ["/usr/sbin/apt-cacher-ng", "-c", "/etc/apt-cacher-ng"]
