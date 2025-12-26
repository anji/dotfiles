#!/usr/bin/env bash

# Uninstall dotfiles and restore backups
# Use with caution!

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Dotfiles Uninstaller${NC}"
echo "This will remove dotfiles configurations and restore backups."
echo ""

# Find latest backup
LATEST_BACKUP=$(find ~ -maxdepth 1 -type d -name ".dotfiles_backup_*" | sort -r | head -1)

if [ -z "$LATEST_BACKUP" ]; then
    echo -e "${RED}No backup found!${NC}"
    echo "Backups are usually located in ~/.dotfiles_backup_*"
    exit 1
fi

echo -e "Latest backup found: ${GREEN}$LATEST_BACKUP${NC}"
echo ""
echo "This will:"
echo "  1. Remove current dotfiles symlinks"
echo "  2. Restore from: $LATEST_BACKUP"
echo ""
read -p "Continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Uninstallation cancelled."
    exit 0
fi

# Remove symlinks
echo -e "\n${YELLOW}Removing symlinks...${NC}"
rm -f ~/.zshrc
rm -f ~/.p10k.zsh
rm -f ~/.gitconfig
rm -f ~/.gitignore_global
rm -f ~/.aliases
rm -f ~/.functions
rm -f ~/.fzf.zsh
rm -f ~/.ripgreprc

# Remove directories
echo -e "${YELLOW}Removing configuration directories...${NC}"
rm -rf ~/.config/nvim/lua/custom
rm -rf ~/.config/zellij/config.kdl
rm -rf ~/.config/zellij/layouts

# Restore from backup
echo -e "\n${YELLOW}Restoring from backup...${NC}"
if [ -f "$LATEST_BACKUP/.zshrc" ]; then
    cp "$LATEST_BACKUP/.zshrc" ~/.zshrc
    echo "Restored .zshrc"
fi

if [ -f "$LATEST_BACKUP/.gitconfig" ]; then
    cp "$LATEST_BACKUP/.gitconfig" ~/.gitconfig
    echo "Restored .gitconfig"
fi

if [ -d "$LATEST_BACKUP/nvim" ]; then
    cp -r "$LATEST_BACKUP/nvim" ~/.config/
    echo "Restored nvim config"
fi

if [ -d "$LATEST_BACKUP/zellij" ]; then
    cp -r "$LATEST_BACKUP/zellij" ~/.config/
    echo "Restored zellij config"
fi

echo -e "\n${GREEN}Uninstallation complete!${NC}"
echo ""
echo "Optional cleanup:"
echo "  - Remove Oh-My-Zsh: rm -rf ~/.oh-my-zsh"
echo "  - Remove NvChad: rm -rf ~/.config/nvim ~/.local/share/nvim"
echo "  - Remove backup: rm -rf $LATEST_BACKUP"
echo "  - Change shell back: chsh -s /bin/bash"
echo ""
echo "Restart your terminal for changes to take effect."
