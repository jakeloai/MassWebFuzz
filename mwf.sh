#!/bin/bash

# ==============================================================================
# Tool: MassWebFuzz (MWF)
# Developed by: JakeLo.AI (Web Vuln Analyst)
# Purpose: High-security large scale fuzzing for Bug Bounty & Pentesting
# Logic: Iterates through each URL in a target file against 6000+ SecLists
# ==============================================================================

# Text Formatting (Strictly Red & White)
RED='\033[0;31m'
WHITE='\033[0;37m'
NC='\033[0m' # No Color (Default)

# File Definitions
WORDLIST_CONFIG="mass_fuzz_wordlists.txt"

# Professional ASCII Banner
show_header() {
    echo -e "${RED}"
    echo "  __  __                 __          __  _     ______              "
    echo " |  \/  |                \ \        / / | |   |  ____|             "
    echo " | \  / | __ _ ___ ___    \ \  /\  / /__| |__ | |__ _   _ ________ "
    echo " | |\/| |/ _\` / __/ __|    \ \/  \/ / _ \ '_ \|  __| | | |_  /_  / "
    echo " | |  | | (_| \__ \__ \     \  /\  /  __/ |_) | |  | |_| |/ / / /  "
    echo " |_|  |_|\__,_|___/___/      \/  \/ \___|_.__/|_|   \__,_/___/___| "
    echo -e "                                                                    ${NC}"
    echo -e "${WHITE}  Developed by: ${RED}JakeLo.AI${NC} ${WHITE}| Web Vuln Analyst${NC}"
    echo -e "${WHITE}  Targeting: ${RED}High-Secure Client Infrastructure${NC}"
    echo -e "${WHITE}------------------------------------------------------------${NC}"
}

show_usage() {
    show_header
    echo -e "${WHITE}Usage:${NC}"
    echo -e "${WHITE}  ./mwf.sh <targets_with_fuzz.txt>${NC}"
    echo ""
    echo -e "${WHITE}Configuration:${NC}"
    echo -e "${WHITE}  Ensure ${RED}$WORDLIST_CONFIG${WHITE} is in the same directory.${NC}"
    echo -e "${WHITE}  This file should contain absolute paths to your SecLists.${NC}"
    echo -e "${WHITE}------------------------------------------------------------${NC}"
}

# 1. Validation Checks
if [ ! -f "$WORDLIST_CONFIG" ]; then
    show_header
    echo -e "${RED}[!] ERROR: Configuration file '$WORDLIST_CONFIG' not found!${NC}"
    echo -e "${WHITE}Please create it and add your SecLists paths (one per line).${NC}"
    exit 1
fi

if [ -z "$1" ]; then
    show_usage
    exit 1
fi

if [ ! -f "$1" ]; then
    show_header
    echo -e "${RED}[!] ERROR: Target file '$1' not found!${NC}"
    exit 1
fi

TARGET_FILE=$1
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_DIR="./mwf_results_$TIMESTAMP"
mkdir -p "$OUTPUT_DIR"

# 2. Load Wordlist Paths into Array
mapfile -t WORDLISTS < "$WORDLIST_CONFIG"

show_header
echo -e "${WHITE}[+] Successfully loaded ${RED}${#WORDLISTS[@]}${WHITE} wordlist paths.${NC}"
echo -e "${WHITE}[+] Output directory initialized: ${RED}$OUTPUT_DIR${NC}"

# 3. Outer Loop: Iterate through Target URLs
while IFS= read -r URL || [ -n "$URL" ]; do
    [ -z "$URL" ] && continue

    # Sanitize URL for filename (remove protocol and special chars)
    SAFE_NAME=$(echo "$URL" | sed 's/[^a-zA-Z0-9]/_/g' | cut -c 1-100)
    FINAL_OUTPUT="$OUTPUT_DIR/${SAFE_NAME}.txt"

    echo -e "\n${WHITE}CURRENT TARGET: ${RED}$URL${NC}"
    echo -e "${WHITE}------------------------------------------------------------${NC}"

    # 4. Inner Loop: Iterate through all provided Wordlists
    for WL in "${WORDLISTS[@]}"; do
        # Clean path strings
        WL=$(echo "$WL" | tr -d '\r' | xargs)
        
        [ -z "$WL" ] && continue
        
        if [ ! -f "$WL" ]; then
            echo -e "${RED}[-] Missing wordlist path: $WL${NC}"
            continue
        fi

        echo -e "${WHITE}[+] Fuzzing with: $(basename "$WL")${NC}"

        # Persistent Logging Header for individual file
        echo -e "\n[!] FFUF RUN | Wordlist: $WL" >> "$FINAL_OUTPUT"
        echo -e "------------------------------------------------------------" >> "$FINAL_OUTPUT"

        # Execute FFUF with professional match codes
        # -s: Silent to keep the log file clean
        ffuf -u "$URL" -w "$WL" \
             -mc 200,204,301,302,307,401,403,405,500 \
             -s >> "$FINAL_OUTPUT" 2>/dev/null
    done

    echo -e "${RED}[V] All scans completed for target: $URL${NC}"

done < "$TARGET_FILE"

echo -e "\n${RED}[!] MASS WEB FUZZING TASK COMPLETED.${NC}"
echo -e "${WHITE}Final reports saved in: ${RED}$OUTPUT_DIR${NC}"
