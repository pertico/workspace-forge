#!/usr/bin/env bash
set -e

# Colores para output limpio
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[+] Iniciando bootstrap de workspace-forge...${NC}"

# Instalar homebrew/linuxbrew
if ! command -v brew &> /dev/null; then
    echo -e "${GREEN}[+] Instalando 'homebrew/linuxbrew'...${NC}"
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash -s -- --path ~/.linuxbrew
    echo 'eval "$(~/.linuxbrew/bin/brew shellenv bash)"' > /home/rgm/.bashrc.d/50_linuxbrew.bashrc
else
    echo "[*] 'homebrew/linuxbrew' ya está instalado."
fi

# Instalar mise
if ! command -v mise &> /dev/null; then
    echo -e "${GREEN}[+] Instalando 'mise'...${NC}"
    curl -fsSL https://mise.run | sh
    echo "eval \"\$(~/.local/bin/mise activate bash)\"" > ~/.bashrc.d/50_mise.bashrc
else
    echo "[*] 'mise' ya está instalado."
fi

# Instalar chezmoi
if ! command -v mise &> /dev/null; then
    echo -e "${GREEN}[+] Instalando 'chezmoi'...${NC}"
    sh -c "$(curl -fsLS https://get.chezmoi.io)" -- -b ~/.local/bin
else
    echo "[*] 'chezmoi' ya está instalado."
fi

echo -e "${GREEN}[✔] Bootstrap completado con éxito.${NC}"