return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	cmd = {
		"ClaudeCode",
		"ClaudeCodeFocus",
		"ClaudeCodeSelectModel",
		"ClaudeCodeAdd",
		"ClaudeCodeSend",
		"ClaudeCodeTreeAdd",
		"ClaudeCodeStatus",
		"ClaudeCodeStart",
		"ClaudeCodeStop",
		"ClaudeCodeOpen",
		"ClaudeCodeClose",
	},
	opts = {
		terminal = {
			split_side = "right",
			split_width_percentage = 0.30,
		},
	},
	keys = {
		{ "<leader>zc", "<cmd>ClaudeCode<cr>", mode = "n", desc = "Claude Code Toggle" },
		{ "<leader>zf", "<cmd>ClaudeCodeFocus<cr>", mode = "n", desc = "Claude Code Focus" },
		{ "<leader>zq", "<cmd>ClaudeCodeClose<cr>", mode = "n", desc = "Claude Code Close" },
		{ "<leader>za", "<cmd>ClaudeCodeAdd %<cr>", mode = "n", desc = "Add Buffer to Claude Context" },
		{ "<leader>zt", "<cmd>ClaudeCodeTreeAdd<cr>", mode = "n", desc = "Add Tree Selection to Claude Context" },
		{ "<leader>zm", "<cmd>ClaudeCodeSelectModel<cr>", mode = "n", desc = "Select Claude Model" },
		{ "<leader>zs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send Selection to Claude" },
	},
}
