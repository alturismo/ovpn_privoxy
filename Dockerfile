FROM alpine:latest AS builder

LABEL org.opencontainers.image.authors="alturismo@gmail.com"

# Set Variables
ARG MICROSOCKS_V=1.0.3

# Add compile dependencies for Microsocks
RUN apk update && \
    apk add --no-cache make gcc musl-dev

# Download Microsocks and compile it
RUN wget -O /tmp/microsocks_v${MICROSOCKS_V}.tar.gz https://github.com/rofl0r/microsocks/archive/refs/tags/v${MICROSOCKS_V}.tar.gz && \
    tar -C /tmp -xzvf /tmp/microsocks_v${MICROSOCKS_V}.tar.gz && \
    cd /tmp/microsocks-${MICROSOCKS_V} && \
    make -j $(nproc -all) && \
    DESTDIR=/tmp/copy make install

FROM alpine:latest

LABEL org.opencontainers.image.authors="alturismo@gmail.com"

# Add Packages
RUN apk update && \
    apk add --no-cache ca-certificates privoxy openvpn runit

# Copy binaries from build stage to main container
COPY --from=builder /tmp/copy/ /

# Timezone (TZ)
ENV TZ=Europe/Berlin
RUN apk update && apk add --no-cache tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Fix for missing gcc libraries
RUN mkdir /lib64 && \
    ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# Add Bash shell & dependancies
RUN apk add --no-cache bash busybox-suid su-exec

# OpenVPN Variables
ENV OPENVPN_FILE=Frankfurt.ovpn \
 LOCAL_NET=192.168.1.0/24

# Volumes
VOLUME /config

# Add Files
COPY Frankfurt.ovpn /
COPY logindata.conf /
COPY startups /startups

RUN find /startups -name run | xargs chmod u+x

# Add Expose Port
EXPOSE 8080 1080

# Command
CMD ["runsvdir", "/startups"]
