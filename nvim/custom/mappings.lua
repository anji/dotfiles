-- Custom Keybindings for NvChad

local M = {}

-- Add custom mappings
M.general = {
  n = {
    -- Better window navigation
    ["<C-h>"] = { "<C-w>h", "Window left" },
    ["<C-l>"] = { "<C-w>l", "Window right" },
    ["<C-j>"] = { "<C-w>j", "Window down" },
    ["<C-k>"] = { "<C-w>k", "Window up" },

    -- Resize windows
    ["<C-Up>"] = { ":resize +2<CR>", "Resize up" },
    ["<C-Down>"] = { ":resize -2<CR>", "Resize down" },
    ["<C-Left>"] = { ":vertical resize -2<CR>", "Resize left" },
    ["<C-Right>"] = { ":vertical resize +2<CR>", "Resize right" },

    -- Buffer navigation
    ["<S-l>"] = { ":bnext<CR>", "Next buffer" },
    ["<S-h>"] = { ":bprevious<CR>", "Previous buffer" },

    -- Better indenting
    ["<"] = { "<<", "Indent left" },
    [">"] = { ">>", "Indent right" },

    -- Move text up and down
    ["<A-j>"] = { ":m .+1<CR>==", "Move line down" },
    ["<A-k>"] = { ":m .-2<CR>==", "Move line up" },

    -- Quick save
    ["<C-s>"] = { ":w<CR>", "Save file" },

    -- Quick quit
    ["<leader>q"] = { ":q<CR>", "Quit" },
    ["<leader>Q"] = { ":qa<CR>", "Quit all" },

    -- Clear highlights
    ["<Esc>"] = { ":noh<CR>", "Clear highlights" },

    -- Better paste
    ["<leader>p"] = { '"+p', "Paste from system clipboard" },
    ["<leader>P"] = { '"+P', "Paste before from system clipboard" },

    -- Copy to system clipboard
    ["<leader>y"] = { '"+y', "Copy to system clipboard" },
    ["<leader>Y"] = { '"+Y', "Copy line to system clipboard" },

    -- Delete without yanking
    ["<leader>d"] = { '"_d', "Delete without yank" },
    ["<leader>D"] = { '"_D', "Delete line without yank" },
  },

  v = {
    -- Better indenting
    ["<"] = { "<gv", "Indent left" },
    [">"] = { ">gv", "Indent right" },

    -- Move text up and down
    ["<A-j>"] = { ":m '>+1<CR>gv=gv", "Move selection down" },
    ["<A-k>"] = { ":m '<-2<CR>gv=gv", "Move selection up" },

    -- Copy to system clipboard
    ["<leader>y"] = { '"+y', "Copy to system clipboard" },

    -- Paste without yanking
    ["p"] = { '"_dP', "Paste without yank" },
  },

  i = {
    -- Quick save
    ["<C-s>"] = { "<Esc>:w<CR>a", "Save file" },

    -- Move to beginning/end of line
    ["<C-a>"] = { "<Home>", "Beginning of line" },
    ["<C-e>"] = { "<End>", "End of line" },
  },
}

-- LSP mappings
M.lsp = {
  n = {
    ["gd"] = {
      function()
        vim.lsp.buf.definition()
      end,
      "Go to definition",
    },
    ["gD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      "Go to declaration",
    },
    ["gi"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "Go to implementation",
    },
    ["gr"] = {
      function()
        require("telescope.builtin").lsp_references()
      end,
      "Show references",
    },
    ["K"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "Hover documentation",
    },
    ["<leader>rn"] = {
      function()
        vim.lsp.buf.rename()
      end,
      "Rename symbol",
    },
    ["<leader>ca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "Code action",
    },
    ["<leader>f"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "Format buffer",
    },
    ["[d"] = {
      function()
        vim.diagnostic.goto_prev()
      end,
      "Previous diagnostic",
    },
    ["]d"] = {
      function()
        vim.diagnostic.goto_next()
      end,
      "Next diagnostic",
    },
    ["<leader>e"] = {
      function()
        vim.diagnostic.open_float()
      end,
      "Show diagnostic",
    },
  },
}

-- Telescope mappings
M.telescope = {
  n = {
    ["<leader>ff"] = { "<cmd>Telescope find_files<CR>", "Find files" },
    ["<leader>fa"] = { "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", "Find all files" },
    ["<leader>fw"] = { "<cmd>Telescope live_grep<CR>", "Live grep" },
    ["<leader>fb"] = { "<cmd>Telescope buffers<CR>", "Find buffers" },
    ["<leader>fh"] = { "<cmd>Telescope help_tags<CR>", "Help tags" },
    ["<leader>fo"] = { "<cmd>Telescope oldfiles<CR>", "Old files" },
    ["<leader>fz"] = { "<cmd>Telescope current_buffer_fuzzy_find<CR>", "Find in current buffer" },
    ["<leader>cm"] = { "<cmd>Telescope git_commits<CR>", "Git commits" },
    ["<leader>gt"] = { "<cmd>Telescope git_status<CR>", "Git status" },
    ["<leader>ma"] = { "<cmd>Telescope marks<CR>", "Marks" },
    ["<leader>th"] = { "<cmd>Telescope themes<CR>", "Themes" },
  },
}

-- Git mappings
M.git = {
  n = {
    ["<leader>gg"] = { "<cmd>Git<CR>", "Git status" },
    ["<leader>gb"] = { "<cmd>Git blame<CR>", "Git blame" },
    ["<leader>gd"] = { "<cmd>Gdiffsplit<CR>", "Git diff" },
    ["<leader>gl"] = { "<cmd>Git log<CR>", "Git log" },
    ["<leader>gp"] = { "<cmd>Git push<CR>", "Git push" },
    ["<leader>gP"] = { "<cmd>Git pull<CR>", "Git pull" },
  },
}

-- Trouble mappings
M.trouble = {
  n = {
    ["<leader>xx"] = { "<cmd>TroubleToggle<CR>", "Toggle trouble" },
    ["<leader>xw"] = { "<cmd>TroubleToggle workspace_diagnostics<CR>", "Workspace diagnostics" },
    ["<leader>xd"] = { "<cmd>TroubleToggle document_diagnostics<CR>", "Document diagnostics" },
    ["<leader>xq"] = { "<cmd>TroubleToggle quickfix<CR>", "Quickfix" },
    ["<leader>xl"] = { "<cmd>TroubleToggle loclist<CR>", "Location list" },
  },
}

return M
