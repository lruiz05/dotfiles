local M = {}

M.setup = function()
  require("neorg").setup({
    load = {
      ["core.defaults"] = {}, -- Configuración básica
      ["core.dirman"] = { -- Manejo de espacios de trabajo
        config = {
          workspaces = {
            notes = "~/Notes"
          },
          default_workspace = "notes"
        }
      },
      ["core.concealer"] = {}, -- Oculta caracteres especiales (*, -, #)
      ["core.export"] = {}, -- Habilita exportaciones
      ["core.export.markdown"] = {}, -- Exportar a Markdown
      ["core.keybinds"] = { -- Atajos de teclado
        config = {
          default_keybinds = true,
          neorg_leader = "<Leader>o"
        }
      },
      ["core.journal"] = { -- Habilita el sistema de diario
        config = {
          workspace = "notes",
          journal_folder = "Journal",
          strategy = "nested"
        }
      }
    }
  })
end

return M
