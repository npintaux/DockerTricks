---
title: Docker Enterprise Azure Installer
description: All necessary scripts and ARM templates to deploy a fully functional Docker Enterprise cluster on Microsoft Azure. The ARM template deploys 1 UCP controller, 1 DTR server, up to 5 linux workers, and up to 5 windows workers. Everything is deployed and configured automatically. The end of the deployment is a fully functional cluster.
keywords: docker, datacenter, install, orchestration, management, azure, swarm, microsoft, windows
---
# Introduction

* This is an Azure ARM template to automatically deploy a Docker Enterprise cluster on Azure. The cluster comes out fully configured and running.

* It is intended to be used for demo/poc purpose. This is not a production ready installation as UCP and DTR are not deployed in High Availability mode.

* The installation uses underlying CentOS Linux servers, as this is the most widely deployed Linux distribution. Docker Enterprise can also be deployed on top of RHEL, Ubuntu, OracleLinux and Suse Enterprise.

# Azure Custom Scripts

* The Azure template uses custom scripts to configure the Virtual Machines once they are deployed. The custom scripts are located in the CustomScripts directory of this GitHub Repo.

* These custom scripts HAVE to be accessible somewhere on the internet for Azure to deploy them on VMs. The obvious location to store them is an Azure storage account. Create one, then create a container (The Azure Storage container, not the Docker one :-) ) and copy the content of the CustomScripts directory into that container.

* Custom scripts are the .sh files and the .ps1 file. You also have to copy the .rpm file which installs jq to allow Linux machines to parse some Docker answers. In addition, for french Mac users willing to access the Windows servers from their Mac using Microsoft Remote Desktop, there is a .zip file used by the .ps1 script to install the "french mac" additional keyboard layout. You can remove it or replace it with your own keyboard layout.

* If you need to debug Azure custom scripts, you should check this page : https://docs.microsoft.com/en-us/azure/virtual-machines/linux/extensions-customscript

# Step-by-Step installation process

## Prerequisites
* In order to facilitate the upload of the Azure Custom Scripts in Azure storage, it is recommended to use the "Azure Storage Explorer" tool: https://azure.microsoft.com/en-us/features/storage-explorer/

* To install Docker EE, you will need a link to the download image as well as a license key. These can be found on the Docker web site once you sign up for a 1-month trial. In order to do so, follow the instructions below:

    * Navigate to Docker trial page: https://store.docker.com/editions/enterprise/docker-ee-trial. Click on the "Start 1-Month Trial" button.
    ![Screen capture](images/DockerEE_Start_a_trial.png?raw=true)

    * Follow the registration process to enroll in the trial. The following page should then appear.
    ![Screen capture](images/DockerEE_Download_license_and_url.png?raw=true)

    * Download the license key, and copy the software download URL for later use.

* Create a storage account to store the custom scripts
    * Go to the Azure market place, and search for 'storage'. Select "storage account - blob, file, table, queue".
    ![Screen capture](images/DockerEE_create_storage_account.png?raw=true)

    * Provide a unique name (in lower case) and select/create a resource group. You can keep the other settings as default. Click on "Create".

    * Once your storage account is created, click on "Blobs".
    ![Screen capture](images/DockerEE_create_container.png?raw=true)

    * Create a container and name it "dockerinstall" (all lower case).
    ![Screen capture](images/DockerEE_dockerinstall.png?raw=true)

* Use "Azure Storage Explorer" tool to upload the custom scripts (located in the CustomScripts folder in this repository) in the "dockerinstall" container.

* Use "Azure Storage Explorer" tool to upload the Docker EE License Key to the same container. This key is necessary for the installation to succeed.

* Use "Azure Storage Explorer" tool to retrieve the Primary Key of your newly created storage account. You will need this key to fill the template information.

* create a storage account to store the logs and diagnostics. Mark down the name of this storage account as you will need it to modify your template.

* Last, you will need to provision a SSH key corresponding to a specific DNS name and admin. To do this, open a Linux shell, and type the following command:

    ssh-keygen -t rsa -b 2048 -C "<admin name>@<dnsname>"

    Mark down the admin name, as well as the DNS name you have chosen.
    Copy the public key by retrieving the content of ~/.ssh/id_rsa.pub.

## Installing Docker EE in Azure
* The easiest way yo deploy this template, once the custom scripts are available and accessibe somewhere, is to use the Azure portal and search for "Template Deployment" in the MarketPlace. Click on "Create".
![Screen capture](images/DockerEE_Template_Deployment.png?raw=true)

Then select "Build your own template".
![Screen capture](images/DockerEE_Build_Template.png?raw=true)

* Click on "Load File", and select the "StephW-DockerInfra-Azure-Share.json". In the editor, you will need to replace the "automateclouddiag" string (CTRL+F to search in the editor) with the name of the storage account your created for logs and diagnostics.
![Screen capture](images/DockerEE_Modify_Template.png?raw=true)

* Click on "Save". You should obtain the following screen.
![Screen capture](images/DockerEE_Customized_Template.png?raw=true)

    * __Cluster Public IP Address label__: name of the DNS you previously used to create your SSH public key
    * __Linux and Windows worker count__: select from 1 to 5 nodes. Please note that you may exceed your subscription quota if your account is not sufficiently provisioned.
    * __Manager and Worker VM Sizes__: select the appropriate sizes for your VMs. Please note that you may exceed your subscription quota if your account is not sufficiently provisioned.
    * __Admin UserId/Password__: need to match the admin and password you provided when creating the SSH key.
    * __Docker EE Download URL__: this URL is the one you copied from the Docker EE Trial registration page.
    * __SSH Public Key__: the public key you generated in the Prerequisites section.
    * __Custom Script Account name__: the name of the storage account you created to store the Custom Scripts. Please note that this is the name of the storage account, and not the name of the container ('dockerinstall').
    * __Custom Script Account Key__: the primary key of the storage account.

* Check the "I agree to the terms and conditions" checkbox, and click on Purchase.