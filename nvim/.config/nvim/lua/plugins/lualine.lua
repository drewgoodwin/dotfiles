return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local function make_theme()
			local custom_gruvbox = vim.deepcopy(require("lualine.themes.gruvbox-material"))
			custom_gruvbox.normal.c.bg = "#3c3836"
			custom_gruvbox.inactive.a.bg = "#3c3836"
			return custom_gruvbox
		end

		require("lualine").setup({
			options = {
				theme = make_theme(),
				component_separators = "|",
				section_separators = "",
			},
		})

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				require("lualine").setup({
					options = {
						theme = make_theme(),
						component_separators = "|",
						section_separators = "",
					},
				})
			end,
		})
	end,
}
