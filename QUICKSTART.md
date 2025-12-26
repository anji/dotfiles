# Quick Start Guide

## First Time Setup

1. **Clone the repository:**

   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run installation:**

   ```bash
   ./install.sh --all
   ```

3. **Restart terminal**

## Essential Commands After Installation

### Zsh

- `reload` - Reload shell configuration
- `zshconfig` - Edit zsh config
- `aliasconfig` - Edit aliases

### Neovim

- Launch: `nvim` or `v`
- First launch will install plugins automatically
- Configure theme: `:Telescope themes`

### Git

- Configure your info:
  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "your@email.com"
  ```

### Zellij

- Start: `zellij` or `zj`
- Attach to session: `zj attach`
- Use `Alt+` combinations for navigation

## Key Productivity Features

### FZF Fuzzy Finding

- `Ctrl+T` - Find files
- `Ctrl+R` - Search command history
- `Alt+C` - Change directory
- `fcd <pattern>` - Fuzzy cd to directory
- `fe` - Find and edit file

### Git with FZF

- `glog` - Interactive git log
- `gch` - Interactive branch checkout
- `gai` - Interactive git add

### Docker

- `dsh` - Interactive container shell
- `dlg` - Interactive container logs
- `dprune` - Clean up Docker

## Updating Dotfiles

```bash
cd ~/dotfiles
./update.sh
```

## Troubleshooting

### Zsh not default shell

```bash
chsh -s $(which zsh)
# Logout and login
```

### Neovim plugins missing

```bash
nvim
:Lazy sync
```

### Font icons not showing

Install a Nerd Font from https://www.nerdfonts.com/

## Next Steps

1. Customize your Git user info
2. Run `p10k configure` to customize your prompt
3. Explore aliases: `alias | grep git`
4. Try Neovim: `v README.md`
5. Start Zellij: `zj`

For more details, see [README.md](README.md)
