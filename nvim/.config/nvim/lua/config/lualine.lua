require("lualine").setup({
  options = {
    theme = "auto",  -- Usa el tema que coincida con tu colorscheme
    icons_enabled = true,
  },
  sections = {
    lualine_a = { "mode" },  -- Modo actual (Normal/Insert/Visual)
    lualine_b = {
    "branch",  -- Nombre de la rama
    "diff",     -- Diferencias (+, -, ~)
      {
        "diagnostics",  -- Errores/Advertencias (opcional)
        sources = { "nvim_diagnostic" },
      },
    },
    lualine_c = {
      {
        "filename",
        file_status = true, -- no funciona
        path = 1
      }
    },  -- Ruta del archivo
    lualine_x = { "encoding", "fileformat", "filetype" },  -- Metadatos
    lualine_y = { "progress" },  -- Porcentaje del cursor
    lualine_z = { "location" },  -- Línea/Columna actual
  },
})
