function Confirm-AdministratorContext
{
    $administrator = [Security.Principal.WindowsBuiltInRole] "Administrator"
    $identity = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    $identity.IsInRole($administrator)
}

Install-PackageProvider -Name "NuGet" -Force
Install-Module -Name "PSScriptAnalyzer" -Force -SkipPublisherCheck
Install-Module -Name "Pester" -Force -SkipPublisherCheck
