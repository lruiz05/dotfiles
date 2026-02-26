vim.g.mapleader = " "  -- Tecla líder (espacio)
local telescope = require("telescope.builtin")

local function toggle_terminal()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)
  if vim.bo[current_buf].buftype == "terminal" then
    vim.cmd.close()
    return
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_set_current_win(win)
      vim.cmd.startinsert()
      return
    end
  end

  vim.cmd("botright split | terminal")
  vim.cmd.startinsert()
end

local function with_gitsigns(fn)
  return function()
    local ok, gitsigns = pcall(require, "gitsigns")
    if not ok then
      vim.notify("gitsigns no esta disponible", vim.log.levels.WARN)
      return
    end
    fn(gitsigns)
  end
end

-- Navegación entre ventanas
vim.keymap.set("n", "<A-h>", "<C-w>h", { desc = "Ventana izquierda (Alt+h)" })
vim.keymap.set("n", "<A-j>", "<C-w>j", { desc = "Ventana inferior (Alt+j)" })
vim.keymap.set("n", "<A-k>", "<C-w>k", { desc = "Ventana superior (Alt+k)" })
vim.keymap.set("n", "<A-l>", "<C-w>l", { desc = "Ventana derecha (Alt+l)" })
-- Alternativas portables para terminales donde Alt no se captura bien
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Ventana izquierda" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Ventana inferior" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Ventana superior" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Ventana derecha" })

-- Gestión de buffers
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Cerrar buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Siguiente buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })
vim.keymap.set("n", "<leader>bl", telescope.buffers, { desc = "Listar buffers" })
vim.keymap.set("n", "<leader>bo", "<cmd>%bd|e#|bd#<CR>", { desc = "Cerrar otros buffers" })

-- Guardar y salir
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Guardar archivo" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Cerrar ventana" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Salir sin guardar" })

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

-- Búsqueda de archivos por nombre (Ctrl+P)
vim.keymap.set("n", "<C-p>", telescope.find_files, { desc = "Buscar archivos" })
vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Buscar archivos" })
vim.keymap.set("n", "<leader>fc", function()
  telescope.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Buscar en config de Neovim" })

-- telescope-file-browser
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>", { desc = "Explorador de archivos", noremap = true, silent = true })

-- Búsqueda en todo el proyecto.
-- Nota: <C-S-f> no suele distinguirse en la mayoría de terminales.
vim.keymap.set("n", "<leader>fs", telescope.live_grep, { desc = "Buscar texto en proyecto" })

-- Búsqueda en buffer actual
vim.keymap.set("n", "<leader>fg", telescope.current_buffer_fuzzy_find, { desc = "Buscar en buffer" })

-- Buscar palabra bajo el cursor en el proyecto
vim.keymap.set("n", "<leader>fw", telescope.grep_string, { desc = "Buscar palabra bajo cursor" })

-- Búsqueda en historial de archivos recientes
vim.keymap.set("n", "<leader>fr", telescope.oldfiles, { desc = "Archivos recientes" })
vim.keymap.set("n", "<leader>fk", telescope.keymaps, { desc = "Buscar keymaps" })
vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Buscar en :help" })

-- Ver estado de Git (como `git status`)
vim.keymap.set("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Estado de Git" })
vim.keymap.set("n", "]h", with_gitsigns(function(gs) gs.next_hunk() end), { desc = "Siguiente hunk" })
vim.keymap.set("n", "[h", with_gitsigns(function(gs) gs.prev_hunk() end), { desc = "Hunk anterior" })
vim.keymap.set("n", "<leader>gp", with_gitsigns(function(gs) gs.preview_hunk() end), { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>gr", with_gitsigns(function(gs) gs.reset_hunk() end), { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>gS", with_gitsigns(function(gs) gs.stage_hunk() end), { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>gu", with_gitsigns(function(gs) gs.undo_stage_hunk() end), { desc = "Unstage hunk" })

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

-- Utilidades
vim.keymap.set("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Quitar resaltado de búsqueda" })
vim.keymap.set({ "n", "t" }, "<leader>tt", toggle_terminal, { desc = "Toggle terminal" })

-- Salir de Terminal-mode a Normal-mode con Esc en :terminal
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal a Normal con Esc" })
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Terminal a Normal con Esc Esc" })
vim.keymap.set("t", "<A-h>", [[<C-\><C-n><C-w>h]], { desc = "Ir a ventana izquierda desde terminal" })
vim.keymap.set("t", "<A-j>", [[<C-\><C-n><C-w>j]], { desc = "Ir a ventana inferior desde terminal" })
vim.keymap.set("t", "<A-k>", [[<C-\><C-n><C-w>k]], { desc = "Ir a ventana superior desde terminal" })
vim.keymap.set("t", "<A-l>", [[<C-\><C-n><C-w>l]], { desc = "Ir a ventana derecha desde terminal" })
