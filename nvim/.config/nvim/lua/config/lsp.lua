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

local function lsp_on_attach(_, bufnr)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Ir a definición" })
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Ver referencias" })
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Ayuda flotante" })
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Renombrar símbolo" })
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Siguiente diagnóstico" })
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Diagnóstico anterior" })
  vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { buffer = bufnr, desc = "Diagnóstico flotante" })
end

local function setup_server(server_name)
  local server = resolve_server(server_name)
  if not server then
    return
  end
  server.setup({
    on_attach = lsp_on_attach,
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
    on_attach = lsp_on_attach,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
      }
    }
  })
end
