return {
	"christoomey/vim-tmux-navigator",
	lazy = false,
	config = function()
		vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<CR>", { silent = true, desc = "Navigate left" })
		vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<CR>", { silent = true, desc = "Navigate down" })
		vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<CR>", { silent = true, desc = "Navigate up" })
		vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<CR>", { silent = true, desc = "Navigate right" })
	end,
}
