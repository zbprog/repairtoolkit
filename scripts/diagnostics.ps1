Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-Diagnostics {
    $apiUrl = 'https://api.github.com/repos/openhardwaremonitor/openhardwaremonitor/releases/latest'
    $extractPath = Join-Path -Path $env:TEMP -ChildPath 'OpenHardwareMonitor'

    Write-Host 'Fetching latest OpenHardwareMonitor release...'
    $release = Invoke-RestMethod -Uri $apiUrl -UseBasicParsing
    $asset = $release.assets | Where-Object { $_.name -like '*.zip' } | Select-Object -First 1

    if (-not $asset) {
        Write-Error 'Could not find OpenHardwareMonitor ZIP in the latest release.'
        return
    }

    $zipPath = Join-Path -Path $env:TEMP -ChildPath $asset.name

    Write-Host "Downloading $($asset.name)..."
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zipPath -UseBasicParsing

    Write-Host 'Extracting...'
    if (Test-Path $extractPath) {
        Remove-Item -Path $extractPath -Recurse -Force
    }
    Expand-Archive -Path $zipPath -DestinationPath $extractPath
    Remove-Item -Path $zipPath -Force

    $exe = Get-ChildItem -Path $extractPath -Filter 'OpenHardwareMonitor.exe' -Recurse | Select-Object -First 1
    if (-not $exe) {
        Write-Error 'OpenHardwareMonitor.exe not found after extraction.'
        return
    }

    Write-Host 'Launching OpenHardwareMonitor...'
    Start-Process -FilePath $exe.FullName
}
