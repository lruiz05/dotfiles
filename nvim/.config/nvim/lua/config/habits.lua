local M = {}

local notes_root = vim.fn.expand("~/Notes")
local journal_root = notes_root .. "/Journal"

local DAY = 24 * 60 * 60

local function midnight(ts)
  local d = os.date("*t", ts)
  d.hour = 0
  d.min = 0
  d.sec = 0
  return os.time(d)
end

local function week_range(ts)
  local now = midnight(ts or os.time())
  local wday = tonumber(os.date("%w", now)) -- 0=sunday, 1=monday, ...
  local offset = (wday + 6) % 7 -- monday-based
  local start_ts = now - (offset * DAY)
  local end_ts = start_ts + (6 * DAY)
  return start_ts, end_ts
end

local function month_range(ts)
  local d = os.date("*t", ts or os.time())
  d.day = 1
  d.hour = 0
  d.min = 0
  d.sec = 0
  local start_ts = os.time(d)
  local next_month = {
    year = d.year,
    month = d.month + 1,
    day = 1,
    hour = 0,
    min = 0,
    sec = 0,
  }
  local end_ts = os.time(next_month) - DAY
  return start_ts, end_ts
end

local function day_path(ts)
  return string.format(
    "%s/%s/%s/%s.norg",
    journal_root,
    os.date("%Y", ts),
    os.date("%m", ts),
    os.date("%d", ts)
  )
end

local function heading_is_habits(line)
  local heading = line:match("^%*+%s+(.+)%s*$")
  if not heading then
    return false
  end
  local lower = heading:lower()
  return lower == "habitos" or lower == "hábitos" or lower == "habits"
end

local function parse_habits_in_day(path)
  if vim.fn.filereadable(path) ~= 1 then
    return nil
  end

  local lines = vim.fn.readfile(path)
  local in_habits = false
  local entries = {}

  for _, line in ipairs(lines) do
    if not in_habits then
      if heading_is_habits(line) then
        in_habits = true
      end
    else
      if line:match("^%*+%s+") then
        break
      end
      local state, name = line:match("^%s*%- %[(.)%]%s+(.+)%s*$")
      if state and name then
        if state ~= " " and state ~= "-" and state ~= "x" and state ~= ">" then
          state = " "
        end
        entries[#entries + 1] = {
          state = state,
          name = vim.trim(name),
        }
      end
    end
  end

  return entries
end

local function new_counts()
  return { done = 0, in_progress = 0, postponed = 0, pending = 0, total = 0 }
end

local function aggregate_range(start_ts, end_ts)
  local habits = {}
  local days = {}
  local total_days = 0
  local with_notes = 0

  for ts = start_ts, end_ts, DAY do
    total_days = total_days + 1
    local date = os.date("%Y-%m-%d", ts)
    local path = day_path(ts)
    local entries = parse_habits_in_day(path)
    local day = { date = date, path = path, missing = false, entries = {} }

    if entries == nil then
      day.missing = true
    else
      with_notes = with_notes + 1
      for _, entry in ipairs(entries) do
        local c = habits[entry.name] or new_counts()
        c.total = c.total + 1
        if entry.state == "x" then
          c.done = c.done + 1
        elseif entry.state == "-" then
          c.in_progress = c.in_progress + 1
        elseif entry.state == ">" then
          c.postponed = c.postponed + 1
        else
          c.pending = c.pending + 1
        end
        habits[entry.name] = c
        day.entries[#day.entries + 1] = entry
      end
    end

    days[#days + 1] = day
  end

  return {
    habits = habits,
    days = days,
    total_days = total_days,
    with_notes = with_notes,
  }
end

local function sorted_habit_names(habits)
  local names = {}
  for name, _ in pairs(habits) do
    names[#names + 1] = name
  end
  table.sort(names)
  return names
end

local function pct(done, total)
  if total == 0 then
    return 0
  end
  return math.floor((done / total) * 100 + 0.5)
end

local function build_report_lines(kind, start_ts, end_ts, aggregate)
  local start_str = os.date("%Y-%m-%d", start_ts)
  local end_str = os.date("%Y-%m-%d", end_ts)
  local title = (kind == "week" and "Weekly Habits" or "Monthly Habits")
  local names = sorted_habit_names(aggregate.habits)

  local lines = {
    "@document.meta",
    string.format("title: %s %s -> %s", title, start_str, end_str),
    "description: Reporte generado desde Journal diario",
    "authors: Felipe",
    "@end",
    "",
    "* Resumen",
    string.format("- Periodo: %s -> %s", start_str, end_str),
    string.format("- Dias con nota: %d/%d", aggregate.with_notes, aggregate.total_days),
    '- Regla de parseo: solo seccion "Habitos/Hábitos" con items "- [ ]".',
    "",
    "* Habitos (totales)",
  }

  if #names == 0 then
    lines[#lines + 1] = "- No se encontraron habitos en el periodo."
  else
    for _, name in ipairs(names) do
      local c = aggregate.habits[name]
      lines[#lines + 1] = string.format(
        "- %s :: [x]=%d [-]=%d [>]=%d [ ]=%d | cumplimiento=%d%%",
        name,
        c.done,
        c.in_progress,
        c.postponed,
        c.pending,
        pct(c.done, c.total)
      )
    end
  end

  lines[#lines + 1] = ""
  lines[#lines + 1] = "* Registro por dia"
  for _, day in ipairs(aggregate.days) do
    lines[#lines + 1] = string.format("** %s", day.date)
    if day.missing then
      lines[#lines + 1] = "- Sin nota diaria."
    elseif #day.entries == 0 then
      lines[#lines + 1] = '- Nota encontrada, sin items en seccion "Habitos".'
    else
      for _, entry in ipairs(day.entries) do
        lines[#lines + 1] = string.format("- [%s] %s", entry.state, entry.name)
      end
    end
    lines[#lines + 1] = ""
  end

  return lines
end

local function report_path(kind, start_ts, end_ts)
  local year = os.date("%Y", start_ts)
  local month = os.date("%m", start_ts)
  if kind == "week" then
    return string.format(
      "%s/%s/%s/week-%s_to_%s.norg",
      journal_root,
      year,
      month,
      os.date("%Y-%m-%d", start_ts),
      os.date("%Y-%m-%d", end_ts)
    )
  end
  return string.format("%s/%s/%s/month-%s-%s.norg", journal_root, year, month, year, month)
end

local function write_report(kind, start_ts, end_ts)
  local aggregate = aggregate_range(start_ts, end_ts)
  local lines = build_report_lines(kind, start_ts, end_ts, aggregate)
  local path = report_path(kind, start_ts, end_ts)
  vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
  vim.fn.writefile(lines, path)
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  vim.notify("Habits report generado: " .. path, vim.log.levels.INFO)
end

function M.generate_week()
  local start_ts, end_ts = week_range()
  write_report("week", start_ts, end_ts)
end

function M.generate_month()
  local start_ts, end_ts = month_range()
  write_report("month", start_ts, end_ts)
end

vim.api.nvim_create_user_command("WeekHabits", function()
  M.generate_week()
end, { desc = "Genera reporte semanal de habitos desde Journal diario" })

vim.api.nvim_create_user_command("MonthHabits", function()
  M.generate_month()
end, { desc = "Genera reporte mensual de habitos desde Journal diario" })

return M
