-- Minimal plugin customizations
-- LazyVim handles everything else by default

return {
  -- Set colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- Configure Tokyo Night theme
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night", -- storm, moon, night, day
    },
  },
}
