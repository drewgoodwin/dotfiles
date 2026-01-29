return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      debug = true,
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier.with({
          -- Force prettier to find and use config file from project root
          prefer_local = "node_modules/.bin",
        }),
        null_ls.builtins.diagnostics.erb_lint,
        null_ls.builtins.diagnostics.rubocop,
        null_ls.builtins.formatting.rubocop,
        require("none-ls.diagnostics.eslint_d"),
        -- PHP formatting and linting (requires external tool installation)
        -- Install via: composer global require friendsofphp/php-cs-fixer squizlabs/php_codesniffer phpstan/phpstan
        -- See Readme.md for detailed installation instructions
        null_ls.builtins.formatting.phpcsfixer,  -- PHP-CS-Fixer for formatting
        null_ls.builtins.diagnostics.phpcs,       -- PHP CodeSniffer for linting
        null_ls.builtins.formatting.phpcbf,       -- PHP Code Beautifier and Fixer
        null_ls.builtins.diagnostics.phpstan,     -- PHPStan for static analysis
      },
    })

    vim.keymap.set("n", "<leader>gf", function()
      vim.lsp.buf.format({
        filter = function(client)
          -- Only use null-ls for formatting, ignore other LSP formatters
          return client.name == "null-ls"
        end,
      })
    end, {})
  end,
}
