vim.g.mapleader = " "  -- Tecla líder (espacio)

-- Navegación entre ventanas
vim.keymap.set("n", "<A-h>", "<C-w>h", { desc = "Ventana izquierda (Alt+h)" })
vim.keymap.set("n", "<A-j>", "<C-w>j", { desc = "Ventana inferior (Alt+j)" })
vim.keymap.set("n", "<A-k>", "<C-w>k", { desc = "Ventana superior (Alt+k)" })
vim.keymap.set("n", "<A-l>", "<C-w>l", { desc = "Ventana derecha (Alt+l)" })

-- Gestión de buffers
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Cerrar buffer" })
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Siguiente buffer" })

-- Elegir colorscheme
vim.keymap.set("n", "<leader>ct1", function()
  vim.cmd.colorscheme("catppuccin")  -- Tema 1 (catppuccin-mocha)
end, { desc = "Cambiar a tema 1" })

vim.keymap.set("n", "<leader>ct2", function()
  vim.cmd.colorscheme("rose-pine")   -- Tema 2 (rose-pine-moon)
end, { desc = "Cambiar a tema 2" })

vim.keymap.set("n", "<leader>ct3", function()
  vim.cmd.colorscheme("monokai-pro")   -- Tema 3 (monokai-pro)
end, { desc = "Cambiar a monokai-pro" })

-- keymaps.lua
local telescope = require("telescope.builtin")

-- Búsqueda de archivos por nombre (Ctrl+P)
vim.keymap.set("n", "<C-p>", telescope.find_files, { desc = "Buscar archivos" })

-- telescope-file-browser
vim.keymap.set("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true, silent = true })

-- Búsqueda en todo el proyecto (Ctrl+Shift+F)
vim.keymap.set("n", "<C-S-f>", telescope.live_grep, { desc = "Buscar texto en proyecto" })

-- Búsqueda en buffer actual
vim.keymap.set("n", "<leader>fg", telescope.current_buffer_fuzzy_find, { desc = "Buscar en buffer" })

-- Búsqueda en historial de archivos recientes
vim.keymap.set("n", "<leader>fr", telescope.oldfiles, { desc = "Archivos recientes" })

-- Ver estado de Git (como `git status`)
vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Estado de Git" })

-- Abrir Lazygit (interfaz visual)
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Abrir Lazygit" })

-- Diff contra HEAD
vim.keymap.set("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Ver diff" })

-- Git blame (culpable por línea)
vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<CR>", { desc = "Blame" })

-- Hacer commit
vim.keymap.set("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "Commit" })

-- Crear MR en GitLab (requiere `glab` instalado)
vim.keymap.set("n", "<leader>gm", "<cmd>!glab mr create --web<CR>", { desc = "Crear MR" })

-- Salir de Terminal-mode a Normal-mode con Esc en :terminal
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal a Normal con Esc" })
vim.keymap.set("t", "<A-h>", [[<C-\><C-n><C-w>h]], { desc = "Ir a ventana izquierda desde terminal" })
vim.keymap.set("t", "<A-j>", [[<C-\><C-n><C-w>j]], { desc = "Ir a ventana inferior desde terminal" })
vim.keymap.set("t", "<A-k>", [[<C-\><C-n><C-w>k]], { desc = "Ir a ventana superior desde terminal" })
vim.keymap.set("t", "<A-l>", [[<C-\><C-n><C-w>l]], { desc = "Ir a ventana derecha desde terminal" })
