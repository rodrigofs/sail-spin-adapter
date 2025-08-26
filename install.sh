#!/usr/bin/env bash

# Installer: curl -fsSL https://raw.githubusercontent.com/rodrigofs/sail-spin-adapter/main/install.sh | bash

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

RAW_URL="https://raw.githubusercontent.com/rodrigofs/sail-spin-adapter/main"
INSTALL_DIR="/usr/local/bin"

echo -e "${GREEN}🚀 Installing Sail to Spin Adapter...${NC}"

# Check dependencies
if ! command -v spin &> /dev/null; then
    echo -e "${RED}Error: Spin not found${NC}"
    echo "Install at: https://serversideup.net/open-source/spin/"
    exit 1
fi

if ! command -v curl &> /dev/null; then
    echo -e "${RED}Error: curl not found${NC}"
    exit 1
fi

# Set sudo if needed
if [ -w "$INSTALL_DIR" ]; then
    SUDO=""
else
    echo -e "${YELLOW}Administrator permissions required...${NC}"
    SUDO="sudo"
fi

# Download sail-manager
echo -e "${YELLOW}Downloading sail-manager...${NC}"
if curl -fsSL "$RAW_URL/sail-manager" | $SUDO tee "$INSTALL_DIR/sail-manager" > /dev/null; then
    $SUDO chmod +x "$INSTALL_DIR/sail-manager"
    echo -e "${GREEN}✓ sail-manager installed!${NC}"
else
    echo -e "${RED}✗ Download failed${NC}"
    exit 1
fi

# Automatically install the adapter
echo -e "${YELLOW}Installing Spin adapter...${NC}"
SAIL_ADAPTER_DIR="$HOME/.sail-spin-adapter"
mkdir -p "$SAIL_ADAPTER_DIR"

if curl -fsSL "$RAW_URL/sail" -o "$SAIL_ADAPTER_DIR/sail-spin"; then
    chmod +x "$SAIL_ADAPTER_DIR/sail-spin"
    echo -e "${GREEN}✓ Spin adapter installed!${NC}"
else
    echo -e "${RED}✗ Adapter download failed${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 Installation complete!${NC}"
echo ""
echo -e "${YELLOW}The adapter uses aliases to avoid conflicts with Laravel Sail.${NC}"
echo ""
echo "Next steps:"
echo -e "  ${YELLOW}sail-manager activate${NC}   - Use Spin adapter"
echo -e "  ${YELLOW}sail-manager deactivate${NC} - Use Laravel Sail"
echo -e "  ${YELLOW}sail-manager auto${NC}       - Auto-detect project type"
echo -e "  ${YELLOW}sail-manager status${NC}     - Check current mode"
echo ""
echo "Run ${YELLOW}sail-manager help${NC} for complete documentation"