require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "angular",
    "bash",
    "html",
    "norg",
    "json",
    "jsonc",
    "javascript",
    "lua",
    "typescript",
    "python",
    "xml",
    "yaml",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  fold = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    additional_vim_regex_highlighting = false, -- Desactiva regex de Vim
    custom_captures = {
      ["function.call"] = "TSFunction", -- Personaliza capturas
    },
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
})
