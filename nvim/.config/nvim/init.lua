require("config.lazy")

-- Editor settings
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.signcolumn = "yes"  -- Always show sign column
vim.opt.updatetime = 250     -- Faster completion
vim.opt.timeoutlen = 300     -- Faster which-key popup

-- Set colorscheme (must be after lazy.nvim loads)
vim.cmd.colorscheme('gruvbox-material')

-- General keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })
vim.keymap.set('n', '<leader>b', '<cmd>cclose<CR>', { desc = 'Close quickfix' })

-- Buffer navigation
vim.keymap.set('n', '[b', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer' })

