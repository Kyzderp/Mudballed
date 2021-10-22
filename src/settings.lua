Mudballed = Mudballed or {}
local Mud = Mudballed

function Mud.CreateSettingsMenu()
    local LAM = LibAddonMenu2
    local panelData = {
        type = "panel",
        name = "Mudballed",
        author = "Kyzeragon",
        version = Mud.version,
        registerForRefresh = true,
        registerForDefaults = true,
    }

    local optionsData = {
        {
            type = "checkbox",
            name = "Show chat message",
            tooltip = "Show a chat message when you hit someone with a mudball, snowball, revelry pie, or cherry blossom, or vice versa",
            default = true,
            getFunc = function() return Mud.savedOptions.chat end,
            setFunc = function(value) Mud.savedOptions.chat = value end,
            width = "full",
        },
        {
            type = "checkbox",
            name = "Show mudballed victims tally",
            tooltip = "Show a UI tally of players you have mudballed, snowballed, pied, or covered in cherry blossoms. This can also be toggled with |c88FF88/mudballed|r",
            default = true,
            getFunc = function() return Mud.savedOptions.sourceDisplay.show end,
            setFunc = function(value) Mud.savedOptions.sourceDisplay.show = value end,
            width = "full",
        },
        {
            type = "checkbox",
            name = "Show mudball attackers",
            tooltip = "Show a UI tally of players who have hit you with mudballs, snowballs, pies, or cherry blossoms.  This can also be toggled with |c88FF88/mudball|r",
            default = true,
            getFunc = function() return Mud.savedOptions.targetDisplay.show end,
            setFunc = function(value) Mud.savedOptions.targetDisplay.show = value end,
            width = "full",
        },
        {
            type = "slider",
            name = "Tally size",
            tooltip = "The number of lines to show in the tally before it starts scrolling",
            min = 2,
            max = 30,
            step = 1,
            default = 10,
            width = full,
            getFunc = function() return Mud.savedOptions.capLines end,
            setFunc = function(value)
                Mud.savedOptions.capLines = value
                MudballedContainer:SetHidden(false)
                MudballedSourceTally:SetHidden(false)
                Mud.UpdateAllTallies()
            end,
        },
    }

    Mud.addonPanel = LAM:RegisterAddonPanel("MudballedOptions", panelData)
    LAM:RegisterOptionControls("MudballedOptions", optionsData)

    CALLBACK_MANAGER:RegisterCallback("LAM-PanelClosed", Mud.InitializeDisplay)
end