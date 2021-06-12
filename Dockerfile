FROM ephemerecreative/coder-base:latest

USER root

RUN apt-get update && apt-get install -y \
    docker.io

ARG REGION='America'
ARG CITY='Vancouver'

RUN echo 'tzdata tzdata/Areas select $REGION' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/Europe select $CITY' | debconf-set-selections && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y tzdata

RUN apt-get install -y systemd

# Enables Docker starting with systemd
RUN systemctl enable docker

# use systemd as the init
RUN ln -s /lib/systemd/systemd /sbin/init

USER coder