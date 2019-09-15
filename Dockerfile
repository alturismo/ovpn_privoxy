FROM alpine:latest

MAINTAINER alturismo alturismo@gmail.com

# Timezone (TZ) & Add Bash shell & dependancies
RUN apk add --no-cache \
    bash \
    busybox-suid \
    openvpn \
    privoxy \
    runit \
    su-exec \
    tzdata \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# OpenVPN Variables
ENV OPENVPN_FILE=Frankfurt.ovpn \
 LOCAL_NET=192.168.1.0/24 \
 TZ=Europe/Berlin

# Volumes
VOLUME /config

# Add Files
COPY Frankfurt.ovpn /
COPY logindata.conf /
COPY startups /startups

RUN find /startups -name run | xargs chmod u+x

# Add Expose Port
EXPOSE 8080

# Command
CMD ["runsvdir", "/startups"]
