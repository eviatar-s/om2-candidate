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

function Create-LocalUsers {
    param (
        [Parameter(Mandatory = $true)]
        [PSObject[]]$Users
    )
    
    foreach ($User in $Users) {
        Write-Host "Creating user: $($User.username)"
        $password = ConvertTo-SecureString -String $User.password -AsPlainText -Force
        New-LocalUser -Name $User.username -Password $password -FullName $User.username -Description "Created by script"
        
        Write-Host "Adding user '$($User.username)' to Administrators group"
        Add-LocalGroupMember -Group "Administrators" -Member $User.username
    }
}

$featuresInput = Read-Host "Enter the list of Windows Features to install (comma-separated)"
$featuresArray = $featuresInput -split ",\s*"

$usersInput = Read-Host "Enter the list of local users with their passwords (username:password, comma-separated)"
$userEntries = $usersInput -split ",\s*"

$localUsers = @()
foreach ($entry in $userEntries) {
    $parts = $entry -split ":\s*"
    if ($parts.Length -eq 2) {
        $localUsers += [PSCustomObject]@{
            username = $parts[0]
            password = $parts[1]
        }
    } else {
        Write-Host "Invalid entry format: $entry" -ForegroundColor Red
    }
}

Install-WindowsFeatures -Features $featuresArray

Write-Host "Creating Local Users:"

Create-LocalUsers -Users $localUsers

Write-Host "Script execution has been completed."
