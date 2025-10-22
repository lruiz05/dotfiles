local lspconfig = require("lspconfig")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

-- Configurar Mason (gestor de LSPs)
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

-- Servidores LSP a instalar automáticamente
mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "ts_ls",
    "pyright",
    "html",
    "cssls",
    "jsonls",
  },
  automatic_installation = true,
})

-- Configurar cada LSP
mason_lspconfig.setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = function(client, bufnr)
        -- Keymaps específicos del LSP
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Ir a definición" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Ayuda flotante" })
      end
    })
  end,
})

-- Configuración especial para Lua
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    }
  }
})
