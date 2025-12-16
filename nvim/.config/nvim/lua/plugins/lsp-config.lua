return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "marksman", "sqls", "jsonls", "yamlls" }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "b0o/schemastore.nvim",
    },
    config = function()
      -- Get capabilities from cmp-nvim-lsp
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      -- Lua Language Server
      vim.lsp.config('lua_ls', {
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml', '.git' },
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
      
      -- TypeScript/JavaScript Language Server
      vim.lsp.config('ts_ls', {
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
        root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
        capabilities = capabilities,
      })
      
      -- JSON Language Server
      vim.lsp.config('jsonls', {
        cmd = { 'vscode-json-language-server', '--stdio' },
        filetypes = { 'json', 'jsonc' },
        root_markers = { '.git' },
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })
      
      -- YAML Language Server
      vim.lsp.config('yamlls', {
        cmd = { 'yaml-language-server', '--stdio' },
        filetypes = { 'yaml', 'yaml.docker-compose', 'yml' },
        root_markers = { '.git' },
        capabilities = capabilities,
        settings = {
          yaml = {
            schemaStore = {
              enable = true,
              url = "https://www.schemastore.org/api/json/catalog.json",
            },
            schemas = require('schemastore').yaml.schemas(),
            validate = true,
            format = {
              enable = true,
            },
            hover = true,
            completion = true,
          },
        },
      })
      
      -- Marksman (Markdown)
      vim.lsp.config('marksman', {
        cmd = { 'marksman', 'server' },
        filetypes = { 'markdown', 'markdown.mdx' },
        root_markers = { '.git', '.marksman.toml' },
        capabilities = capabilities,
      })
      
      -- SQL Language Server
      vim.lsp.config('sqls', {
        cmd = { 'sqls' },
        filetypes = { 'sql', 'mysql' },
        root_markers = { '.git', '.sqls.yml' },
        capabilities = capabilities,
      })
      
      -- LSP Keymaps
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
      vim.keymap.set({'n'}, '<leader>gr', vim.lsp.buf.references, { desc = 'Go to references' })
      vim.keymap.set({'n','v'}, '<leader>gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
      vim.keymap.set({'n'}, '<leader>gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
      vim.keymap.set({'n'}, '<leader>gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
      vim.keymap.set({'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
      vim.keymap.set({'n', 'v' }, '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
      vim.keymap.set({'n'}, '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
      
      -- Diagnostic navigation
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic loclist' })
    end
  },
}
