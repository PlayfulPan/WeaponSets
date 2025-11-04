----------------------------------------------------------------
-- WeaponSets: list / create / update / delete equipment sets
--   /ws list
--   /ws create "<name>"     -- only if it doesn't already exist
--   /ws update "<name>"     -- must already exist
--   /ws delete "<name>"
----------------------------------------------------------------

local c = C_EquipmentSet

-- ---- Config ----
local COLOR_HEX = "ff00ff88"                      -- AARRGGBB
local PREFIX = "|c" .. COLOR_HEX .. "[WeaponSets]|r "

-- Print helper
local function say(...)
  local parts = {}
  for i = 1, select("#", ...) do parts[i] = tostring(select(i, ...)) end
  DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. table.concat(parts, " "))
end

-- ---- Simple quoted-args splitter ----
local function split_args(text)
  local args, buf, quote = {}, {}, nil
  text = tostring(text or "")
  text = text:gsub("^%s+", ""):gsub("%s+$", "")
  local function push() if #buf > 0 then table.insert(args, table.concat(buf)); buf = {} end end
  for i = 1, #text do
    local c = text:sub(i,i)
    if quote then
      if c == quote then quote = nil else table.insert(buf, c) end
    else
      if c == '"' or c == "'" then quote = c
      elseif c:match("%s") then push()
      else table.insert(buf, c) end
    end
  end
  push()
  return args
end

-- ---- Small helpers ----

local function IgnoreArmorSlots()
  C_EquipmentSet.ClearIgnoredSlotsForSave()
  for slot = 1, 19 do
    if slot ~= 16 and slot ~= 17 then
      c.IgnoreSlotForSave(slot)
    end
  end
end

-- ---- Commands ----
local function ListSets()
  local ids = c.GetEquipmentSetIDs() or {}
  if #ids == 0 then return say("No weapon sets found.") end
  say("Weapon sets:")
  for i, id in ipairs(ids) do
    local name = c.GetEquipmentSetInfo(id)
    say(("[%d] '%s'"):format(i, name or "?"))
  end
end

-- create only if name is new
local function CreateSet(setName)
  if not setName or setName == "" then
    return say('Usage: /ws create "<name>"')
  end
  if c.GetEquipmentSetID(setName) then
    return say(("Create failed: a set named '%s' already exists."):format(setName))
  end
  IgnoreArmorSlots()
  c.CreateEquipmentSet(setName)
  local id = c.GetEquipmentSetID(setName)
  c.SaveEquipmentSet(id)  -- saves MH/OH only due to ignore list
  say(("Created set '%s' using current weapons."):format(setName))
end

-- update must already exist
local function UpdateSet(setName)
  if not setName or setName == "" then
    return say('Usage: /ws update "<name>"')
  end
  local id = c.GetEquipmentSetID(setName)
  if not id then
    return say(("Update failed: set '%s' not found."):format(setName))
  end
  IgnoreArmorSlots()
  c.SaveEquipmentSet(id)
  say(("Updated set '%s' using current weapons."):format(setName))
end

local function DeleteSet(setName)
  if not setName or setName == "" then
    return say('Usage: /ws delete "<name>"')
  end
  local id = c.GetEquipmentSetID(setName)
  if not id then
    return say(("Set not found: '%s'"):format(setName))
  end
  c.DeleteEquipmentSet(id)
  say(("Deleted set '%s'."):format(setName))
end

-- ---- Slash command wiring ----
SLASH_WS1 = "/ws"
SlashCmdList.WS = function(msg)
  local a = split_args(msg)
  local cmd = (a[1] or ""):lower()
  if     cmd == "list"   then ListSets()
  elseif cmd == "create" then CreateSet(a[2])
  elseif cmd == "update" then UpdateSet(a[2])
  elseif cmd == "delete" then DeleteSet(a[2])
  else
    say("Commands:")
    say('  /ws list -- lists weapon sets')
    say('  /ws create <name> -- creates a new weapon set using current weapons')
    say('  /ws update <name> -- updates an existing weapon set using current weapons')
    say('  /ws delete <name> -- deletes an existing weapon set')
  end
end
