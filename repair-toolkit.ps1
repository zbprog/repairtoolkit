Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$menuTitle = 'Welcome to the PC repair tool kit! What would you like to do?'

$menuItems = @(
    [PSCustomObject]@{ Id = 1; Label = 'Virus removal'; Script = 'scripts/virus-removal.ps1'; Command = 'Invoke-VirusRemoval' },
    [PSCustomObject]@{ Id = 2; Label = 'Debloat'; Script = 'scripts/debloat.ps1'; Command = 'Invoke-Debloat' },
    [PSCustomObject]@{ Id = 3; Label = 'Diagnostics'; Script = 'scripts/diagnostics.ps1'; Command = 'Invoke-Diagnostics' },
    [PSCustomObject]@{ Id = 4; Label = 'System updates'; Script = 'scripts/system-updates.ps1'; Command = 'Invoke-SystemUpdates' }
)

function Show-Menu {
    param(
        [string]$Title,
        [array]$Items
    )

    Write-Host ''
    Write-Host $Title
    foreach ($item in $Items) {
        Write-Host ("{0}. {1}" -f $item.Id, $item.Label)
    }
    Write-Host '0. Exit'
}

function Invoke-MenuItem {
    param(
        [pscustomobject]$Item
    )

    $scriptPath = Join-Path -Path $PSScriptRoot -ChildPath $Item.Script
    if (-not (Test-Path $scriptPath)) {
        throw "Script not found: $scriptPath"
    }

    . $scriptPath

    $command = Get-Command -Name $Item.Command -ErrorAction Stop
    & $command
}

while ($true) {
    Show-Menu -Title $menuTitle -Items $menuItems
    $selection = Read-Host 'Enter your choice'

    if ($selection -eq '0') {
        Write-Host 'Exiting toolkit.'
        break
    }

    if (-not [int]::TryParse($selection, [ref]$null)) {
        Write-Host 'Please enter a number from the menu.'
        continue
    }

    $menuItem = $menuItems | Where-Object { $_.Id -eq [int]$selection }
    if (-not $menuItem) {
        Write-Host 'That option is not available yet.'
        continue
    }

    try {
        Invoke-MenuItem -Item $menuItem
    } catch {
        Write-Host "Error: $($_.Exception.Message)"
    }

    Write-Host ''
    Read-Host 'Press Enter to return to the menu'
}
