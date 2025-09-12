RegisterNetEvent("ludwig_editor:showEditOptions")
AddEventHandler("ludwig_editor:showEditOptions", function(editableFiles)
    Print("files sollten angezeigt werden")
    Print(json.encode(editableFiles))

    local message = {
        action = 'showMenu',
        files = editableFiles
    }

    SendNUIMessage(json.encode(message))
    SetNuiFocus(true, true)
end)

function serializeToEditorString(data)
    -- If data is a string, we simply return it. We also add quotes to make it clear it's a string.
    if type(data) == "string" then
        return string.format('"%s"', data)
        -- For numbers and booleans, tostring() works perfectly.
    elseif type(data) == "number" or type(data) == "boolean" then
        return tostring(data)
        -- If data is a function, we return its string representation.
    elseif type(data) == "function" then
        return tostring(data)
        -- Handle tables (arrays and objects)
    elseif type(data) == "table" then
        local serialized_parts = {}
        -- Check if it's an array-like table.
        local is_array = true
        for k, v in ipairs(data) do
            if k ~= v then
                is_array = false
                break
            end
        end

        if is_array then
            -- If it's an array, we'll format it like a JSON array.
            for _, value in ipairs(data) do
                table.insert(serialized_parts, serializeToEditorString(value))
            end
            return string.format("[%s]", table.concat(serialized_parts, ", "))
        else
            -- Otherwise, it's an object (key-value pairs).
            for key, value in pairs(data) do
                local key_str = serializeToEditorString(key)
                local value_str = serializeToEditorString(value)
                table.insert(serialized_parts, string.format("%s: %s", key_str, value_str))
            end
            return string.format("{%s}", table.concat(serialized_parts, ", "))
        end
        -- For any other type (e.g., userdata, thread, etc.), tostring() is the best we can do.
    else
        return tostring(data)
    end
end

RegisterNetEvent("ludwig_editor:startEditor")
AddEventHandler("ludwig_editor:startEditor", function(editFileData, file)
    -- local fileContent = serializeToEditorString(editFileData)
    local message = {
        action = 'openEditor',
        files = editFileData,
        fileMeta = file
    }

    Print(json.encode(message))
    print(file.path)

    SendNUIMessage(json.encode(message))
    SetNuiFocus(true, true)
end)


function CloseUI()
    local message = {
        action = 'hideUi',
    }

    SendNUIMessage(json.encode(message))
    SetNuiFocus(false, false)
end

RegisterNUICallback('selectFile', function(data, cb)
    Print(data)
    CloseUI()
    TriggerServerEvent("ludwig_editor:selectedFileToEdit", data)
    cb({ "ok" })
end)

RegisterNUICallback("hideUi", function(data, cb)
    CloseUI()
    cb({ "ok" })
end)

RegisterCommand("testEditor", function()
    local message = {
        action = 'DebugEditor',
    }

    SendNUIMessage(json.encode(message))
    SetNuiFocus(true, true)
end)

RegisterNUICallback('saveFile', function(data, cb)
    Print(data)
    CloseUI()
    TriggerServerEvent("ludwig_editor:saveFile", data)
    cb({ "ok" })
end)
