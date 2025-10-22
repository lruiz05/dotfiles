-- Detecta sistema operativo
local M = {}
local sys = vim.loop.os_uname().sysname
M.is_mac   = (sys == "Darwin")
M.is_linux = (sys == "Linux")
return M

