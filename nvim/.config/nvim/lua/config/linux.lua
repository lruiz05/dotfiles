-- Ajustes específicos para Linux/Fedora/Wayland
local M = {}

function M.setup()
  local opt = vim.opt

  -- Portapapeles nativo (Wayland/X11)
  opt.clipboard = "unnamedplus"

  -- Si ToggleTerm con <C-`> choca en GNOME, cambiar a <C-\>
  pcall(function()
    require("toggleterm").setup({ open_mapping = [[<C-\>]] })
  end)

  -- Si 'fd' no existe pero sí 'fdfind', ayuda a FZF
  if vim.fn.executable("fd") == 0 and vim.fn.executable("fdfind") == 1 then
    vim.env.FZF_DEFAULT_COMMAND = "fdfind --hidden --exclude .git"
  end
end

return M
