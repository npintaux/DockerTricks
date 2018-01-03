#!/bin/bash
#
# Stephane Woillez
# swoillez@hotmail.com
#
# Parameters required for the script
#
# UCP_PUBLIC_FQDN : UCP Public URL
# UCP_ADMIN_USERID : The UCP Admin user ID (also the ID of the Linux Administrator)
# UCP_ADMIN_PASSWORD : Password of the UCP administrator
# DTR_PUBLIC_FQDN : DTR Public URL

echo $(date) " linux-install-ucp - Starting Script"

LICENSE="$PWD/docker_subscription.lic"

echo "UCP_PUBLIC_FQDN=$UCP_PUBLIC_FQDN"
echo "UCP_ADMIN_USERID=$UCP_ADMIN_USERID"
echo "UCP_ADMIN_PASSWORD=<Not Copied for obvious security reasons"
echo "DDC_LICENSE=$LICENSE"
echo "AZURE_STORAGE_ACCOUNT=$AZURE_STORAGE_ACCOUNT_NAME"
echo "AZURE_STORAGE_ACCOUNT_KEY=$AZURE_STORAGE_ACCOUNT_KEY"


#eval HOST_IP_ADDRESS=$(ifconfig eth0 | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*')
#echo "HOST_IP_ADDRESS=$HOST_IP_ADDRESS"

# Split the UCP FQDN et get the SAN and the port

UCP_SAN=${UCP_PUBLIC_FQDN%%:*}
UCP_PORT=${UCP_PUBLIC_FQDN##*:}

if [ "$UCP_PORT" = "$UCP_PUBLIC_FQDN" ]
   then
     UCP_PORT="443"
fi

echo "UCP_SAN=$UCP_SAN"
echo "UCP_PORT=$UCP_PORT"

# Install UCP

docker run --rm -i --name ucp \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $LICENSE:/docker_subscription.lic \
    docker/ucp install \
    --controller-port $UCP_PORT \
    --host-address eth0 \
    --san $CLUSTER_SAN \
    --san $UCP_SAN \
    --admin-username $UCP_ADMIN_USERID \
    --admin-password $UCP_ADMIN_PASSWORD \
    --debug

# Add the Azure Storage Volume Driver

docker plugin install --alias cloudstor:azure \
  --grant-all-permissions docker4x/cloudstor:17.06.1-ce-azure1  \
  CLOUD_PLATFORM=AZURE \
  AZURE_STORAGE_ACCOUNT_KEY=$AZURE_STORAGE_ACCOUNT_KEY \
  AZURE_STORAGE_ACCOUNT=$AZURE_STORAGE_ACCOUNT_NAME \
  AZURE_STORAGE_ENDPOINT="core.windows.net" \
  DEBUG=1

echo $(date) " linux-install-ucp - End of Script"
