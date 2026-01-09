# Neovim LazyVim Configuration

This directory contains minimal customizations for LazyVim.

## Installation

Run from dotfiles root:
```bash
./install.sh
# Select option 4 (Neovim with LazyVim)
```

## Structure

LazyVim starter handles everything. We only customize:
- `lua/plugins/*.lua` - Custom plugin configurations

That's it! Keep it simple.

## Adding Plugins

Create a file in `lua/plugins/`, for example `lua/plugins/my-plugin.lua`:

```lua
return {
  "author/plugin-name",
  opts = {},
}
```

## Customization

To override LazyVim defaults, add files to `lua/plugins/`.

Examples:
- Change colorscheme
- Add new plugins
- Disable unwanted plugins
- Override keymaps

LazyVim docs: https://lazyvim.github.io/
