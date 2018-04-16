FROM ubuntu:17.10
LABEL Description="Fluent Bit Docker image" \
      Vendor="Samsung CNCT" \
      Version="0.4" \
      maintainer="Leah Petersen <leahnpetersen@gmail.com>" \
      maintainer="Jim Conner <snafu.x@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive

ENV FLB_MAJOR 0
ENV FLB_MINOR 12
ENV FLB_PATCH 17
ENV FLB_VERSION $FLB_MAJOR.$FLB_MINOR.$FLB_PATCH

ENV GOPATH /go
ENV GOBIN $GOPATH/bin
ENV PATH $GOBIN:$PATH

USER root

ENV buildDeps='build-essential cmake curl dnsutils git iputils-ping \
              libsystemd-dev make unzip valgrind wget'

RUN apt-get -qq update && \
    apt-get install -y -qq $buildDeps \
      ca-certificates golang sudo --no-install-recommends && \
    apt-get install -y -qq --reinstall lsb-base lsb-release && \
    wget -O "/tmp/fluent-bit-$FLB_VERSION-dev.zip" \
      "https://github.com/fluent/fluent-bit/archive/v$FLB_VERSION.zip" && \
    cd /tmp && \
    unzip "fluent-bit-$FLB_VERSION-dev.zip" && \
    cd "fluent-bit-$FLB_VERSION/build/" && \
    cmake -DFLB_JEMALLOC=On -DFLB_BUFFERING=On \
      -DCMAKE_INSTALL_PREFIX=/fluent-bit/ .. && \
    make && \
    make install && \
    cd / && \
    git clone https://github.com/samsung-cnct/fluent-bit-kafka-output-plugin && \
    cd fluent-bit-kafka-output-plugin && \
    make && \
    apt-get remove --purge --auto-remove -y -qq $buildDeps \
      libxml2 binutils libsqlite3-0 sqlite3 manpages openssl bzip2 && \
    rm -rf /tmp/* /fluent-bit/include /fluent-bit/lib*

COPY fluent-bit.conf /fluent-bit/etc/
COPY parsers.conf /fluent-bit/etc/

CMD ["/fluent-bit/bin/fluent-bit", \
      "-e", "/fluent-bit-kafka-output-plugin/out_kafka.so", \
      "-c", "/fluent-bit/etc/fluent-bit.conf"]
