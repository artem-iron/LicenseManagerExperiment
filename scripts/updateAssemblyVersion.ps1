param(
    [string]$projectPath,
    [string]$versionToReplace
)

# Read the content of the project file
$content = Get-Content -Path $projectPath -Raw

# Replace the version number in the package reference
$updatedContent = [regex]::replace($content, "(?<=<AssemblyVersion>)([^`"]+)(?=`</AssemblyVersion>)", $versionToReplace)

# Save the updated content back to the project file
Set-Content -Path $projectPath -Value $updatedContent