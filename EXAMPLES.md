# Installation Examples

## Example 1: Fresh System Full Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run full installation
./install.sh --all

# Wait for installation to complete
# Restart terminal or source
source ~/.zshrc

# Configure Powerlevel10k prompt (first time)
p10k configure
```

## Example 2: Selective Installation

```bash
cd ~/dotfiles
./install.sh

# Interactive menu appears:
# Select: 2,3,4,5  (Zsh, Zellij, Neovim, Git)
# Press Enter
```

## Example 3: Installing on Multiple Machines

### On Machine A (Development Laptop)

```bash
# Install everything
cd ~/dotfiles
./install.sh --all
```

### On Machine B (Server)

```bash
# Install only shell tools (no GUI needed)
cd ~/dotfiles
./install.sh
# Select: 2,5,6  (Zsh, Git, Tools)
```

### On Machine C (Minimal Setup)

```bash
# Just Git and aliases
cd ~/dotfiles
./install.sh
# Select: 5,6  (Git config and Tools)
```

## Example 4: Update After Pulling Changes

```bash
cd ~/dotfiles
git pull origin main
./update.sh
source ~/.zshrc
```

## Example 5: Backup and Uninstall

```bash
# Your configs are auto-backed up in ~/.dotfiles_backup_*/

# To uninstall and restore
cd ~/dotfiles
./uninstall.sh

# Follow prompts to restore from backup
```

## Example 6: Customize After Install

```bash
# Update Git user info
nvim ~/dotfiles/git/.gitconfig
# Edit [user] section

# Add personal aliases
nvim ~/dotfiles/shell/.aliases
# Add your custom aliases

# Customize Neovim plugins
nvim ~/dotfiles/nvim/custom/plugins.lua
# Add more plugins

# Re-apply changes (creates new symlinks)
cd ~/dotfiles
./install.sh
# Select components to update
```

## Example 7: Testing New Configuration

```bash
# Test without installing
cd ~/dotfiles
./test.sh

# Review what will be installed
cat install.sh

# Do a dry run (just packages)
./install.sh
# Select: 7 (Install system packages only)
```

## Common Workflows

### Daily Development

```bash
# Start work
zellij attach -c dev

# Quick file edit
v myfile.py

# Git workflow
gaa              # git add all
gcm "message"    # commit
gp               # push
```

### Working with Docker

```bash
# View containers
dps

# Get shell in container
dsh              # Interactive selection

# View logs
dlg              # Interactive selection

# Clean up
dprune
```

### Searching Code

```bash
# Find files
ff               # FZF file search
fe               # Find and edit

# Search content
fw <pattern>     # Live grep with FZF
fif <pattern>    # Find in files and open
```

### Git Operations

```bash
# Interactive operations
glog             # View commits with FZF
gch              # Switch branches with FZF
gai              # Stage files interactively

# Quick operations
gnb feature-x    # New branch from main
gacp "msg"       # Add, commit, push
```

## Troubleshooting Workflow

### Issue: Fonts not displaying correctly

```bash
# Install Nerd Font
sudo apt install fonts-firacode

# Or download from nerdfonts.com
# Then update terminal font settings
```

### Issue: Zsh not default shell

```bash
# Check current shell
echo $SHELL

# Change to zsh
chsh -s $(which zsh)

# Logout and login again
```

### Issue: Neovim plugins not loading

```bash
# Open Neovim
nvim

# Inside Neovim
:checkhealth
:Lazy sync

# Restart Neovim
```

### Issue: Colors not working in terminal

```bash
# Check TERM
echo $TERM

# Should be xterm-256color or similar
# Add to ~/.zshrc if needed:
export TERM=xterm-256color
```

## Platform-Specific Notes

### Ubuntu/Debian

```bash
# Some packages need different names
sudo apt install fd-find    # fd command is 'fdfind'
sudo ln -s $(which fdfind) /usr/local/bin/fd
```

### macOS

```bash
# Use Homebrew
brew install fd bat exa ripgrep fzf

# Install.sh will detect macOS and use brew
```

### Arch Linux

```bash
# All packages available in official repos
sudo pacman -S fd bat exa ripgrep fzf
```

## Migration Scenario

### From Old Machine to New Machine

**On old machine:**

```bash
# Push any local changes
cd ~/dotfiles
git add .
git commit -m "Update configs"
git push
```

**On new machine:**

```bash
# Clone and install
git clone <your-repo> ~/dotfiles
cd ~/dotfiles
./install.sh --all

# Your environment is now identical!
```

## Advanced: Custom Installation

```bash
# Clone without installing
git clone <your-repo> ~/dotfiles
cd ~/dotfiles

# Install only what you need manually
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig

# Or modify install.sh for your needs
nvim install.sh
```
