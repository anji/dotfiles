-- All plugins have lazy=true by default,to load a plugin on startup just lazy=false
-- List of all default plugins & their definitions
local default_plugins = {
  "nvim-lua/plenary.nvim",
  "nvzone/ui",
  "nvzone/volt",
  "nvzone/menu",
  "nvzone/minty",
  
  -- Load custom plugins from lua/custom/plugins.lua
}

local config = require("custom.chadrc")

return vim.tbl_deep_extend("force", default_plugins, config.plugins or {})
