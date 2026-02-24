return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	keys = {
		{ "<leader>n", "<cmd>Neotree filesystem reveal left<CR>", desc = "Open Neo-tree" },
		{ "<leader>c", "<cmd>Neotree filesystem close<CR>", desc = "Close Neo-tree" },
	},
}
