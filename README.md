# LicenseManagerExperiment

Very crud emulation of the internalization and obfuscation process.

Clone the repo to some folder, in the terminal navigate to this folder, then run
the command

```console
powershell -ExecutionPolicy Bypass -File scripts\buildPackages.ps1 -pathToLocalNugetSource "C:\path\to\your\local\nuget\source"
```

replacing the `"C:\path\to\your\local\nuget\source"` line with the path to the
*local NuGet package source* on your machine. [Link](https://learn.microsoft.com/en-us/nuget/hosting-packages/local-feeds)
to the article on how to set up the local nuget source.

The script `scripts\buildPackages.ps1` does the following:

1. Removes existing NuGet packages from a local NuGet source to ensure a fresh
packaging process.
1. Updates assembly versions in the **Licenses** project files to reflect
desired changes.
1. Builds and packages the **Licenses** project with different versions (`0.0.1`
and `0.0.2`).
1. Clears the NuGet cache to avoid conflicts or outdated dependencies.
1. Restores the solution to resolve any external dependencies.
1. Builds the **IronLib1** and **IronLib2** projects to generate the required
binaries.
1. Performs assembly merging (using *ILRepack*) for **IronLib1** and
**IronLib2** to create single output assemblies.
1. Renames namespaces (using [AssemblyNamespaceEditor](https://github.com/iron-software/IronDevTools/tree/master/AssemblyNamespaceEditor))
in the merged assemblies.
1. Copies the merged and renamed assemblies to their respective build folders.
1. Packages the **IronLib1** and **IronLib2** projects with version `1.0.0`.
1. Clears the NuGet cache again for a clean packaging process.
1. Restores the **LicenseManagerExperiment** *solution* to ensure all dependencies
are properly resolved.

After all that run the **LicenseManagerExperiment** *project* to see the output.
All this doesn't do much, but you can use this to test various scenarios and 
see how the dependencies behave in these scenarios.
