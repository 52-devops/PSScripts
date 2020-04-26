# Script:	CiscoAnyConnect_User_Preferences_XML.ps1
# Purpose:  Create a preferences.xml file in localappdata folder, overwrites existing file. 
# Author:   52-DevOps
# Email:	fiftytwo.devops@gmail.com
# Date:     April 23, 2020
# Comments: Populate the default user, run under current logged on user. 
$transcriptfilename = Get-Date -Format MMMddyyyyhhmmss
Start-Transcript "c:\temp\$transcriptfilename CiscoAnyConnect_User_Preferences_xml.log" -IncludeInvocationHeader
Param($Path="$env:LOCALAPPDATA\cisco\cisco anyconnect secure mobility client\preferences.xml")
[xml]$Doc = New-Object System.Xml.XmlDocument
#create the XML File header
$dec = $Doc.CreateXmlDeclaration("1.0","UTF-8",$null)
$doc.AppendChild($dec) | Out-Null
#create a node
$root = $doc.CreateNode("element","AnyConnectPreferences",$null)
#create an element
 $e = $doc.CreateElement("DefaultUser")
 #assign a value
 $e.InnerText = $env:USERNAME
 $root.AppendChild($e) | Out-Null
 $doc.AppendChild($root) | Out-Null
$doc.save($Path)
Stop-Transcript
