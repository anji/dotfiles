-- Custom NvChad Configuration
-- This file will be symlinked to ~/.config/nvim/lua/custom/

local M = {}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

-- General settings
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.colorcolumn = "80,120"
vim.opt.cursorline = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300

-- Search settings
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Split settings
vim.opt.splitbelow = true
vim.opt.splitright = true

return M
