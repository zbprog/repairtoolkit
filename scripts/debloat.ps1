Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-Debloat {
    $script = Join-Path -Path $PSScriptRoot -ChildPath 'raphire-debloat'
    & $script
}
