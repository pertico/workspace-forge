# bootstrap.ps1 - Bootstrap completo para Windows en workspace-forge
$ErrorActionPreference = "Stop"

Write-Host "[+] Iniciando bootstrap de workspace-forge en Windows..." -ForegroundColor Green

# ==========================================
# PASO 0: Comprobar e instalar Winget si falta
# ==========================================
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Winget no está disponible en el sistema. Iniciando instalación de Winget..." -ForegroundColor Yellow
    
    try {
        # Obtener la última release oficial de winget-cli desde GitHub
        $releasesUrl = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
        $response = Invoke-RestMethod -Uri $releasesUrl -UseBasicParsing
        $asset = $response.assets | Where-Object { $_.name -like "*.msixbundle" } | Select-Object -First 1
        
        if ($asset) {
            $downloadUrl = $asset.browser_download_url
            $outputPath = "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
            
            Write-Host "[+] Descargando Winget desde GitHub..." -ForegroundColor Cyan
            Invoke-WebRequest -Uri $downloadUrl -OutFile $outputPath
            
            Write-Host "[+] Instalando App Installer (Winget)..." -ForegroundColor Cyan
            Add-AppxPackage -Path $outputPath
            
            # Limpiar archivo temporal
            Remove-Item $outputPath -ErrorAction SilentlyContinue
            Write-Host "[✔] Winget instalado correctamente." -ForegroundColor Green
        } else {
            throw "No se encontró el paquete .msixbundle en las releases de GitHub."
        }
    } catch {
        Write-Error "No se pudo instalar Winget automáticamente: $_"
        Write-Host "Por favor, instala 'App Installer' manualmente desde la Microsoft Store o la web de Microsoft." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "[*] Winget ya está disponible." -ForegroundColor Cyan
}

# Asegurar que el PATH se refresca tras la instalación de winget
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

# Instalar 'scoop (Scoop - The Command-Line Installer for Windows)'
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "[+] Instalando 'scoop'..." -ForegroundColor Green
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    scoop bucket add extras
} else {
    Write-Host "[*] 'scoop' ya está instalado." -ForegroundColor Cyan
}

Write-Host "[✔] Bootstrap en Windows completado con éxito." -ForegroundColor Green