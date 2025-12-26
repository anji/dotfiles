-- Custom Plugin Configuration for NvChad

local plugins = {
  -- Disable default plugins if needed
  -- { "folke/which-key.nvim", enabled = false },

  -- Override default plugin configs
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "nvchad.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },

  -- Treesitter - Enhanced syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- Web development
        "html", "css", "javascript", "typescript", "tsx", "json", "yaml",
        -- Backend
        "python", "go", "rust", "lua", "bash",
        -- DevOps
        "dockerfile", "hcl", "terraform",
        -- Other
        "markdown", "markdown_inline", "vim", "regex",
      },
      highlight = {
        enable = true,
        use_languagetree = true,
      },
      indent = { enable = true },
      autotag = { enable = true },
    },
  },

  -- Mason - Package manager for LSP, DAP, linters, formatters
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- LSP servers
        "lua-language-server",
        "pyright",
        "typescript-language-server",
        "html-lsp",
        "css-lsp",
        "tailwindcss-language-server",
        "gopls",
        "rust-analyzer",
        "bash-language-server",
        "dockerfile-language-server",
        "terraform-ls",
        "yaml-language-server",
        "json-lsp",
        
        -- Formatters
        "prettier",
        "stylua",
        "black",
        "isort",
        "gofumpt",
        "shfmt",
        
        -- Linters
        "eslint-lsp",
        "pylint",
        "shellcheck",
      },
    },
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "󰍵" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
    },
  },

  -- Better git UI
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
  },

  -- GitHub integration
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup()
    end,
  },

  -- Telescope extensions
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
      },
    },
  },

  -- File explorer enhancements
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = {
        enable = true,
        ignore = false,
      },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
          },
        },
      },
      filters = {
        dotfiles = false,
        custom = { "^.git$" },
      },
    },
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    keys = { "gcc", "gbc" },
    config = function()
      require("Comment").setup()
    end,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },

  -- Better motion
  {
    "ggandor/leap.nvim",
    keys = { "s", "S" },
    config = function()
      require("leap").create_default_mappings()
    end,
  },

  -- Harpoon - Fast file navigation
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>a", function() require("harpoon"):list():append() end, desc = "Harpoon add file" },
      { "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon menu" },
      { "<C-h>", function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
      { "<C-j>", function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
      { "<C-k>", function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
      { "<C-l>", function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
    },
    config = function()
      require("harpoon"):setup()
    end,
  },

  -- Trouble - Better diagnostics
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
  },

  -- Todo comments
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    config = function()
      require("todo-comments").setup()
    end,
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },

  -- Better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    ft = { "markdown" },
  },

  -- Copilot (optional, requires GitHub Copilot subscription)
  -- {
  --   "github/copilot.vim",
  --   event = "InsertEnter",
  -- },

  -- Auto-save plugin
  {
    "pocco81/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      execution_message = {
        message = function()
          return ""  -- Disable save messages to avoid clutter
        end,
      },
      trigger_events = { "InsertLeave", "TextChanged" },
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")
        
        -- Don't autosave for certain filetypes
        if utils.not_in(fn.getbufvar(buf, "&filetype"), { "gitcommit", "gitrebase" }) then
          return true
        end
        return false
      end,
      write_all_buffers = false,
      debounce_delay = 135,
    },
  },
}

return plugins
