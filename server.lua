local Core = exports.vorp_core:GetCore()
local IsEditing = {}
local positivAdminchecks = {}

print("Hallo Server")

local function sendCheaterNotify(source)
    Core.NotifyAvanced(source, "Netter Versuch, eine Nachricht wurde an den Support gesendet.",
        "multiwheel_emotes",
        "emote_two_fingers",
        "COLOR_RED",
        4000)
end

local function startEditor(source, args)
    print("geht los ??")
    local user = Core.getUser(source) --[[@as User]]
    if not user then return end -- is player in session?
    local character = user.getUsedCharacter --[[@as Character]]
    local steamId = character.identifier

    if not Config.Permissions[steamId] or character.group ~= "admin" then
        print("hallooo ??")

        sendCheaterNotify(source)
        exports.sns_utils:SendCheaterDiscordMessage(source, "Editor öffnen")
        return
    end

    positivAdminchecks[source] = true
    TriggerClientEvent("ludwig_editor:showEditOptions", source, Config.FilesToEdit)
end

lib.addCommand('editor', {
    help = 'Open the File Editor | Admin Only'
}, function(source, args, raw)
    startEditor(source, args)
end)

RegisterServerEvent("ludwig_editor:selectedFileToEdit")
AddEventHandler("ludwig_editor:selectedFileToEdit", function(file)
    Print("auf gehts mit selectedFileToEdit")
    local src = source
    local fileData = file.fileData
    local fileName = file.fileName

    if not Config.FilesToEdit[fileName] or not DeepEqual(Config.FilesToEdit[fileName], fileData) or not positivAdminchecks[src] then
        sendCheaterNotify(src)
        exports.sns_utils:SendCheaterDiscordMessage(src, "Nicht freigeschaltener File ausgewählt")
        DebugPrint("fehlende Persmissions oder DeepEqual fehlgeschlagen")
        return
    end

    if IsEditing[file.path] then
        Core.NotifyAvanced(source, "Ein anderer Admin editiert diese Datei gerade.",
            "multiwheel_emotes",
            "emote_action_hypnosis_pocket_watch_1",
            "COLOR_PURE_WHITE",
            4000)
        return
    end

    IsEditing[fileData.path] = true

    DebugPrint(json.encode(IsEditing))

    local editFileData = LoadResourceFile(fileData.script, fileData.path)
    TriggerClientEvent("ludwig_editor:startEditor", src, editFileData, file)
end)


RegisterCommand("Testerino", function()
    startEditor(1, nil)
end)

function DeepEqual(t1, t2)
    if type(t1) ~= "table" or type(t2) ~= "table" then
        return t1 == t2
    end

    local keys1 = 0
    for _ in pairs(t1) do keys1 = keys1 + 1 end

    local keys2 = 0
    for _ in pairs(t2) do keys2 = keys2 + 1 end

    if keys1 ~= keys2 then return false end

    for k, v in pairs(t1) do
        if not DeepEqual(v, t2[k]) then
            return false
        end
    end

    return true
end

RegisterServerEvent("ludwig_editor:saveFile", function(data)
    Print(data)

    local src = source
    local fileName = data.file?.fileName
    local fileData = data.file?.fileData
    local resourceName = fileData.script

    local fileContent = data.content

    if not Config.FilesToEdit[fileName] or Config.FilesToEdit[fileName].script ~= resourceName or Config.FilesToEdit[fileName].path ~= fileData.path then
        exports.sns_utils:SendCheaterDiscordMessage(src, "Nicht freigeschaltenes File editiert")
        sendCheaterNotify(src)
        return
    end

    local oldPath = Config.FilesToEdit[fileName].path
    local newPath = string.gsub(oldPath, "%.lua$", "")



    local retval --[[ boolean ]] = SaveResourceFile(resourceName, newPath, fileContent, -1)

    if not retval then
        Core.NotifyAvanced(src, "Das speichern war fehlerhaft.",
            "multiwheel_emotes",
            "emote_boo_hoo",
            "COLOR_RED",
            4000)
        return
    end

    Core.NotifyAvanced(src, "Hoffentlich kein Syntaxfehler, File wurde gespeichert.",
        "multiwheel_emotes",
        "emote_greet_tip_hat",
        "COLOR_PURE_WHITE",
        4000)
end)
