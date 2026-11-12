[windows]
set shell := ["powershell.exe", "-NoLogo", "-Command"]

default:
  @just -l

hello:
  @Write-Host "Hello, world!"

[windows]
bootstrap: aqua-installer

[windows]
[script("powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File")]
aqua-installer:
  if (-not (Get-Command aqua -ErrorAction SilentlyContinue)) {
    Write-Host "[+] Instalando 'aqua'..." -ForegroundColor Green
    winget install aquaproj.aqua --silent --accept-package-agreements --accept-source-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
  } else {
    Write-Host "[*] 'aqua' ya está instalado." -ForegroundColor Cyan
  }

[windows]
scoop:
  @Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  @Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

