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
    }

    Mud.addonPanel = LAM:RegisterAddonPanel("MudballedOptions", panelData)
    LAM:RegisterOptionControls("MudballedOptions", optionsData)
end