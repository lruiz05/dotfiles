local M = {}

M.setup = function()
  local rainbow_delimiters = require("rainbow-delimiters")
  vim.g.rainbow_delimiters = {
    strategy = {
      [""] = rainbow_delimiters.strategy.global,
    },
    query = {
      [""] = "rainbow-delimiters",
      lua = "rainbow-blocks", -- Mejor estructura en Lua
      javascript = "rainbow-delimiters", -- Habilita en JavaScript
      json = "rainbow-delimiters", -- Habilita en JSON
    },
    highlight = {
      "RainbowDelimiterRed",
      "RainbowDelimiterYellow",
      "RainbowDelimiterBlue",
      "RainbowDelimiterOrange",
      "RainbowDelimiterGreen",
      "RainbowDelimiterViolet",
      "RainbowDelimiterCyan",
    }
  }
end

return M
