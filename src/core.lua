Mudballed = Mudballed or {}
local Mud = Mudballed

---------------------------------------------------------------------
local charName = zo_strformat("<<1>>", GetUnitName("player"))

local BALL_TYPE = {
    MUDBALL = 1,
    SNOWBALL = 2,
    PIE = 3,
    BLOSSOM = 4,
}

local BALL_DATA = {
    [BALL_TYPE.MUDBALL] = {
        id = 86774, -- Mudball
        name = "mudball",
        npcFormat = "You mudballed |cFFFFFF%s|cAAAAAA! NPCs don't count for tally though ;)",
        sourceFormat = "You mudballed |cFFFFFF%s|cAAAAAA! You've mudballed them %d times in total.",
        targetFormat = "|cFFFFFF%s |cAAAAAAmudballed you! They've mudballed you %d times in total.",
    },
    [BALL_TYPE.SNOWBALL] = {
        id = 129540, -- Memento Throw Snowball
        name = "snowball",
        npcFormat = "You pelted |cFFFFFF%s |cAAAAAAwith a snowball! NPCs don't count for tally though ;)",
        sourceFormat = "You pelted |cFFFFFF%s |cAAAAAAwith a snowball! You've snowballed them %d times in total.",
        targetFormat = "|cFFFFFF%s |cAAAAAApelted you with a snowball! They've snowballed you %d times in total.",
    },
    [BALL_TYPE.PIE] = {
        id = 116879, -- Alliance Pie
        name = "pie",
        npcFormat = "You pied |cFFFFFF%s|cAAAAAA! NPCs don't count for tally though ;)",
        sourceFormat = "You pied |cFFFFFF%s|cAAAAAA! You've pied them %d times in total.",
        targetFormat = "|cFFFFFF%s |cAAAAAApied you! They've pied you %d times in total.",
    },
    [BALL_TYPE.BLOSSOM] = {
        id = 89372, -- Pelted!
        name = "blossom",
        npcFormat = "You showered |cFFFFFF%s |cAAAAAAwith cherry blossoms! NPCs don't count for tally though ;)",
        sourceFormat = "You showered |cFFFFFF%s |cAAAAAAwith cherry blossoms! You've blessed them %d times in total.",
        targetFormat = "|cFFFFFF%s |cAAAAAAshowered you with cherry blossoms! They've blessed you %d times in total.",
    },
}


---------------------------------------------------------------------
local unitType = {
    [COMBAT_UNIT_TYPE_GROUP] = "GROUP",
    [COMBAT_UNIT_TYPE_NONE] = "NONE",
    [COMBAT_UNIT_TYPE_OTHER] = "OTHER",
    [COMBAT_UNIT_TYPE_PLAYER] = "PLAYER",
    [COMBAT_UNIT_TYPE_PLAYER_PET] = "PLAYER_PET",
    [COMBAT_UNIT_TYPE_TARGET_DUMMY] = "TARGET_DUMMY",
}

local function OnBalled(ballType, sourceName, sourceType, targetName, targetType)
    sourceName = zo_strformat("<<1>>", sourceName)
    targetName = zo_strformat("<<1>>", targetName)

    local ballData = BALL_DATA[ballType]
    local tally, sessionTally, otherPlayer, format

    --------------------
    -- We balled someone, we are the source
    if (sourceName == charName) then
        if (targetType == COMBAT_UNIT_TYPE_NONE) then Mud.msg(string.format(ballData.npcFormat, targetName)) return end
        format = ballData.sourceFormat
        if (targetType == COMBAT_UNIT_TYPE_NONE) then return end
        tally = Mud.savedOptions.sourceTally[ballData.name]
        sessionTally = Mud.sessionSourceTally[ballData.name]
        otherPlayer = targetName

    --------------------
    -- Someone balled us, we are the target
    elseif (targetName == charName) then
        format = ballData.targetFormat
        tally = Mud.savedOptions.targetTally[ballData.name]
        sessionTally = Mud.sessionTargetTally[ballData.name]
        otherPlayer = sourceName

    --------------------
    -- Someone balled someone else, we get these events but no source/target names
    else
        return
    end

    ----------------------------------------------------------
    -- Increment data
    if (not tally[otherPlayer]) then
        tally[otherPlayer] = 0
    end
    tally[otherPlayer] = tally[otherPlayer] + 1

    if (not sessionTally[otherPlayer]) then
        sessionTally[otherPlayer] = 0
    end
    sessionTally[otherPlayer] = sessionTally[otherPlayer] + 1

    --------
    -- Print
    if (Mud.savedOptions.chat) then
        Mud.msg(string.format(format, otherPlayer, tally[otherPlayer]))
    end
end


---------------------------------------------------------------------
-- EVENT_COMBAT_EVENT (number eventCode, number ActionResult result, boolean isError, string abilityName, number abilityGraphic, number ActionSlotType abilityActionSlotType, string sourceName, number CombatUnitType sourceType, string targetName, number CombatUnitType targetType, number hitValue, number CombatMechanicType powerType, number DamageType damageType, boolean log, number sourceUnitId, number targetUnitId, number abilityId, number overflow)
function Mud.InitializeCore()
    for ballType, data in pairs(BALL_DATA) do
        EVENT_MANAGER:RegisterForEvent(Mud.name .. data.name, EVENT_COMBAT_EVENT, function(_, _, _, _, _, _, sourceName, sourceType, targetName, targetType, hitValue)
                if (hitValue == 1) then
                    OnBalled(ballType, sourceName, sourceType, targetName, targetType)
                end
            end)
        EVENT_MANAGER:AddFilterForEvent(Mud.name .. data.name, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, data.id)
        EVENT_MANAGER:AddFilterForEvent(Mud.name .. data.name, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_EFFECT_GAINED)
    end
end
