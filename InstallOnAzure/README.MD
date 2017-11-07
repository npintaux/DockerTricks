---
title: Docker Enterprise Azure Installer
description: All necessary scripts and ARM templates to deploy a fully functional Docker Enterprise cluster on Microsoft Azure. The ARM template deploys 1 UCP controller, 1 DTR server, up to 5 linux workers, and up to 5 windows workers. Everything is deployed and configured automatically. The end of the deployment is a fully functional cluster.
keywords: docker, datacenter, install, orchestration, management, azure, swarm, microsoft, windows
---
# Introduction

* This is an Azure ARM template to automatically deploy a Docker Enterprise cluster on Azure. The cluster comes out fully configured and running.

* It is intended to be used for demo/poc purpose. This is not a production ready installation as UCP and DTR are not deployed in High Availability mode.

* The installation uses underlying CentOS Linux servers, as this is the most widely deployed Linux distribution. Docker Enterprise can also be deployed on top of RHEL, Ubuntu, OracleLinux and Suse Enterprise.

# How to use it

* The easiest way yo deploy this template, once the custom scripts are available and accessibe somewhere, is to use the Azure portal and search for "Template Deployment" in the MarketPlace. Run it and select "Build your own template in the editor" ; then replace the example template proposed by the content of StephW-DockerInfra-Azure-Share.json. Click "Save" then fill in a Resource Group name, and the necessary parameters.

# Azure Custom Scripts

* The Azure template uses custom scripts to configure the Virtual Machines once they are deployed. The custom scripts are located in the CustomScripts directory of this GitHub Repo.

* These custom scripts HAVE to be accessible somewhere on the internet for Azure to deploy them on VMs. The obvious location to store them is an Azure storage account. Create one, then create a container (The Azure Storage container, not the Docker one :-) ) and copy the content of the CustomScripts directory into that container.

* Custom scripts are the .sh files and the .ps1 file. You also have to copy the .rpm file which installs jq to allow Linux machines to parse some Docker answers. In addition, for french Mac users willing to access the Windows servers from their Mac using Microsoft Remote Desktop, there is a .zip file used by the .ps1 script to install the "french mac" additional keyboard layout. You can remove it or replace it with your own keyboard layout.

* If you need to debug Azure custom scripts, you should check this page : https://docs.microsoft.com/en-us/azure/virtual-machines/linux/extensions-customscript
