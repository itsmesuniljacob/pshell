param([switch]$AppVeyor=$false)
 $ErrorActionPreference="Stop"
function Confirm-AdministratorContext
{
    $administrator = [Security.Principal.WindowsBuiltInRole] "Administrator"
    $identity = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    $identity.IsInRole($administrator)
}
 function Use-AdministratorContext
{
    if (-not (Confirm-AdministratorContext))
    {
        $arguments = "& '" + $myinvocation.mycommand.definition + "'"
        Start-Process powershell -Verb runAs -ArgumentList $arguments
        Break
    }
}
 function Install-BuildPrerequisite
{
    foreach ($arg in $args)
    {
        Write-Output "Checking build prerequisite module $arg"
        if (-not (Get-Module -Name $arg))
        {
            Write-Output "Requesting elevated permissions to install build prerequisite module $arg"
            Use-AdministratorContext
            Write-Output "Installing build prerequisite module $arg"
            Install-Module -Name $arg -Force -SkipPublisherCheck
        }
        else
        {
            Write-Output "Confirmed already installed build prerequisite module $arg"
        }
    }
}
 function Invoke-StaticAnalysis
{
    $result = Invoke-ScriptAnalyzer -Path "." -Recurse
@@ -44,14 +15,11 @@ function Invoke-StaticAnalysis
    {
        throw "Build failed. Found $($result.Length) static analysis issue(s)"
    }
    else
    {
        Write-Output "Static analysis findings clean"
    }
    Write-Output "Static analysis findings clean"
}
function Invoke-Build
{
    if ($AppVeyor)
    if ($AppVeyor)
    {
        Write-Output "Building in AppVeyor build CI server context"
    }
@@ -80,7 +48,41 @@ function Invoke-Test
    }
}
 function Confirm-Prerequisite
{
    (
        (Get-Module -Name PSScriptAnalyzer).Length *
        (Get-Module -Name Pester).Length *
        (Get-PackageProvider -Name Nuget).Length
    ) -ne 0
}
 function Install-Prerequisite
{
    if ((Confirm-Prerequisite))
    {
        return
    }
     Write-Output "Installing build prerequisites"
    $code = ".\Install-BuildPrerequisites.ps1"
    if (Confirm-AdministratorContext)
    {
        Invoke-Command "$code"
    }
    else
    {
        Start-Process -FilePath powershell.exe -ArgumentList $code -verb RunAs
    }
     if (-not (Confirm-Prerequisite))
    {
        throw "Build Failed. Installation of build prerequisites failed."
    }
}
 Write-Output "Build starting"
Install-BuildPrerequisite "PSScriptAnalyzer" "Pester"
#Install-Prerequisite
Write-Output "Building"
Invoke-Build
Write-Output "Build complete" 
