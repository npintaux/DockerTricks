#!/bin/bash
#
# Stephane Woillez
# swoillez@hotmail.com
#
# Parameters
# DOCKEREE_DOWNLOAD_URL : Base location of the Docker EE packages
# UCP_PUBLIC_FQDN : UCP Public URL
# UCP_ADMIN_USERID : The UCP Admin user ID (also the ID of the Linux Administrator)
# UCP_ADMIN_PASSWORD : Password of the UCP administrator
# DTR_PUBLIC_FQDN : DTR Public URL

echo $(date) " linux-install-dockeree - Starting Script"

eval HOST_IP_ADDRESS=$(ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')

echo "DOCKEREE_DOWNLOAD_URL=$DOCKEREE_DOWNLOAD_URL"
echo "UCP_PUBLIC_FQDN=$UCP_PUBLIC_FQDN"
echo "UCP_ADMIN_USERID=$UCP_ADMIN_USERID"
echo "DTR_PUBLIC_FQDN=$DTR_PUBLIC_FQDN"
echo "HOST_IP_ADDRESS=$HOST_IP_ADDRESS"

install_docker()
{
echo ${DOCKEREE_DOWNLOAD_URL}"/centos" > /etc/yum/vars/dockerurl

yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager \
    --add-repo \
    ${DOCKEREE_DOWNLOAD_URL}/centos/docker-ee.repo

yum makecache fast

yum install -y docker-ee

groupadd docker
usermod -aG docker $USER
usermod -aG docker $UCP_ADMIN_USERID

systemctl enable docker
systemctl start docker
}

install_docker;

echo $(date) " linux-install-dockeree - End of Script"
