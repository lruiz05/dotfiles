-- lua/config/ufo.lua
local M = {}

function M.setup()
  -- Ajustes visuales del plegado
  vim.opt.foldcolumn = '1'        -- Columna lateral
  vim.opt.foldlevel = 99          -- No colapsar por defecto
  vim.opt.foldlevelstart = 99     -- No colapsa al abrir un archivo
  vim.opt.foldenable = true       -- Activa los pliegues

  -- Símbolos de plegado personalizados
  vim.opt.fillchars = {
    foldopen = "▼",  -- símbolo cuando el fold está abierto
    -- foldopen = "",  -- abierto
    foldclose = "▶", -- símbolo cuando el fold está cerrado
    -- foldopen = "",  -- abierto
    foldsep = " ",   -- separador entre pliegues
    fold = " ",      -- carácter de relleno dentro del foldcolumn
  }

  -- Configurar nvim-ufo
  require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
      return {'treesitter', 'indent'}
    end,
  })

  -- Abrir todos los folds al abrir un buffer (opcional)
  -- vim.api.nvim_create_autocmd("BufWinEnter", {
  --   pattern = "*",
  --   once = true,
  --   callback = function()
  --     vim.cmd([[silent! normal! zR]])
  --   end,
  -- })
end

-- Ejecutar setup automáticamente
M.setup()
return M
