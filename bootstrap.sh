#!/usr/bin/env bash
set -e

# Colores para output limpio
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[+] Iniciando bootstrap de workspace-forge...${NC}"

# 1. Instalar 'just' si no está presente
if ! command -v just &> /dev/null; then
    echo -e "${GREEN}[+] Instalando 'just' (task runner)...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin
else
    echo "[*] 'just' ya está instalado."
fi

# 2. Instalar 'aqua' (gestor declarativo de binarios CLI) si no está presente
if ! command -v aqua &> /dev/null; then
    echo -e "${GREEN}[+] Instalando 'aqua'...${NC}"
    # Aqua provee un script de instalación oficial ultrarrápido
    curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.5/aqua-installer | bash
    echo "451028d56959cc738564885b1dbebc2691ea038ffde04e2472e4d486a3591146  aqua-installer" | sha256sum -c -
    # Mover aqua al path global si se instaló localmente
    if [ -f "$HOME/.local/bin/aqua" ]; then
        sudo mv "$HOME/.local/bin/aqua" /usr/local/bin/aqua
    fi
else
    echo "[*] 'aqua' ya está instalado."
fi

# 3. Instalar 'dra' para la descarga de assets de GitHub (si lo usas)
if ! command -v dra &> /dev/null; then
    echo -e "${GREEN}[+] Instalando 'dra' (GitHub releases downloader)...${NC}"
    # Usamos curl directo para descargar el binario compilado de dra
    ARCH=$(uname -m)
    if [ "$ARCH" = "x86_64" ]; then DRA_ARCH="x86_64"; elif [ "$ARCH" = "aarch64" ]; then DRA_ARCH="arm64"; fi
    
    LATEST_URL=$(curl -s https://api.github.com/repos/devmatteini/dra/releases/latest | grep "browser_download_url.*-linux-${DRA_ARCH}.tar.gz" | cut -d '"' -f 4)
    curl -sL "$LATEST_URL" | tar -xz -C /tmp
    sudo mv /tmp/dra-* /usr/local/bin/dra
    sudo chmod +x /usr/local/bin/dra
else
    echo "[*] 'dra' ya está instalado."
fi

echo -e "${GREEN}[✔] Bootstrap completado con éxito. Ya puedes usar 'just'.${NC}"
