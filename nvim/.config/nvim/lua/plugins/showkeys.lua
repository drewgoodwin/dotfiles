return {
	"nvzone/showkeys",
	cmd = "ShowkeysToggle",
	opts = {
		timeout = 1,
		maxkeys = 5,
		position = "top-right",
	},
	keys = {
		{
			"<leader>sk",
			"<cmd>ShowkeysToggle<cr>",
			desc = "Toggle Showkeys",
		},
	},
}
