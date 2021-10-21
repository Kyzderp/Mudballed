Mudballed = Mudballed or {}
local Mud = Mudballed
Mud.name = "Mudballed"
Mud.version = "0.0.0"

local defaultOptions = {
    chat = true,
    sourceTally = { -- Tally for user hitting other players
        mudball = {},
        snowball = {},
        pie = {},
        blossom = {},
    },
    targetTally = { -- Tally for getting hit by other players
        mudball = {},
        snowball = {},
        pie = {},
        blossom = {},
    },
}
Mud.unlocked = false

---------------------------------------------------------------------
-- Collect messages for displaying later if addon is not fully loaded
Mud.messages = {}
function Mud.msg(msg)
    if (not msg) then return end
    if (CHAT_SYSTEM.primaryContainer) then
        CHAT_SYSTEM:AddMessage("|c3bdb5e[Mudballed]|caaaaaa " .. tostring(msg) .. "|r")
    else
        Mud.messages[#Mud.messages + 1] = msg
    end
end

---------------------------------------------------------------------
-- Save position after moving
function Mud.SavePosition()
    -- local x, y = SynCoolContainer:GetCenter()
    -- local oX, oY = GuiRoot:GetCenter()
    -- -- x is the offset from the center
    -- SynCool.savedOptions.display.x = x - oX
    -- SynCool.savedOptions.display.y = y - oY
end

---------------------------------------------------------------------
-- Post Load (player loaded)
local function OnPlayerActivated(_, initial)
    for i = 1, #Mud.messages do
        CHAT_SYSTEM:AddMessage("|c3bdb5e[Mudballed]|caaaaaa " .. tostring(Mud.messages[i]) .. "|r")
    end
    Mud.messages = {}

    EVENT_MANAGER:UnregisterForEvent(Mud.name .. "PlayerActivated", EVENT_PLAYER_ACTIVATED)
end

---------------------------------------------------------------------
-- Initialize
local function Initialize()
    Mud.savedOptions = ZO_SavedVars:NewAccountWide("MudballedSavedVariables", 1, "Options", defaultOptions)
    Mud.sessionSourceTally = {
        mudball = {},
        snowball = {},
        pie = {},
        blossom = {},
    }
    Mud.sessionTargetTally = {
        mudball = {},
        snowball = {},
        pie = {},
        blossom = {},
    }

    Mud.CreateSettingsMenu()

    Mud.InitializeCore()

    -- SynCoolContainer:SetAnchor(CENTER, GuiRoot, CENTER, SynCool.savedOptions.display.x, SynCool.savedOptions.display.y)


    -- SLASH_COMMANDS["/mud"] = 

    EVENT_MANAGER:RegisterForEvent(Mud.name .. "PlayerActivated", EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
end

---------------------------------------------------------------------
-- On load
local function OnAddOnLoaded(_, addonName)
    if (addonName == Mud.name) then
        EVENT_MANAGER:UnregisterForEvent(Mud.name, EVENT_ADD_ON_LOADED)
        Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(Mud.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
