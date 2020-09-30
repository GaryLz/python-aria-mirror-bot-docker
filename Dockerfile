# Source: System
FROM centos:latest

LABEL maintainer="GaryLz"

# Current Working Directory
WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app 

# Disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

# FIX DOCKER-DNS-BROKEN

# Install Requirements and Dependencies for Running
RUN yum update -y && yum install epel-release -y && yum update -y && \
	yum install -y wget curl p7zip p7zip-plugins aria2 pv jq python3-lxml python3-pip git ca-certificates

# Failed-Package: ffmpeg, locales, mega-deps
RUN dnf install epel-release dnf-utils -y && \
	yum-config-manager --set-enabled PowerTools && \
	yum-config-manager --add-repo=https://negativo17.org/repos/epel-multimedia.repo
RUN dnf install ffmpeg -y

RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN curl -sL -o /var/cache/apt/archives/MEGAcmd.rpm https://mega.nz/linux/MEGAsync/CentOS_8/x86_64/megacmd-1.3.0-3.1.x86_64.rpm
RUN rpm -i /var/cache/apt/archives/MEGAcmd.deb
# COPY specific files to the Container
COPY requirements.txt .
COPY extract /usr/local/bin
RUN chmod +x /usr/local/bin/extract
RUN pip3 install --no-cache-dir -r requirements.txt

# LANG Setting
#RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

COPY . .
COPY netrc /root/.netrc
RUN chmod +x aria.sh

CMD ["bash", "start.sh"]
