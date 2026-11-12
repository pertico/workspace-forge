#!/usr/bin/env bash
set -e

# Colores para output limpio
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[+] Iniciando bootstrap de workspace-forge...${NC}"

# Instalar ubi (The Universal Binary Installer) si no está presente
if ! command -v ubi &> /dev/null; then 
    echo -e "${GREEN}[+] Instalando 'ubi' (The Universal Binary Installer)...${NC}"
    curl --silent --location \
        https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh |
        sudo sh
else
    echo "[*] 'ubi' ya está instalado."
fi

# Instalar 'just' (Just a command runner) si no está presente
if ! command -v just &> /dev/null; then
    echo -e "${GREEN}[+] Instalando 'just' (Just a command runner)...${NC}"
    # sudo ubi --project casey/just --to /usr/local/bin
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | sudo bash -s -- --to /usr/local/bin
else
    echo "[*] 'just' ya está instalado."
fi

echo -e "${GREEN}[✔] Bootstrap completado con éxito.${NC}"