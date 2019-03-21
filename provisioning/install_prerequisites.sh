#!/bin/bash

source settings.sh

cat >>/etc/hosts<<EOF
${OKD_MASTER_IP} ${OKD_MASTER_HOSTNAME} console console.${DOMAIN}
${OKD_WORKER_NODE_1_IP} ${OKD_WORKER_NODE_1_HOSTNAME}
${OKD_WORKER_NODE_2_IP} ${OKD_WORKER_NODE_2_HOSTNAME}
${OKD_WORKER_NODE_3_IP} ${OKD_WORKER_NODE_3_HOSTNAME}
${OKD_INFRA_NODE_1_IP} ${OKD_INFRA_NODE_1_HOSTNAME}
EOF

# install the following base packages
yum install -y wget
yum install -y envsubst
yum install -y figlet
yum install -y git
yum install -y zile
yum install -y nano
yum install -y net-tools
yum install -y docker-1.13.1
yum install -y bind-utils iptables-services
yum install -y bridge-utils bash-completion
yum install -y kexec-tools
yum install -y sos
yum install -y psacct
yum install -y openssl-devel
yum install -y httpd-tools
yum install -y NetworkManager
yum install -y python-cryptography
yum install -y python2-pip
yum install -y python-devel
yum install -y python-passlib
yum install -y java-1.8.0-openjdk-headless "@Development Tools"
yum install -y epel-release

# Disable the EPEL repository globally so that is not accidentally used during later steps of the installation
sed -i -e "s/^enabled=1/enabled=0/" /etc/yum.repos.d/epel.repo

systemctl | grep "NetworkManager.*running"
if [ $? -eq 1 ]; then
        systemctl start NetworkManager
        systemctl enable NetworkManager
fi

systemctl restart docker
systemctl enable docker