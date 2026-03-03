require("lazy").setup({
  -- {
  --   "vhyrro/luarocks.nvim",
  --   priority = 1001,
  --   config = true,
  -- },

  -- 2. Plugins esenciales (LSP y Mason)
  { "neovim/nvim-lspconfig", commit = "0ef64599b8aa0187ee5f6d92cb39c951f348f041" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim", version = "v1.32.0" },

  -- 3. Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end,
  },

{
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    config = function()
      require("config.ufo")   -- 👈 carga la configuración desde lua/config/ufo.lua
    end,
  },


  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  -- 4. Tu tema de colores
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-storm") -- storm | night | moon
    end,
  },

  {
    "catppuccin/nvim",      -- Tema 1
    name = "catppuccin",
    lazy = false,
    priority = 1000,
  },

  {
    "rose-pine/neovim",     -- Tema 2
    name = "rose-pine",
    lazy = false,
    priority = 1000,
  },

  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup({
        filter = "pro",  -- "default" | "pro" | "ristretto" | "octagon"
      })
      vim.cmd.colorscheme("monokai-pro")
    end,
  },

  { "rebelot/kanagawa.nvim" },
  { "EdenEast/nightfox.nvim" },
  { "navarasu/onedark.nvim" },
  { "projekt0n/github-nvim-theme", name = "github-theme" },
  { "sainnhe/everforest" },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",          -- Requerido
      "BurntSushi/ripgrep",             -- Para búsquedas rápidas (instalación global)
      "sharkdp/fd",                     -- Alternativa rápida a 'find' (instalación global)
      "nvim-telescope/telescope-fzf-native.nvim", -- Mejora rendimiento
      {
        "nvim-telescope/telescope-file-browser.nvim", -- Explorador de archivos tipo VSCode
        dependencies = { "nvim-lua/plenary.nvim" }
      },
      build = "make",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "vertical",  -- Interfaz estilo VSCode
          layout_config = {
            vertical = { width = 0.9, height = 0.95 },
          },
          file_ignore_patterns = {
            "node_modules", ".git", "dist", "build"
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
          },
          file_browser = { -- Configuración específica del explorador de archivos
            hijack_netrw = true,  -- Reemplaza netrw con Telescope
            hidden = true,        -- Muestra archivos ocultos
            grouped = true,
            respect_gitignore = false,
          },
        },
        pickers = {
          find_files = {
            hidden = true
          }
        },
      })

      -- Carga extensión fzf para mejor performance
      -- require("telescope").load_extension("fzf")
      require("telescope").load_extension("file_browser")
    end
  },

  -- 5. Plugins adicionales (opcionales)
  { "tpope/vim-commentary" },
  { "tpope/vim-surround" },
  { "jiangmiao/auto-pairs" },  -- Auto-cierre de brackets

  -- 6. Integracion de Git
  {
    "nvim-lualine/lualine.nvim",
    -- dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.lualine")
    end,
  },

  -- Marcadores en el gutter (líneas modificadas/añadidas/eliminadas)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup()
      -- require("gitsigns").setup {
      --   signs = {
      --     add          = { text = "│" },
      --     change       = { text = "│" },
      --     delete       = { text = "_" },
      --     topdelete    = { text = "‾" },
      --     changedelete = { text = "~" },
      --     untracked    = { text = '┆' },
      --   },
      --   current_line_blame = true,  -- Muestra quién modificó la línea
      -- }
    end,
  },

  -- Interfaz avanzada para Git (commits, diffs, branches)
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit" },
  },

  -- Interfaz tipo GUI para Git (opcional pero muy útil)
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
  },

  -- Visualizar blame inline
  {
    "f-person/git-blame.nvim",
    config = function()
      require("gitblame").setup({ enabled = false })  -- Activar con comando
    end,
  },

  -- sistema de toma de notas diseñado para Neovim, similar a Org-mode de Emacs
  {
    "nvim-neorg/neorg",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.neorg").setup()
    end
  },

  { "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end
  },

  { "HiPhish/rainbow-delimiters.nvim",
    config = function()
      require("config.rainbow")
    end
  },
})
