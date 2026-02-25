local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lsp_configs = require("lspconfig.configs")
local servers = {
  "lua_ls",
  "ts_ls",
  "pyright",
  "html",
  "cssls",
  "jsonls",
}

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
  ensure_installed = servers,
  automatic_installation = true,
  -- Evita usar vim.lsp.enable() (API de Neovim mas nuevo) para mantener compatibilidad
  automatic_enable = false,
})

local function resolve_server(name)
  if lsp_configs[name] == nil then
    local ok, config = pcall(require, "lspconfig.configs." .. name)
    if not ok then
      return nil
    end
    lsp_configs[name] = config
  end
  return lsp_configs[name]
end

local function setup_server(server_name)
  local server = resolve_server(server_name)
  if not server then
    return
  end
  server.setup({
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Ir a definición" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Ayuda flotante" })
    end
  })
end

for _, server_name in ipairs(servers) do
  if server_name ~= "lua_ls" then
    setup_server(server_name)
  end
end

-- Configuración especial para Lua
local lua_ls = resolve_server("lua_ls")
if lua_ls then
  lua_ls.setup({
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
      }
    }
  })
end
