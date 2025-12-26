#!/usr/bin/env bash

# Dotfiles Installation Script
# Modular setup with backup functionality

# Don't exit on error, handle errors gracefully
set -o pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track installation status
INSTALL_SUCCESS=true

# Directories
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Backup function
backup_if_exists() {
    local path="$1"
    if [ -e "$path" ]; then
        mkdir -p "$BACKUP_DIR"
        log_warning "Backing up existing $path to $BACKUP_DIR"
        cp -r "$path" "$BACKUP_DIR/"
        return 0
    fi
    return 1
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install packages based on distro
install_packages() {
    log_info "Installing required packages..."
    
    if command_exists apt-get; then
        sudo apt-get update || { log_error "Failed to update package list"; return 1; }
        sudo apt-get install -y curl git wget build-essential zsh fzf ripgrep fd-find bat exa 2>/dev/null || {
            log_warning "Some packages may not be available, continuing..."
            sudo apt-get install -y curl git wget build-essential zsh fzf ripgrep fd-find bat || true
        }
    elif command_exists dnf; then
        sudo dnf install -y curl git wget gcc gcc-c++ make zsh fzf ripgrep fd-find bat exa || {
            log_warning "Some packages may not be available, continuing..."
        }
    elif command_exists pacman; then
        sudo pacman -Sy --noconfirm curl git wget base-devel zsh fzf ripgrep fd bat exa || {
            log_warning "Some packages may not be available, continuing..."
        }
    elif command_exists brew; then
        brew install curl git wget zsh fzf ripgrep fd bat exa || {
            log_warning "Some packages may not be available, continuing..."
        }
    else
        log_error "Package manager not supported. Please install dependencies manually."
        return 1
    fi
    
    log_success "Packages installed"
    return 0
}

# Install Zsh and Oh-My-Zsh
install_zsh() {
    log_info "Setting up Zsh..."
    
    if ! command_exists zsh; then
        log_error "Zsh not found. Installing packages first..."
        install_packages || return 1
    fi
    
    # Install Oh-My-Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_info "Installing Oh-My-Zsh..."
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
            log_error "Failed to install Oh-My-Zsh"
            return 1
        }
    else
        log_info "Oh-My-Zsh already installed"
    fi
    
    # Install zsh plugins
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    # zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        log_info "Installing zsh-autosuggestions..."
        git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || {
            log_warning "Failed to install zsh-autosuggestions, continuing..."
        }
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        log_info "Installing zsh-syntax-highlighting..."
        git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || {
            log_warning "Failed to install zsh-syntax-highlighting, continuing..."
        }
    fi
    
    # zsh-completions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
        log_info "Installing zsh-completions..."
        git clone --depth 1 https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions" || {
            log_warning "Failed to install zsh-completions, continuing..."
        }
    fi
    
    # Powerlevel10k theme
    if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
        log_info "Installing Powerlevel10k theme..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" || {
            log_warning "Failed to install Powerlevel10k, continuing..."
        }
    fi
    
    # Link zshrc
    backup_if_exists "$HOME/.zshrc"
    rm -f "$HOME/.zshrc"
    ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc" || {
        log_error "Failed to link .zshrc"
        return 1
    }
    
    # Link p10k config
    if [ -f "$DOTFILES_DIR/zsh/.p10k.zsh" ]; then
        backup_if_exists "$HOME/.p10k.zsh"
        rm -f "$HOME/.p10k.zsh"
        ln -sf "$DOTFILES_DIR/zsh/.p10k.zsh" "$HOME/.p10k.zsh" || {
            log_warning "Failed to link .p10k.zsh, continuing..."
        }
    fi
    
    log_success "Zsh setup complete"
    return 0
}

