return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup()
			require("nvim-treesitter").install({
				"lua",
				"javascript",
				"typescript",
				"html",
				"css",
				"markdown",
				"yaml",
				"json",
				"c",
				"cpp",
				"c_sharp",
				"php",
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function() pcall(vim.treesitter.start) end,
			})
		end,
	},
}
