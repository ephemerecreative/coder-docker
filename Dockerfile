FROM ephemerecreative/coder-base:v0.0.7

USER root

RUN mv /coder/configure /coder/coder-base-configure
COPY scripts/configure /coder/configure

RUN apt-get update && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

RUN  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

RUN sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

RUN sudo chmod +x /usr/local/bin/docker-compose

ARG REGION='America'
ARG CITY='Vancouver'

RUN echo 'tzdata tzdata/Areas select $REGION' | debconf-set-selections && \
    echo 'tzdata tzdata/Zones/Europe select $CITY' | debconf-set-selections && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y tzdata

RUN apt-get install -y systemd

# Enables Docker starting with systemd
RUN systemctl enable docker

# use systemd as the init
RUN ln -f -s /lib/systemd/systemd /sbin/init

RUN usermod -aG docker coder

RUN newgrp docker

USER coder

RUN sudo /home/linuxbrew/.linuxbrew/bin/brew install kubectl kustomize tilt-dev/tap/tilt tilt-dev/tap/ctlptl kind