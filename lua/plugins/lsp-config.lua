return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
      }
    },
  config = function()
    require("mason").setup()
  end
  },
  {
    {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
    config = function()
        require("mason-lspconfig").setup({
          ensure_installed = { "lua_ls", "vtsls", "clangd", "eslint", "gopls", "jsonls", "ruff", "tailwindcss"}
        })
      end
  },
},
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      lspconfig.vtsls.setup({})
      lspconfig.clangd.setup({})
      lspconfig.eslint.setup({})
      lspconfig.gopls.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.ruff.setup({})
      lspconfig.tailwindcss.setup({})

      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    end
  },
}
