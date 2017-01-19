#!/bin/bash

#
# Prepare docker
#

cat <<EOF > /etc/yum.repos.d/docker.repo
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

yum install docker-engine -y

mkdir -p /etc/systemd/system/docker.service.d

cat <<EOF > /etc/systemd/system/docker.service.d/init.conf
[Service]
EnvironmentFile=-/etc/sysconfig/docker
EnvironmentFile=-/etc/sysconfig/docker-storage
EnvironmentFile=-/etc/sysconfig/docker-network
ExecStart=
ExecStart=/usr/bin/dockerd \$OPTIONS \$DOCKER_STORAGE_OPTIONS \$DOCKER_NETWORK_OPTIONS \$BLOCK_REGISTRY \$INSECURE_REGISTRY
EOF

cat <<EOF > /etc/sysconfig/docker-network
DOCKER_NETWORK_OPTIONS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"
EOF

systemctl daemon-reload
systemctl enable docker.service
systemctl start docker

echo "`facter ipaddress_eth0` elasticentry" >> /etc/hosts

