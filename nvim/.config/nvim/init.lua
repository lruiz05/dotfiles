-- ~/.config/nvim/init.lua
--vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("config.lazy")
-- require("lazy").setup({
--   -- Gestor de plugins (obligatorio)
--   { "folke/lazy.nvim" },

--   -- Plugins esenciales
--   { "neovim/nvim-lspconfig" },              -- LSP
--   { "williamboman/mason.nvim" },            -- Instalador de LSPs
--   { "williamboman/mason-lspconfig.nvim" },  -- Integración Mason-LSP
--   { "nvim-treesitter/nvim-treesitter" },    -- Treesitter
--   { "folke/tokyonight.nvim" },              -- Tema de colores
--   { "catppuccin/nvim" },
--   { "rose-pine/neovim" },
--   { "loctvl842/monokai-pro.nvim" },

--  -- Plugins de productividad
--   { "tpope/vim-commentary" },               -- Comentarios con `gc`
--   { "tpope/vim-surround" },                 -- Rodear texto con `ys`
--   { "jiangmiao/auto-pairs" },               -- Auto-cierre de brackets
--   { "akinsho/bufferline.nvim" },            -- Pestañas de buffers
--   { "nvim-telescope/telescope.nvim" },

--  -- Plugins de Git
--   { "nvim-lualine/lualine.nvim" },
--   { "lewis6991/gitsigns.nvim" },
--   { "tpope/vim-fugitive" },
--   { "nvim-tree/nvim-web-devicons" }, -- tal vez no se use eso
--   { "kdheepak/lazygit.nvim" },
--   { "f-person/git-blame.nvim" },
-- })

-- Cargar configuraciones después de los plugins
require("config.lsp")        -- Configuración LSP
require("config.treesitter") -- Configuración Treesitter
require("config.keymaps")    -- Keymaps personalizados
require("config.lualine")

local osd_ok, osd = pcall(require, "osdetect")
if osd_ok and osd.is_linux then
  require("config.linux").setup()
end

-- Tema de colores
vim.cmd.colorscheme("tokyonight-night")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'  -- Integración con clipboard del sistema
vim.opt.foldcolumn = "1"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
vim.opt.smartindent = true
vim.opt.autoindent = true
