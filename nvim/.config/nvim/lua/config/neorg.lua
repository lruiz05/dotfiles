local M = {}

M.setup = function()
  require("neorg").setup({
    load = {
      ["core.defaults"] = {}, -- Configuración básica
      ["core.dirman"] = { -- Manejo de espacios de trabajo
        config = {
          workspaces = {
            journal = "~/Notes/Journal"
          },
          default_workspace = "journal"
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
          workspace = "journal",
          journal_folder = ".",
          strategy = "nested"
        }
      }
    }
  })
end

return M
