Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-VirusRemoval {
    $installerUrl = 'https://ninite.com/malwarebytes/ninite.exe'
    $installerPath = Join-Path -Path $env:TEMP -ChildPath 'ninite-malwarebytes.exe'

    Write-Host 'Downloading Malwarebytes via Ninite...'
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing

    Write-Host 'Running Ninite installer...'
    Start-Process -FilePath $installerPath -Wait

    Remove-Item -Path $installerPath -Force
    Write-Host 'Malwarebytes installation complete.'
}
