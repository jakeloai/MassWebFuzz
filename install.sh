#!/bin/bash

# ==============================================================================
# Tool: MassWebFuzz (MWF) Installer
# Developed by: JakeLo.AI (Web Vuln Analyst)
# Description: Installs MWF to /usr/local/bin for global access.
# ==============================================================================

# Formatting
RED='\033[0;31m'
WHITE='\033[0;37m'
NC='\033[0m'

# Paths
INSTALL_DIR="/usr/local/bin"
CONFIG_DIR="/etc/mwf"
SCRIPT_NAME="mwf.sh"
BINARY_NAME="mwf"

echo -e "${RED}MassWebFuzz Global Installer${NC}"
echo -e "${WHITE}Developed by: JakeLo.AI${NC}"
echo -e "${WHITE}------------------------------------------------------------${NC}"

# 1. Check for Root Privileges
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}[!] Error: Please run as root (sudo ./install.sh)${NC}"
    exit 1
fi

# 2. Check if required files exist in current directory
if [ ! -f "$SCRIPT_NAME" ]; then
    echo -e "${RED}[!] Error: $SCRIPT_NAME not found in current folder.${NC}"
    exit 1
fi

# 3. Create Configuration Directory
echo -e "${WHITE}[+] Creating configuration directory at $CONFIG_DIR...${NC}"
mkdir -p "$CONFIG_DIR"

# 4. Move/Create the Wordlist Config
if [ -f "mass_fuzz_wordlists.txt" ]; then
    echo -e "${WHITE}[+] Moving mass_fuzz_wordlists.txt to $CONFIG_DIR...${NC}"
    cp "mass_fuzz_wordlists.txt" "$CONFIG_DIR/"
else
    echo -e "${WHITE}[+] Creating empty $CONFIG_DIR/mass_fuzz_wordlists.txt...${NC}"
    touch "$CONFIG_DIR/mass_fuzz_wordlists.txt"
fi

# 5. Modify the script to point to the global config path
echo -e "${WHITE}[+] Patching script for global configuration...${NC}"
sed -i "s|WORDLIST_CONFIG=\"mass_fuzz_wordlists.txt\"|WORDLIST_CONFIG=\"$CONFIG_DIR/mass_fuzz_wordlists.txt\"|g" "$SCRIPT_NAME"

# 6. Install to Binaries
echo -e "${WHITE}[+] Installing $BINARY_NAME to $INSTALL_DIR...${NC}"
cp "$SCRIPT_NAME" "$INSTALL_DIR/$BINARY_NAME"
chmod +x "$INSTALL_DIR/$BINARY_NAME"

# 7. Verification
if command -v $BINARY_NAME >/dev/null 2>&1; then
    echo -e "${RED}------------------------------------------------------------${NC}"
    echo -e "${RED}[V] SUCCESS: MassWebFuzz is now installed globally!${NC}"
    echo -e "${WHITE}Usage: ${RED}mwf <targets.txt>${NC}"
    echo -e "${WHITE}Config: ${RED}$CONFIG_DIR/mass_fuzz_wordlists.txt${NC}"
    echo -e "${RED}------------------------------------------------------------${NC}"
else
    echo -e "${RED}[!] Installation failed. Please check permissions.${NC}"
fi
