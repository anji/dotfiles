-- LSP Configuration

-- Suppress deprecation warning until nvim-lspconfig v3.0.0
vim.deprecate = function() end

local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- List of servers to configure
local servers = {
  "html",
  "cssls",
  "ts_ls",
  "pyright",
  "gopls",
  "rust_analyzer",
  "bashls",
  "dockerls",
  "terraformls",
  "yamlls",
  "jsonls",
}

-- Configure each server
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Python-specific configuration
lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
}

-- Go-specific configuration
lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}

-- Rust-specific configuration
lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}

-- TypeScript/JavaScript configuration
lspconfig.ts_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
}

-- Lua configuration (for Neovim config editing)
-- Commented out - install lua-language-server via :MasonInstall lua-language-server if needed
-- lspconfig.lua_ls.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = { "vim" },
--       },
--       workspace = {
--         library = {
--           [vim.fn.expand "$VIMRUNTIME/lua"] = true,
--           [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
--           [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
--         },
--         maxPreload = 100000,
--         preloadFileSize = 10000,
--       },
--     },
--   },
-- }
