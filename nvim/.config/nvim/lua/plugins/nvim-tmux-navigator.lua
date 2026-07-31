return {
	"christoomey/vim-tmux-navigator",
	lazy = false,
	-- Mappings are owned by vim-herdr-navigation now; this plugin is kept only
	-- so its :TmuxNavigate* commands work as a fallback in plain tmux sessions.
	init = function()
		vim.g.tmux_navigator_no_mappings = 1
	end,
}