# Install Zellij
install_zellij() {
    log_info "Setting up Zellij..."
    
    if ! command_exists zellij; then
        log_info "Installing Zellij..."
        if command_exists cargo; then
            log_info "Installing via cargo (this may take several minutes)..."
            echo "Please wait, compiling Zellij from source..."
            cargo install zellij || {
                log_warning "Failed to install via cargo, trying binary..."
                install_zellij_binary
            }
        else
            install_zellij_binary
        fi
    else
        log_info "Zellij already installed: $(zellij --version)"
    fi
    
    # Create config directory and link config
    mkdir -p "$HOME/.config/zellij"
    mkdir -p "$HOME/.config/zellij/themes"
    backup_if_exists "$HOME/.config/zellij/config.kdl"
    rm -f "$HOME/.config/zellij/config.kdl"
    ln -sf "$DOTFILES_DIR/zellij/config.kdl" "$HOME/.config/zellij/config.kdl" || {
        log_warning "Failed to link Zellij config"
    }
    
    # Link layouts if they exist
    if [ -d "$DOTFILES_DIR/zellij/layouts" ]; then
        mkdir -p "$HOME/.config/zellij/layouts"
        for layout in "$DOTFILES_DIR/zellij/layouts"/*; do
            if [ -f "$layout" ]; then
                local layout_name=$(basename "$layout")
                rm -f "$HOME/.config/zellij/layouts/$layout_name"
                ln -sf "$layout" "$HOME/.config/zellij/layouts/$layout_name" || {
                    log_warning "Failed to link layout: $layout_name"
                }
            fi
        done
    fi
    
    log_success "Zellij setup complete"
    return 0
}

# Helper function to install Zellij from binary
install_zellij_binary() {
    local arch=$(uname -m)
    local os=$(uname -s | tr '[:upper:]' '[:lower:]')
    
    log_info "Downloading Zellij binary for ${arch}-${os}..."
    echo "Fetching from GitHub releases..."
    curl -L --progress-bar "https://github.com/zellij-org/zellij/releases/latest/download/zellij-${arch}-unknown-${os}-musl.tar.gz" | tar xz -C /tmp || {
        log_error "Failed to download Zellij"
        return 1
    }
    
    log_info "Installing Zellij to /usr/local/bin (requires sudo)..."
    sudo mv /tmp/zellij /usr/local/bin/ || {
        log_error "Failed to install Zellij (sudo required)"
        return 1
    }
    
    log_success "Zellij installed successfully"
    return 0
}

# Install Neovim with NvChad
install_neovim() {
    log_info "Setting up Neovim with NvChad..."
    
    if ! command_exists nvim; then
        log_info "Installing Neovim..."
        if command_exists apt-get; then
            # Try PPA first
            sudo add-apt-repository ppa:neovim-ppa/stable -y 2>/dev/null || log_warning "Failed to add PPA"
            sudo apt-get update 2>/dev/null
            sudo apt-get install -y neovim || {
                log_warning "Failed to install Neovim from PPA, trying AppImage..."
                install_neovim_appimage
            }
        elif command_exists brew; then
            brew install neovim || {
                log_error "Failed to install Neovim"
                return 1
            }
        else
            log_warning "Installing Neovim AppImage..."
            install_neovim_appimage || return 1
        fi
    else
        log_info "Neovim already installed"
    fi
    
    # Backup existing nvim config
    backup_if_exists "$HOME/.config/nvim"
    backup_if_exists "$HOME/.local/share/nvim"
    
    # Remove old config
    rm -rf "$HOME/.config/nvim"
    
    # Install NvChad
    log_info "Installing NvChad (this will clone the repository, please wait)..."
    echo "Cloning NvChad from GitHub..."
    git clone https://github.com/NvChad/NvChad "$HOME/.config/nvim" --depth 1 || {
        log_error "Failed to install NvChad"
        return 1
    }
    
    # Link custom config if it exists
    if [ -d "$DOTFILES_DIR/nvim/custom" ]; then
        rm -rf "$HOME/.config/nvim/lua/custom"
        ln -sf "$DOTFILES_DIR/nvim/custom" "$HOME/.config/nvim/lua/custom" || {
            log_warning "Failed to link custom Neovim config"
        }
    fi
    
    log_success "Neovim with NvChad setup complete"
    log_info "Run 'nvim' and wait for plugins to install"
    return 0
}

# Helper function to install Neovim AppImage
install_neovim_appimage() {
    log_info "Downloading Neovim AppImage..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage || {
        log_error "Failed to download Neovim AppImage"
        return 1
    }
    
    chmod +x nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim || {
        log_error "Failed to install Neovim (sudo required)"
        return 1
    }
    
    log_success "Neovim AppImage installed"
    return 0
}

# Setup Git configuration
setup_git() {
    log_info "Setting up Git configuration..."
    
    backup_if_exists "$HOME/.gitconfig"
    rm -f "$HOME/.gitconfig"
    ln -sf "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig" || {
        log_error "Failed to link .gitconfig"
        return 1
    }
    
    if [ -f "$DOTFILES_DIR/git/.gitignore_global" ]; then
        backup_if_exists "$HOME/.gitignore_global"
        rm -f "$HOME/.gitignore_global"
        ln -sf "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global" || {
            log_warning "Failed to link .gitignore_global"
        }
    fi
    
    log_success "Git configuration complete"
    return 0
}

# Setup additional tools
setup_additional_tools() {
    log_info "Setting up additional productivity tools..."
    
    # Ripgrep config
    if [ -f "$DOTFILES_DIR/shell/.ripgreprc" ]; then
        backup_if_exists "$HOME/.ripgreprc"
        rm -f "$HOME/.ripgreprc"
        ln -sf "$DOTFILES_DIR/shell/.ripgreprc" "$HOME/.ripgreprc" || {
            log_warning "Failed to link .ripgreprc"
        }
    fi
    
    # FZF configuration
    if [ -f "$DOTFILES_DIR/shell/.fzf.zsh" ]; then
        backup_if_exists "$HOME/.fzf.zsh"
        rm -f "$HOME/.fzf.zsh"
        ln -sf "$DOTFILES_DIR/shell/.fzf.zsh" "$HOME/.fzf.zsh" || {
            log_warning "Failed to link .fzf.zsh"
        }
    fi
    
    # Aliases
    if [ -f "$DOTFILES_DIR/shell/.aliases" ]; then
        backup_if_exists "$HOME/.aliases"
        rm -f "$HOME/.aliases"
        ln -sf "$DOTFILES_DIR/shell/.aliases" "$HOME/.aliases" || {
            log_warning "Failed to link .aliases"
        }
    fi
    
    # Functions
    if [ -f "$DOTFILES_DIR/shell/.functions" ]; then
        backup_if_exists "$HOME/.functions"
        rm -f "$HOME/.functions"
        ln -sf "$DOTFILES_DIR/shell/.functions" "$HOME/.functions" || {
            log_warning "Failed to link .functions"
        }
    fi
    
    log_success "Additional tools configured"
    return 0
}

# Install Nerd Fonts for icons
install_nerd_fonts() {
    log_info "Installing Nerd Fonts for icon support..."
    
    local font_dir
    if [[ "$OSTYPE" == "darwin"* ]]; then
        font_dir="$HOME/Library/Fonts"
    else
        font_dir="$HOME/.local/share/fonts"
    fi
    
    mkdir -p "$font_dir"
    
    # Install popular Nerd Fonts
    local fonts=("FiraCode" "JetBrainsMono" "Hack")
    
    for font in "${fonts[@]}"; do
        if ! fc-list | grep -qi "$font.*Nerd"; then
            log_info "Installing $font Nerd Font..."
            
            local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.tar.xz"
            local temp_file="/tmp/${font}.tar.xz"
            
            curl -fLo "$temp_file" "$url" 2>/dev/null || {
                log_warning "Failed to download $font, skipping..."
                continue
            }
            
            tar -xf "$temp_file" -C "$font_dir" 2>/dev/null || {
                log_warning "Failed to extract $font, skipping..."
                rm -f "$temp_file"
                continue
            }
            
            rm -f "$temp_file"
            log_success "$font Nerd Font installed"
        else
            log_info "$font Nerd Font already installed"
        fi
    done
    
    # Refresh font cache
    if command_exists fc-cache; then
        log_info "Refreshing font cache..."
        fc-cache -fv >/dev/null 2>&1
    fi
    
    log_success "Nerd Fonts installation complete"
    echo ""
    log_info "Remember to set your terminal font to one of:"
    echo "  - FiraCode Nerd Font"
    echo "  - JetBrainsMono Nerd Font"
    echo "  - Hack Nerd Font"
    return 0
}

# Change default shell to zsh
change_shell() {
    if [ "$SHELL" != "$(which zsh)" ]; then
        log_info "Changing default shell to Zsh..."
        chsh -s "$(which zsh)" || {
            log_warning "Failed to change shell. Run manually: chsh -s \$(which zsh)"
            return 1
        }
        log_success "Default shell changed to Zsh (restart required)"
    else
        log_info "Zsh is already the default shell"
    fi
    return 0
}

# Main installation menu
main() {
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════╗"
    echo "║     Dotfiles Installation Script      ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Track which components failed
    local failed_components=()
    
    if [ "$1" == "--all" ]; then
        echo "Starting full installation..."
        echo ""
        
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Step 1/7: Installing system packages..."
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        install_packages || failed_components+=("packages")
        
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Step 2/7: Setting up Zsh and plugins..."
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        install_zsh || failed_components+=("zsh")
        
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Step 3/7: Installing Zellij..."
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        install_zellij || failed_components+=("zellij")
        
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Step 4/7: Setting up Neovim with NvChad..."
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        install_neovim || failed_components+=("neovim")
        
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Step 5/7: Configuring Git..."
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        setup_git || failed_components+=("git")
        
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Step 6/7: Setting up additional tools..."
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        setup_additional_tools || failed_components+=("tools")
        
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Step 7/7: Installing Nerd Fonts..."
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        install_nerd_fonts || failed_components+=("fonts")
        
        echo ""
        change_shell || true  # Don't fail if shell change fails
        
        echo ""
        if [ ${#failed_components[@]} -eq 0 ]; then
            log_success "All components installed successfully!"
        else
            log_warning "Installation completed with some issues:"
            for component in "${failed_components[@]}"; do
                log_warning "  - $component failed or had warnings"
            done
        fi
    else
        echo "Select components to install:"
        echo "1) All components"
        echo "2) Zsh (with Oh-My-Zsh)"
        echo "3) Zellij"
        echo "4) Neovim (with NvChad)"
        echo "5) Git configuration"
        echo "6) Additional tools (fzf, aliases, etc.)"
        echo "7) Install system packages"
        echo "8) Install Nerd Fonts"
        echo "0) Exit"
        echo ""
        read -p "Enter your choice (comma-separated for multiple): " choices
        
        IFS=',' read -ra SELECTIONS <<< "$choices"
        for choice in "${SELECTIONS[@]}"; do
            choice=$(echo "$choice" | xargs) # trim whitespace
            case $choice in
                1)
                    install_packages
                    install_zsh
                    install_zellij
                    install_neovim
                    setup_git
                    setup_additional_tools
                    install_nerd_fonts
                    change_shell
                    ;;
                2) install_zsh ;;
                3) install_zellij ;;
                4) install_neovim ;;
                5) setup_git ;;
                6) setup_additional_tools ;;
                7) install_packages ;;
                8) install_nerd_fonts ;;
                0) exit 0 ;;
                *) log_error "Invalid option: $choice" ;;
            esac
        done
    fi
    
    echo ""
    log_success "Installation complete!"
    if [ -d "$BACKUP_DIR" ]; then
        log_info "Backups saved to: $BACKUP_DIR"
    fi
    echo -e "${YELLOW}Please restart your terminal or run: source ~/.zshrc${NC}"
}

main "$@"
