# TO RUN THIS SCRIPT:
# powershell -ExecutionPolicy Bypass -File scripts\buildPackages.ps1 -pathToLocalNugetSource "C:\iron\tools\NuGet"

param(
    [string]$pathToLocalNugetSource
)

# Clear the screen
Write-Output "`n####### Clearing the screen"
& Clear-Host

# Clear the local NuGet source
Write-Output "`n####### Clearing the local NuGet source"
& Remove-Item "$pathToLocalNugetSource\*.nupkg"

# Call updateAssemblyVersion.ps1
Write-Output "`n####### Updating assembly versions in Licenses"
& powershell -ExecutionPolicy Bypass -File scripts\updateAssemblyVersion.ps1 -projectPath Licenses\Licenses.csproj -versionToReplace "0.0.1"

# Build Licenses 0.0.1
Write-Output "`n####### Building Licenses 0.0.1"
& dotnet build Licenses\Licenses.csproj -c Release

# Pack Licenses 0.0.1
Write-Output "`n####### Packing Licenses 0.0.1"
& nuget pack Licenses\Licenses.nuspec -outputdirectory "$pathToLocalNugetSource" -properties "configuration=release;version=0.0.1"

# Call updateAssemblyVersion.ps1
Write-Output "`n####### Updating assembly versions in Licenses"
& powershell -ExecutionPolicy Bypass -File scripts\updateAssemblyVersion.ps1 -projectPath Licenses\Licenses.csproj -versionToReplace "0.0.2"

# Build Licenses 0.0.2
Write-Output "`n####### Building Licenses 0.0.2"
& dotnet build Licenses\Licenses.csproj -c Release

# Pack Licenses 0.0.2
Write-Output "`n####### Packing Licenses 0.0.2"
& nuget pack Licenses\Licenses.nuspec -outputdirectory "$pathToLocalNugetSource" -properties "configuration=release;version=0.0.2"

# Clear the NuGet cache
Write-Output "`n####### Clearing the NuGet cache"
& nuget locals all -clear

# Restore LicenseManagerExperiment
Write-Output "`n####### Restoring LicenseManagerExperiment"
& dotnet restore LicenseManagerExperiment.sln

# Build IronLib1
Write-Output "`n####### Building IronLib1"
& dotnet build IronLib1\IronLib1.csproj -c Release

# Build IronLib2
Write-Output "`n####### Building IronLib2"
& dotnet build IronLib2\IronLib2.csproj -c Release

# Delete all files from the temp folder
Write-Output "`n####### Deleting all files from the temp folder"
& Remove-Item "C:\temp\*.*"

# Change directory to IronLib1\bin\Release\net6.0
Write-Output "`n####### Changing directory to IronLib1 build folder"
& Set-Location IronLib1\bin\Release\net6.0

# ILRepack IronLib1
Write-Output "`n####### ILRepacking IronLib1"
& ..\..\..\..\tools\ILRepack.exe /parallel /union /wildcards /xmldocs /out:"C:\temp\IronLib1\IronLib1.dll" /log:"C:\temp\IronLib1.log" "IronLib1.dll" *.dll

# Delete assemblies from the build folder
Write-Output "`n####### Deleting all files from the build folder"
& Remove-Item *.*

# Change directory to IronLib2\bin\Release\net6.0
Write-Output "`n####### Changing directory to IronLib2 build folder"
& Set-Location ..\..\..\..\IronLib2\bin\Release\net6.0\

# ILRepack IronLib2
Write-Output "`n####### ILRepacking IronLib2"
& ..\..\..\..\tools\ILRepack.exe /parallel /union /wildcards /xmldocs /out:"C:\temp\IronLib2\IronLib2.dll" /log:"C:\temp\IronLib2.log" "IronLib2.dll" *.dll

# Delete assemblies from the build folder
Write-Output "`n####### Deleting all files from the build folder"
& Remove-Item *.*

# Change directory to the root of LicenseManagerExperiment
Write-Output "`n####### Changing directory to the root of LicenseManagerExperiment"
& Set-Location ..\..\..\..\

# Rename namespaces in IronLib1
Write-Output "`n####### Renaming namespaces in IronLib1"
& .\tools\ane.exe -p "C:\temp\IronLib1" -hide true "LicensesNamespace" "LicensesNamespaceIronLib1"

# Rename namespaces in IronLib2
Write-Output "`n####### Renaming namespaces in IronLib2"
& .\tools\ane.exe -p "C:\temp\IronLib2" -hide true "LicensesNamespace" "LicensesNamespaceIronLib2"

# Copy IronLib1 assembly
Write-Output "`n####### Copying IronLib1.dll"
& Copy-Item "C:\temp\IronLib1\namespace-fix\IronLib1.dll" .\IronLib1\bin\Release\net6.0

# Copy IronLib2 assembly
Write-Output "`n####### Copying IronLib2.dll"
& Copy-Item "C:\temp\IronLib2\namespace-fix\IronLib2.dll" .\IronLib2\bin\Release\net6.0

# Pack IronLib1
Write-Output "`n####### Packing IronLib1 1.0.0"
& nuget pack IronLib1\IronLib1.nuspec -outputdirectory "$pathToLocalNugetSource" -properties "configuration=release;version=1.0.0"

# Pack IronLib2
Write-Output "`n####### Packing IronLib2 2.0.0"
& nuget pack IronLib2\IronLib2.nuspec -outputdirectory "$pathToLocalNugetSource" -properties "configuration=release;version=2.0.0"

# Clear the NuGet cache
Write-Output "`n####### Clearing the NuGet cache"
& nuget locals all -clear

# Restore LicenseManagerExperiment
Write-Output "`n####### Restoring LicenseManagerExperiment"
& dotnet restore LicenseManagerExperiment.sln
