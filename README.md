# 🚀 Dotfiles - Complete Development Environment Setup

A modular and portable dotfiles configuration for a highly productive development environment. Easily port your configuration to any system with automatic backup of existing configs.

## ✨ Features

### Core Components

- **🐚 Zsh** - Powerful shell with Oh-My-Zsh framework

  - Powerlevel10k theme for beautiful prompts
  - Auto-suggestions and syntax highlighting
  - Extensive plugin support (git, docker, kubectl, terraform, aws, etc.)
  - Smart completion system

- **📝 Neovim with NvChad** - Modern, blazing-fast IDE

  - Pre-configured LSP servers for multiple languages
  - Extensive plugin ecosystem (Telescope, Harpoon, Trouble, etc.)
  - Git integration (Fugitive, Gitsigns)
  - Productivity-focused key bindings
  - Auto-formatting and linting

- **🖥️ Zellij** - Modern terminal multiplexer

  - Vim-style navigation
  - Multiple layouts (default, dev)
  - Beautiful themes (Dracula, Nord, Gruvbox)
  - Session management

- **🔧 Git Configuration** - Comprehensive Git setup

  - 50+ useful aliases
  - Delta for better diffs
  - Smart defaults and colors
  - Global gitignore

- **🐋 Docker Aliases** - Container management shortcuts
  - Docker and Docker Compose commands
  - Container inspection and cleanup
  - Network and volume management

### Productivity Tools

- **🔍 FZF** - Fuzzy finder with extensive integrations
- **🦇 Bat** - Modern cat replacement with syntax highlighting
- **🔎 Ripgrep** - Ultra-fast text search
- **📁 Fd** - Simple, fast alternative to find
- **🎨 Exa** - Modern ls replacement with git integration

## 📦 What's Included

```
dotfiles/
├── install.sh                    # Main installation script
├── zsh/
│   ├── .zshrc                   # Zsh configuration
│   └── .p10k.zsh                # Powerlevel10k theme
├── nvim/
│   └── custom/                  # NvChad custom configuration
│       ├── chadrc.lua           # Main config
│       ├── plugins.lua          # Plugin definitions
│       ├── mappings.lua         # Key bindings
│       └── configs/
│           └── lspconfig.lua    # LSP configurations
├── zellij/
│   ├── config.kdl               # Zellij configuration
│   └── layouts/
│       ├── default.kdl          # Default layout
│       └── dev.kdl              # Development layout
├── git/
│   ├── .gitconfig               # Git configuration
│   └── .gitignore_global        # Global gitignore
├── shell/
│   ├── .aliases                 # Command aliases
│   ├── .functions               # Useful shell functions
│   ├── .fzf.zsh                 # FZF configuration
│   └── .ripgreprc               # Ripgrep settings
└── README.md                    # This file
```

## 🚀 Quick Start

### Prerequisites

- Linux-based system (Ubuntu, Fedora, Arch, or macOS)
- Git installed
- Sudo privileges (for package installation)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the installation script:**

   ```bash
   ./install.sh
   ```

3. **Choose installation mode:**

   - Option 1: Install all components (recommended for first-time setup)
   - Options 2-7: Install individual components
   - Option 7: Install system packages only

4. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc
   ```

### Modular Installation

Install specific components:

```bash
# Interactive menu
./install.sh

# Install all at once
./install.sh --all
```

Select from:

- Zsh with Oh-My-Zsh
- Zellij terminal multiplexer
- Neovim with NvChad
- Git configuration
- Additional productivity tools
- System packages

## 🎯 Key Features & Usage

### Zsh Aliases & Functions

#### Navigation

```bash
..              # Go up one directory
...             # Go up two directories
mkcd mydir      # Create and enter directory
fcd mydir       # Fuzzy find and cd to directory
```

#### Git (50+ aliases)

```bash
g               # git
gs              # git status -sb
gaa             # git add .
gcm "message"   # git commit -m
gp              # git push
gpl             # git pull
glog            # Interactive git log with fzf
gcl <repo>      # Clone and cd into repo
gacp "msg"      # Add, commit, and push
```

#### Docker

```bash
d               # docker
dc              # docker-compose
dps             # docker ps
dsh             # Interactive docker exec
dlg             # Interactive docker logs with fzf
dprune          # Clean up docker system
```

#### Kubernetes

```bash
k               # kubectl
kgp             # kubectl get pods
kexec           # Interactive pod exec
klogs           # Interactive pod logs with fzf
kctx            # Switch context
kns             # Switch namespace
```

### Neovim Key Bindings

#### General

- `<leader>` = `Space`
- `<C-h/j/k/l>` - Navigate between windows
- `<S-h/l>` - Switch buffers
- `<leader>q` - Quit
- `<C-s>` - Save file

#### LSP

- `gd` - Go to definition
- `gr` - Show references (Telescope)
- `K` - Hover documentation
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>f` - Format buffer
- `[d` / `]d` - Navigate diagnostics

