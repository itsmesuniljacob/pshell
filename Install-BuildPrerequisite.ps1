$currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
$testadmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
$testadmin
if ($testadmin -eq $false) {
Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
exit $LASTEXITCODE
}

Install-PackageProvider -Name "NuGet" -Force
Install-Module -Name "PSScriptAnalyzer" -Force -SkipPublisherCheck
Install-Module -Name "Pester" -Force -SkipPublisherCheck
