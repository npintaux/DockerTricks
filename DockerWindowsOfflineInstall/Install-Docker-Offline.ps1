# -----------------------------------------------------------------------------------------------------
# Powershell Script to install Docker on Windows Server 2016, with OffLine option
# If you have issues running the script, you need to authorize the execution of scripts by running the following command :
# To authorize the script to run : Set-ExecutionPolicy Unrestricted
# -----------------------------------------------------------------------------------------------------
# Stephane Woillez - stephw@docker.com
# -----------------------------------------------------------------------------------------------------

Clear-Host

# zipLocation is where we expect to find the zip file containing the Docker files for Offline Install

$zipLocation = "$env:TEMP\docker.zip"

# Step 0 : Verify that we are on Windows Server 2016

$windowsversion = (Get-WmiObject -class Win32_OperatingSystem).Caption
Write-Host $windowsversion
If ($windowsversion -Like '*Windows Server 2016*')
{
Write-Host "Windows Server Docker Installer : You are on Windows Server 2016"
}
else
{
Write-Host "Windows Server Docker Installer : You are not on the right version of windows"
Write-Host "Windows Server Docker Installer : This script installs Docker on Windows Server 2016"
Return
}

# Step 1 : Install the Windows Server Container Feature

$Name = "Containers"
$Service = Get-Service -display $Name -ErrorAction SilentlyContinue
If (-Not $Service)
{
Write-Host "Windows Server Docker Installer :" $Name "is not installed on this computer. Installing..."
Install-WindowsFeature Containers
}
Else
{
Write-Host "Windows Server Docker Installer : " $Name " is installed."
}

# Normally, we should reboot now, but adding Docker before reboot allow faster installation
# Step 2 : Download the Docker package from the Docker website if it does not exist locally

$Name = "docker"
$Service = Get-Service -display $Name -ErrorAction SilentlyContinue
If (-Not $Service)
{
Write-Host "Windows Server Docker Installer :" $Name "is not installed on this computer. Installing..."
Write-Host "Windows Server Docker Installer : Checking if the Docker Package exists locally"

$FileExists = Test-Path $zipLocation

If ($FileExists -eq $True)
{
Write-Host "Windows Server Docker Installer : Package Exists, skipping download"
}
else
{
Write-Host "Windows Server Docker Installer : Package not Found, downloading"
Invoke-WebRequest "https://download.docker.com/components/engine/windows-server/17.03/docker-17.03.0-ee.zip" -OutFile $zipLocation -UseBasicParsing
}

# Step 3 : Expand the Docker Archive

Write-Host "Windows Server Docker Installer : Expanding the Docker package"
Expand-Archive -Path $zipLocation -DestinationPath $env:ProgramFiles

# Step 4 : Modify the env path to allow access to docker.exe

Write-Host "Windows Server Docker Installer : Modifying the PATH variable"
$env:path += ";c:\program files\docker"
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Docker", [EnvironmentVariableTarget]::Machine)

# Step 5 : Registering Docker as a Windows Service to allow auto start at boot

Write-Host "Windows Server Docker Installer : Registering Docker as a Windows Service"
dockerd.exe --register-service
}
Else
{
Write-Host "Windows Server Docker Installer :" $Name "is already installed."
}

#Start-Service docker

# Step 6 : Restart the server

Write-Host "Windows Server Docker Installer : Restart the server for services to start"
#Restart-Computer -Force