#### Telescope (File Navigation)

- `<leader>ff` - Find files
- `<leader>fw` - Live grep
- `<leader>fb` - Find buffers
- `<leader>fo` - Old files
- `<leader>fz` - Find in current buffer

#### Git

- `<leader>gg` - Git status
- `<leader>gb` - Git blame
- `<leader>gd` - Git diff

#### Harpoon (Quick Navigation)

- `<leader>a` - Add file to harpoon
- `<C-e>` - Toggle harpoon menu
- `<C-h/j/k/l>` - Navigate to harpoon files 1-4

### Zellij Key Bindings

- `Alt+h/j/k/l` - Navigate panes (Vim-style)
- `Alt+n` - New pane (horizontal split)
- `Alt+v` - New pane (vertical split)
- `Alt+x` - Close pane
- `Alt+t` - New tab
- `Alt+w` - Close tab
- `Alt+[1-9]` - Switch to tab
- `Alt+f` - Toggle floating panes
- `Alt+z` - Toggle fullscreen
- `Ctrl+s` - Enter scroll mode

## 🔧 Customization

### Update Git User Info

Edit `git/.gitconfig`:

```bash
nvim ~/dotfiles/git/.gitconfig
```

Update the `[user]` section:

```ini
[user]
    name = Your Name
    email = your.email@example.com
```

### Add More Aliases

Edit `shell/.aliases`:

```bash
nvim ~/dotfiles/shell/.aliases
```

### Customize Neovim

Edit NvChad custom config:

```bash
nvim ~/dotfiles/nvim/custom/chadrc.lua
```

### Modify Zsh Configuration

Edit `.zshrc`:

```bash
nvim ~/dotfiles/zsh/.zshrc
```

## 📝 LSP Servers Included

The Neovim setup includes LSP servers for:

- **Web:** HTML, CSS, TypeScript/JavaScript, Tailwind CSS
- **Backend:** Python (Pyright), Go (gopls), Rust (rust-analyzer)
- **DevOps:** Bash, Dockerfile, Terraform, YAML, JSON
- **Config:** Lua (for Neovim config)

### Adding More LSP Servers

1. Edit `nvim/custom/plugins.lua`:

   ```lua
   ensure_installed = {
       "your-language-server",
       -- Add more here
   }
   ```

2. Edit `nvim/custom/configs/lspconfig.lua` to configure the server

3. Restart Neovim and run `:Mason` to install

## 🔄 Backup System

The installation script automatically creates backups of existing configurations:

- Backups are stored in `~/.dotfiles_backup_YYYYMMDD_HHMMSS/`
- Each run creates a new timestamped backup
- Original files are preserved before being replaced

To restore a backup:

```bash
cp -r ~/.dotfiles_backup_YYYYMMDD_HHMMSS/* ~/
```

## 🧪 Testing on a New System

1. **Safe test without modifying system:**

   ```bash
   # Just review what would be installed
   cat install.sh
   ```

2. **Install only shell config first:**

   ```bash
   ./install.sh
   # Select option 2 (Zsh only)
   ```

3. **Gradually add more components:**
   - Test Zellij
   - Test Neovim
   - Add Git config
   - Install additional tools

## 🐛 Troubleshooting

### Zsh not set as default shell

```bash
chsh -s $(which zsh)
```

Logout and login again.

### Powerlevel10k fonts not displaying correctly

Install a Nerd Font:

```bash
# Ubuntu/Debian
sudo apt install fonts-firacode

# Or manually download from:
# https://www.nerdfonts.com/
```

Update your terminal's font settings to use the Nerd Font.

### Neovim plugins not loading

```bash
# Open Neovim
nvim

# Run inside Neovim:
:Lazy sync
```

### Zellij not starting

Check installation:

```bash
which zellij
zellij --version
```

### FZF key bindings not working

Source the configuration:

```bash
source ~/.zshrc
```

## 📚 Additional Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [NvChad Documentation](https://nvchad.com/)
- [Oh-My-Zsh Wiki](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [Zellij Documentation](https://zellij.dev/documentation/)
- [FZF Examples](https://github.com/junegunn/fzf/wiki/examples)

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [Oh-My-Zsh](https://ohmyz.sh/)
- [NvChad](https://nvchad.com/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Zellij](https://zellij.dev/)
- All the amazing open-source tool creators

## 📧 Contact

For questions or suggestions, please open an issue on GitHub.

---

**Happy coding! 🎉**
