return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup DAP UI
      dapui.setup()

      -- Automatically open/close DAP UI when debugging starts/ends
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- PHP XDebug Adapter Configuration
      -- Requires XDebug PHP extension to be installed and configured
      -- Installation:
      --   Arch Linux: sudo pacman -S xdebug
      --   Ubuntu/Debian: sudo apt install php-xdebug
      --   macOS: pecl install xdebug
      --
      -- Configure XDebug in php.ini (find location with: php --ini):
      --   zend_extension=xdebug.so
      --   xdebug.mode=debug
      --   xdebug.start_with_request=yes
      --   xdebug.client_port=9003
      
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
      }

      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for XDebug",
          port = 9003,
          pathMappings = {
            -- Map remote paths to local paths if debugging in Docker/VM
            -- Example: ["/var/www/html"] = "${workspaceFolder}",
          },
        },
      }

      -- Debugging Keymaps
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Debug: Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step into" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: Step out" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run last" })
      vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Debug: Terminate" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })

      -- Breakpoint appearance
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "php-debug-adapter" },
        automatic_installation = true,
      })
    end,
  },
}
