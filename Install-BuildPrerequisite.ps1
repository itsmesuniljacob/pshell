Register-PSRepository -Name "PSGallery" –SourceLocation "https://www.powershellgallery.com/api/v2/" -InstallationPolicy Trusted
Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.201 -Scope CurrentUser -Force
Install-Module -Name "PSScriptAnalyzer" -Scope CurrentUser -Force -SkipPublisherCheck
Install-Module -Name "Pester" -Scope CurrentUser -Force -SkipPublisherCheck
