-- Auto-save plugin configuration for LazyVim
return {
  {
    "pocco81/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      execution_message = {
        message = function()
          return "" -- Disable save messages
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
