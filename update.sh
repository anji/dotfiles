#!/usr/bin/env bash

# Update dotfiles from repository
# This script pulls the latest changes and updates symlinks

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Updating dotfiles from repository..."

# Save current directory
CURRENT_DIR=$(pwd)

# Navigate to dotfiles directory
cd "$DOTFILES_DIR"

# Stash any local changes
if ! git diff-index --quiet HEAD --; then
    echo "Stashing local changes..."
    git stash
fi

# Pull latest changes
echo "Pulling latest changes..."
git pull origin main

# Apply stashed changes if any
if git stash list | grep -q "stash@{0}"; then
    echo "Applying stashed changes..."
    git stash pop || echo "Conflicts detected, please resolve manually"
fi

# Update Oh-My-Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Updating Oh-My-Zsh..."
    cd "$HOME/.oh-my-zsh"
    git pull
fi

# Update Oh-My-Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Updating zsh-autosuggestions..."
    cd "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    git pull
fi

if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Updating zsh-syntax-highlighting..."
    cd "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    git pull
fi

if [ -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
    echo "Updating zsh-completions..."
    cd "$ZSH_CUSTOM/plugins/zsh-completions"
    git pull
fi

if [ -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Updating Powerlevel10k..."
    cd "$ZSH_CUSTOM/themes/powerlevel10k"
    git pull
fi

# Update Neovim plugins
if command -v nvim >/dev/null 2>&1; then
    echo "Updating Neovim plugins..."
    nvim --headless "+Lazy! sync" +qa
fi

# Return to original directory
cd "$CURRENT_DIR"

echo ""
echo "✓ Dotfiles updated successfully!"
echo "Please restart your terminal or run: source ~/.zshrc"
