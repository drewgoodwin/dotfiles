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

			-- PHP's built-in indent script (GetPhpIndent) needs the legacy
			-- :syntax engine to compute indent correctly while typing.
			-- Neovim's default syntaxset autocmd skips loading it once
			-- Treesitter highlighting is active on a buffer, so set it
			-- explicitly here; Treesitter highlighting still wins visually.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "php",
				callback = function() vim.bo.syntax = "php" end,
			})
		end,
	},
}
