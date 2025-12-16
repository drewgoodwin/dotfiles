return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function()
    local wk = require("which-key")
    wk.setup()
    
    -- Document existing leader key groups
    wk.add({
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>g", group = "Go to / Git" },
      { "<leader>h", group = "Hunk (Git)" },
      { "<leader>t", group = "Toggle / Test" },
      { "<leader>z", group = "Copilot" },
      { "<leader>c", desc = "Close Neo-tree" },
      { "<leader>n", desc = "Open Neo-tree" },
      { "<leader>b", desc = "Close quickfix" },
      { "<leader>q", desc = "Diagnostic loclist" },
      { "<leader>r", group = "Rename" },
      { "<leader>e", desc = "Show diagnostic" },
    })
  end,
}
