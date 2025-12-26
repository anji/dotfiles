#!/usr/bin/env bash

# Test dotfiles setup in a safe way
# This script checks configurations without making changes

echo "🔍 Dotfiles Configuration Test"
echo "================================"
echo ""

# Check if scripts are executable
echo "📋 Checking scripts..."
for script in install.sh update.sh uninstall.sh; do
    if [ -x "$script" ]; then
        echo "  ✓ $script is executable"
    else
        echo "  ✗ $script is NOT executable"
    fi
done
echo ""

# Check directory structure
echo "📁 Checking directory structure..."
required_dirs=("zsh" "nvim/custom" "zellij" "git" "shell")
for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "  ✓ $dir exists"
    else
        echo "  ✗ $dir is missing"
    fi
done
echo ""

# Check essential files
echo "📄 Checking essential configuration files..."
required_files=(
    "zsh/.zshrc"
    "zsh/.p10k.zsh"
    "nvim/custom/chadrc.lua"
    "nvim/custom/plugins.lua"
    "nvim/custom/mappings.lua"
    "zellij/config.kdl"
    "git/.gitconfig"
    "git/.gitignore_global"
    "shell/.aliases"
    "shell/.functions"
    "shell/.fzf.zsh"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file exists"
    else
        echo "  ✗ $file is missing"
    fi
done
echo ""

# Check for required system commands
echo "🔧 Checking system requirements..."
commands=("git" "curl" "wget")
for cmd in "${commands[@]}"; do
    if command -v "$cmd" &> /dev/null; then
        echo "  ✓ $cmd is installed"
    else
        echo "  ⚠ $cmd is NOT installed (required)"
    fi
done
echo ""

# Check for optional but recommended tools
echo "✨ Checking optional tools..."
optional_commands=("zsh" "nvim" "fzf" "rg" "fd" "bat" "exa" "docker" "kubectl")
for cmd in "${optional_commands[@]}"; do
    if command -v "$cmd" &> /dev/null; then
        echo "  ✓ $cmd is installed"
    else
        echo "  - $cmd is not installed (will be installed if needed)"
    fi
done
echo ""

# Summary
echo "📊 Summary"
echo "================================"
echo "Configuration files are ready!"
echo ""
echo "Next steps:"
echo "  1. Review README.md for detailed information"
echo "  2. Run ./install.sh to install"
echo "  3. Choose components to install"
echo "  4. Restart your terminal"
echo ""
echo "For quick start: ./install.sh --all"
