. "../windows/Dotfiles.ps1"

function Install-Extensions {

    $extensionsFilePath = Join-Path -Path $PSScriptRoot -ChildPath "extensions.json"

    if (Test-Path -Path $extensionsFilePath) {
        $extensions = (Get-Content -Path $extensionsFilePath -Raw | ConvertFrom-Json).recommendations
        foreach ($extension in $extensions) {
            # Write-Host $extension
            code --install-extension "$extension"
        }        
    }
}


$Dotfiles = Get-Dotfiles $PSScriptRoot | Where-Object { $_.Name -ne "extensions.json" }

Write-Host $Dotfiles
$VSCodePackage = [PSCustomObject]@{
    Name   = 'vscode'
    Params = @("/NoDesktopIcon", "/NoQuicklaunchIcon", "/NoContextMenuFiles", "/NoContextMenuFolders")
}

$Packages = @($VSCodePackage)

$DestinationDirectory = Join-Path -Path $env:APPDATA -ChildPath "Code" | Join-Path -ChildPath "User";

Install-Packages -Packages $Packages -UninstallPackages $UninstallPackages
refreshenv;
Install-Extensions
Move-Dotfiles -Dotfiles $Dotfiles -DestinationDirectory $DestinationDirectory
Write-Host "VSCode was successfully configured." -ForegroundColor Greesn;