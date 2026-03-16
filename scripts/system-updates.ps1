Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-SystemUpdates {
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Host 'Installing PSWindowsUpdate module...'
        Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
    }
    Import-Module PSWindowsUpdate

    Write-Host 'Checking for pending updates (including optional)...'
    $updates = Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -IgnoreReboot

    if (-not $updates) {
        Write-Host 'No pending updates found.'
        return
    }

    Write-Host "$($updates.Count) update(s) found. Installing..."
    Install-WindowsUpdate -MicrosoftUpdate -AcceptAll -AutoReboot -IgnoreReboot:$false
}
