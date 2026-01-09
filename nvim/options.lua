-- LazyVim Options
-- Custom options for LazyVim

local opt = vim.opt

-- Line numbers
opt.relativenumber = true
opt.number = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Line wrapping
opt.wrap = false

-- Search settings
opt.ignorecase = true
opt.smartcase = true

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Scroll offset
opt.scrolloff = 8
opt.sidescrolloff = 8

-- File encoding
opt.fileencoding = "utf-8"

-- Undo and backup
opt.undofile = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Update time
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion
opt.completeopt = "menu,menuone,noselect"

-- Mouse
opt.mouse = "a"
