-- I recommend installing the optional dependencies for copilot chat listed here https://github.com/CopilotC-Nvim/CopilotChat.nvim?tab=readme-ov-file

return {
	-- {
	-- 	"github/copilot.vim",
	-- },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false,
        },
        panel = {
          enabled = false,
        },
      })
    end,
  },
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			--{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "zbirenbaum/copilot.lua" },
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		-- See Commands section for default commands if you want to lazy load on them
		keys = {
			{ "<leader>zc", "<cmd>CopilotChat<cr>", mode = "n", desc = "Copilot Chat" },
			{ "<leader>zq", "<cmd>CopilotChatClose<cr>", mode = "n", desc = "Copilot Chat Close" },
			{ "<leader>ze", "<cmd>CopilotChatExplain<cr>", mode = "v", desc = "Copilot Explain Code" },
			{ "<leader>zr", "<cmd>CopilotChatReview<cr>", mode = "v", desc = "Copilot Review Code" },
			{ "<leader>zf", "<cmd>CopilotChatFix<cr>", mode = "v", desc = "Copilot Fix Code" },
			{ "<leader>zo", "<cmd>CopilotChatOptimize<cr>", mode = "v", desc = "Copilot Optimize Code" },
			{ "<leader>zd", "<cmd>CopilotChatDocs<cr>", mode = "v", desc = "Copilot Generate Docs" },
			{ "<leader>zt", "<cmd>CopilotChatTests<cr>", mode = "v", desc = "Copilot Generate Tests" },
			{ "<leader>zm", "<cmd>CopilotChatCommit<cr>", mode = "n", desc = "Copilot Commit Message" },
			{ "<leader>zs", "<cmd>CopilotChatCommit<cr>", mode = "v", desc = "Copilot Commit for Selection" },
			{ "<leader>zC", "<cmd>CopilotChat -p<cr>", mode = "n", desc = "Copilot Chat (Prompt)" },
			{ "<leader>zR", "<cmd>CopilotChat -r<cr>", mode = "n", desc = "Copilot Chat (Revert)" },
			{ "<leader>zS", "<cmd>CopilotChat -s<cr>", mode = "n", desc = "Copilot Chat (Send)" },
		},
	},
	{
		"zbirenbaum/copilot-cmp",
    -- after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},
}

