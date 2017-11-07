---
title: Easy Off/On Line Docker Install on Windows
description: Script to deploy and configure the Docker Engine on Windows Server 2016. It installs the necessary files, by downloading them from the web OR using a zip file stored locally
keywords: docker, datacenter, install, orchestration, management, azure, swarm, microsoft, windows
---

* Docker is not preinstalled on Windows Server 2016. Before installing it, you need to install the container service, and then download the docker package, install it and create the windows service.

* The DockerWindowsOfflineInstall folder contains a simple Powershell script to install and configure Docker on a Windows Server. It can be used Online, or in an Offline mode by download the package prior installing and put it in the right folder for the script to find it

* As described in the script, the 1.12 docker package for Windows can be downloaded from the following address : https://download.docker.com/components/engine/windows-server/17.03/docker-17.03.0-ee.zip (as of April 2017)

* You can modify the script to download the latest stable version of the Docker Engine for Windows, by getting the ZIP URL for this page : https://docs.docker.com/docker-ee-for-windows/install/ (Look in the section "Using a script to install Docker EE" in the code of step 1 after the invoke-webrequest)

* If you prefer, you can download the latest beta release of the Docker engine from the following address : https://master.dockerproject.org/

* In the script, the $zipLocation variable indicates where to find the docker package. You have to put the zip file at the location pointed by $zipLocation to enable Offline install

* You need to execute the script "as administrator". If you launch it interactively, do not use the x86 version of PowerShell or PowerShell ISE.
