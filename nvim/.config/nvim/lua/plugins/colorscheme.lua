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
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.gruvbox_material_enable_italic = true
      --vim.cmd.colorscheme('gruvbox-material')
      vim.g.gruvbox_material_background = 'transparent_mode'
    end
  },
}
