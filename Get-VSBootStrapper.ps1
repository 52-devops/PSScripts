# Script: Get-VSBootStrapper.ps1

# Purpose:  This script will download latest version of the vs_installer from https://visualstudio.microsoft.com and update installed versions of Visual Studio.

# Author:   52-DevOps

# Email:	fiftytwo.devops@gmail.com

# Date:     October 2020

# Comments: Auto-Download Visual Studio Installer and update Visual Studio 2017/2019 Community, Professional and Enterprise editions

# Notes:    C:\TEMP folder is expected to exist. This folder is used to save the vs_installer, vs_webpage and the transcript for this powershell script.

#           Helps keep Visual Studio updated with latest versions.

#           The installer will download needed files from Microsoft websites.

#           https://developercommunity.visualstudio.com/content/problem/307261/unattend-self-update-of-vs-installer.html

$transcriptfilename = Get-Date -Format MMMddyyyyhhmmss

Start-Transcript "c:\temp\update visual studio $transcriptfilename.log" -IncludeInvocationHeader

#Hash Table for Internal Version Numbers of Visual Studio

$VSRelease = @{"2017"="15";"2019"="16"}

#Hash Table for Visual Studio Editions

$VSEditions = @("Enterprise","Professional","Community")

#Path to save web page with download links from visualstudio.microsoft.com

$VSURLPath="C:\TEMP\"

 

foreach ($release in $VSRelease.Keys){

  Foreach ($edition in $VSEditions){

  $VSInstallPath="C:\Program Files (x86)\Microsoft Visual Studio\$release\$edition"

    $VS_Edition_TXT = "VS_"+$edition+"_"+$release+".txt"

  if(Test-Path ($VSInstallPath)){

    Write-Host Found Visual Studio $edition $release in $VSInstallPath -BackgroundColor Blue -ForegroundColor White

      if($release.Contains('2017'))

      {

        $releasenumber=15

        $VS_Edition_EXE = "VS_"+$edition+"_"+"2017.exe"

        Write-Host "Getting Download URL for Visual Studio $edition 2017. Saving to ....."  $VSURLPath$VS_Edition_TXT -BackgroundColor Gray -ForegroundColor Black

      }

    else 

      {

        $releasenumber=16

        $VS_Edition_EXE = "VS_"+$edition+"_"+"2019.exe"

        Write-Host "Getting Download URL for Visual Studio $edition 2019. Saving to ....."  $VSURLPath$VS_Edition_TXT -BackgroundColor Gray -ForegroundColor Black

      }

    Invoke-WebRequest -uri "https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=$edition&rel=$releasenumber" -OutFile $VSURLPath$VS_Edition_TXT

    Write-Host Extracting Download URL from the $VSURLPath$VS_Edition_TXT -BackgroundColor Blue -ForegroundColor White

    $findurl=Select-String  $VSURLPath$VS_Edition_TXT -Pattern downloadURL -SimpleMatch

    $downloadurl = $findurl.Line -split ":" ,2

    $VS_Edition_URL = $downloadurl.Item(1)

    $VS_Edition_URLFINAL = $VS_Edition_URL.Replace("'","")

    Write-Host Downloading $VS_Edition_EXE to $VSURLPath from $VS_Edition_URLFINAL -ForegroundColor Gray

    Write-Host "Update Visual Studio Installer" -ForegroundColor Cyan

    INVOKE-WEBREQUEST -uri $VS_Edition_URLFINAL -Method GET -UseBasicParsing -OutFile $VSURLPath$VS_Edition_EXE

    $vsCommunitySetupPath = $VSURLPath+$VS_Edition_EXE;

    Write-Host "Launching $vsCommunitySetupPath to update the VS Installer" -ForegroundColor Gray

    $installerUpdateProcess = Start-Process `

        -FilePath $vsCommunitySetupPath `

        -Wait `

        -PassThru `

        -ArgumentList @(

                        "--update",

                        "--quiet",

                        "--wait");

        $installerUpdateProcess.WaitForExit();

    Write-Host "$VS_Edition_EXE exited with code: $($installerUpdateProcess.ExitCode)" -ForegroundColor Gray

    Write-Host "Update Visual Studio" $edition $release -ForegroundColor Cyan

  $VSInstallPath="""C:\Program Files (x86)\Microsoft Visual Studio\$release\$edition"""

    #Start Process to Update Visual Studio

    Write-Host                         "--installpath '$VSInstallPath'" -ForegroundColor Cyan

    $vsUpdateProcess = Start-Process `

        -FilePath "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" `

        -Wait `

        -PassThru `

        -ArgumentList @("update",

                        "--norestart",

                        "--passive",

                        "--force",

                        "--channelUri https://aka.ms/vs/$releasenumber/release/channel",

                        "--installpath $VSInstallPath");

    $vsUpdateProcess.WaitForExit();

    Write-Host "vs_installer.exe exited with code: $($vsUpdateProcess.ExitCode)" -ForegroundColor Gray

    }

    else

    {  

    Write-Host Visual Studio $edition $release Not Found -BackgroundColor Black -ForegroundColor Red}

    }

}

Stop-Transcript

 
