return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {},
    priority = 1000,
    config = function()
      -- Optionally configure the colorscheme
    end
  },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    opts = {
      transparent_mode = true
    },
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_transparent_background = 1
    end
  },
}
