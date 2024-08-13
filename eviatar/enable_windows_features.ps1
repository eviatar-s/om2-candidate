function Install-WindowsFeatures {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$Features
    )
    
    foreach ($Feature in $Features) {
        Write-Host "Installing feature: $Feature"
        Install-WindowsFeature -Name $Feature -IncludeAllSubFeature -IncludeManagementTools -Verbose
    }
}

function Rename-Server {
    param (
        [Parameter(Mandatory = $true)]
        [string]$NewName
    )

    Write-Host "Renaming server to: $NewName"
    Rename-Computer -NewName $NewName -Force
}

$features = Read-Host "Enter the list of Windows Features to install (comma-separated)"
$newName = Read-Host "Enter the new server name"

$featuresArray = $features -split ","

Install-WindowsFeatures -Features $featuresArray

Rename-Server -NewName $newName

Write-Host "Restarting the server..."
Restart-Computer -Force
