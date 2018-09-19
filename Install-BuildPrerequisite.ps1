# param([switch]$Elevated)
# $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
# $testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
#
# function Test-Admin {
#   $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
#   $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
# }
#
# if ($testadmin -eq $false) {
#   Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
#   exit $LASTEXITCODE
# }

#Requires -RunAsAdministrator
#Or
#
# if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
# {
#   "Running as admin in $PSScriptRoot"
# }
# else
# {
#   "NOT running as an admin!"
#   Start-Process powershell -WorkingDirectory $PSScriptRoot -Verb runAs -ArgumentList "-noprofile -noexit -file $PSCommandPath"
#   return "Script re-started with admin privileges in another shell. This one will now exit."
# }
#
# "Doing this only as admin."
Write-Host "Checking for elevation... "
$CurrentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
if (($CurrentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) -eq $false)
{
	$ArgumentList = "-noprofile -noexit -file `"{0}`" -Path `"$Path`" -MaxStage $MaxStage"
	If ($ValidateOnly) { $ArgumentList = $ArgumentList + " -ValidateOnly" }
	If ($SkipValidation) { $ArgumentList = $ArgumentList + " -SkipValidation $SkipValidation" }
	If ($Mode) { $ArgumentList = $ArgumentList + " -Mode $Mode" }
	Write-Host "elevating"
	Start-Process powershell.exe -Verb RunAs -ArgumentList ($ArgumentList -f ($myinvocation.MyCommand.Definition)) -Wait
	Exit
}
write-host "in admin mode.."
#Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.201 - Scope CurrentUser -Force
Install-Module -Name "PSScriptAnalyzer" -Scope CurrentUser -Force -SkipPublisherCheck
Install-Module -Name "Pester" -Scope CurrentUser -Force -SkipPublisherCheck
