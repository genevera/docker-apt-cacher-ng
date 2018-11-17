FROM ubuntu:xenial
MAINTAINER Genevera <genevera.codes@gmail.com> (@genevera)

ENV APT_CACHER_NG_CACHE_DIR=/var/cache/apt-cacher-ng \
    DEBIAN_FRONTEND=noninteractive \
    APT_CACHER_NG_URL=http://ftp.debian.org/debian/pool/main/a/apt-cacher-ng/apt-cacher-ng_3.2-1_amd64.deb \
    LIBSSL_11_URL=http://mirrors.edge.kernel.org/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4.1_amd64.deb

RUN apt-get update \
    && apt-get upgrade --with-new-pkgs --yes \ 
    && apt-get install -y --no-install-recommends \
    curl libwrap0 \
    && curl -SsL "${LIBSSL_11_URL}" > /tmp/libssl.deb \
    && curl -SsL "${APT_CACHER_NG_URL}" > /tmp/acng.deb \
    && dpkg -i /tmp/libssl.deb \
    && dpkg -i /tmp/acng.deb \
    && rm -f /tmp/*.deb \
    && apt-get remove -y curl \ 
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && ln -fs /dev/stdout /var/log/apt-cacher-ng/apt-cacher.log \
    && ln -fs /dev/stderr /var/log/apt-cacher-ng/apt-cacher.err

ADD acng.conf /etc/apt-cacher-ng/acng.conf
EXPOSE 3142/tcp
VOLUME ["${APT_CACHER_NG_CACHE_DIR}"]

CMD ["/usr/sbin/apt-cacher-ng", "-c", "/etc/apt-cacher-ng"]
