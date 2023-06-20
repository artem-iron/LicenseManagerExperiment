# TO RUN THIS SCRIPT:
# powershell -ExecutionPolicy Bypass -File scripts\buildPackages.ps1 -pathToLocalNugetSource "C:\iron\tools\NuGet"

param(
    [string]$pathToLocalNugetSource
)

#clear screen
Write-Output "`n####### Clear screen"
& Clear-Host

# clear local nuget source
Write-Output "`n####### Clear local nuget source"
& Remove-Item "$pathToLocalNugetSource\*.nupkg"

# Call updateAssemblyVersion.ps1
Write-Output "`n####### Update assembly versions in Licenses"
& powershell -ExecutionPolicy Bypass -File scripts\updateAssemblyVersion.ps1 -projectPath Licenses\Licenses.csproj -versionToReplace "0.0.1"

# dotnet build
Write-Output "`n####### Build Licenses 0.0.1"
& dotnet build Licenses\Licenses.csproj -c Release

# nuget pack older Licenses
Write-Output "`n####### Pack Licenses 0.0.1"
& nuget pack Licenses\Licenses.nuspec -outputdirectory "$pathToLocalNugetSource" -properties "configuration=release;version=0.0.1"

# Call updateAssemblyVersion.ps1
Write-Output "`n####### Update assembly versions in Licenses"
& powershell -ExecutionPolicy Bypass -File scripts\updateAssemblyVersion.ps1 -projectPath Licenses\Licenses.csproj -versionToReplace "0.0.2"

# dotnet build
Write-Output "`n####### Build Licenses 0.0.2"
& dotnet build Licenses\Licenses.csproj -c Release

# nuget pack older Licenses
Write-Output "`n####### Pack Licenses 0.0.2"
& nuget pack Licenses\Licenses.nuspec -outputdirectory "$pathToLocalNugetSource" -properties "configuration=release;version=0.0.2"

# restore solution
Write-Output "`n####### Clear nuget cache"
& nuget locals all -clear

# restore solution
Write-Output "`n####### Restore LicenseManagerExperiment"
& dotnet restore LicenseManagerExperiment.sln

# dotnet build
Write-Output "`n####### Build IronLib1"
& dotnet build IronLib1\IronLib1.csproj -c Release

# dotnet build
Write-Output "`n####### Build IronLib2"
& dotnet build IronLib2\IronLib2.csproj -c Release

# delete all in temp folder
Write-Output "`n####### Delete all from temp folder"
& Remove-Item "C:\temp\*.*"

# cd to IronLib1\bin\Release\net6.0
Write-Output "`n####### CD into IronLib1 build folder"
Set-Location IronLib1\bin\Release\net6.0

# ILRepack
Write-Output "`n####### ILRepack IronLib1"
& ..\..\..\..\tools\ILRepack.exe /parallel /union /wildcards /xmldocs /out:"C:\temp\IronLib1\IronLib1.dll" /log:"C:\temp\IronLib1.log" "IronLib1.dll" L*.dll

# delete assemblies
Write-Output "`n####### Delete all from build folder"
& Remove-Item *.*

# cd to IronLib2\bin\Release\net6.0
Write-Output "`n####### CD into IronLib2 build folder"
Set-Location ..\..\..\..\IronLib2\bin\Release\net6.0\

# ILRepack
Write-Output "`n####### ILRepack IronLib2"
& ..\..\..\..\tools\ILRepack.exe /parallel /union /wildcards /xmldocs /out:"C:\temp\IronLib2\IronLib2.dll" /log:"C:\temp\IronLib2.log" "IronLib2.dll" L*.dll

# delete assemblies
Write-Output "`n####### Delete all from build folder"
& Remove-Item *.*

# cd to root
Write-Output "`n####### CD into LicenseManagerExperiment root"
Set-Location ..\..\..\..\

# Rename
Write-Output "`n####### Rename namespaces in IronLib1"
& .\tools\ane.exe -p "C:\temp\IronLib1" -hide true "LicensesNamespace" "LicensesNamespaceIronLib1"

# Rename
Write-Output "`n####### Rename namespaces in IronLib2"
& .\tools\ane.exe -p "C:\temp\IronLib2" -hide true "LicensesNamespace" "LicensesNamespaceIronLib2"

# copy IronLib1 assembly
Write-Output "`n####### Copy IronLib1.dll"
Copy-Item "C:\temp\IronLib1\namespace-fix\IronLib1.dll" .\IronLib1\bin\Release\net6.0

# copy IronLib1 assembly
Write-Output "`n####### Copy IronLib2.dll"
Copy-Item "C:\temp\IronLib2\namespace-fix\IronLib2.dll" .\IronLib2\bin\Release\net6.0

# nuget pack IronLib1
Write-Output "`n####### Pack IronLib1 1.0.0"
& nuget pack IronLib1\IronLib1.nuspec -outputdirectory "$pathToLocalNugetSource" -properties "configuration=release;version=1.0.0"

# nuget pack IronLib2
Write-Output "`n####### Pack IronLib2 1.0.0"
& nuget pack IronLib2\IronLib2.nuspec -outputdirectory "$pathToLocalNugetSource" -properties "configuration=release;version=1.0.0"

# restore solution
Write-Output "`n####### Clear nuget cache"
& nuget locals all -clear

# restore solution
Write-Output "`n####### Restore LicenseManagerExperiment"
& dotnet restore LicenseManagerExperiment.sln
