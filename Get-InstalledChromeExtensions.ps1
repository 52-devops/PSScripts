# Script:	Get-InstalledChromeExtensions.ps1
# Purpose:  This script lists installed Google Chrome Extensions for a user.
# Author:   
# Email:	
# Date:     June 17, 2020
# Comments: Internal extensions by Google are excluded from the CSV
# Notes:    This script can be run for a logged-on user to list installed extensions.
$targetdir = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Extensions" 
$extensions = Get-ChildItem $targetdir 
$obj = ""
Foreach($ext in $extensions)
{ Set-Location $targetdir\$ext -ErrorAction SilentlyContinue 
$folders = (Get-ChildItem).Name 
    $obj = New-Object System.Object 
Foreach($folder in $folders)
    { Set-Location $folder -ErrorAction SilentlyContinue 
    $json = Get-Content manifest.json -Raw | ConvertFrom-Json 
    $obj | Add-Member -MemberType NoteProperty -Name Name -Value $json.name -Force
    $obj | Add-Member -MemberType NoteProperty -Name Version -Value $json.version -Force
    $obj | Add-Member -MemberType NoteProperty -Name ID -Value $ext -Force
if ($obj.Name.Contains("__MSG_")){
    Write-Host $obj.ID $obj.Name $obj.Version
}else{
    Export-Csv -InputObject $obj -Append -Force -NoTypeInformation -Path c:\temp\chromeext.csv
} 
}
}

