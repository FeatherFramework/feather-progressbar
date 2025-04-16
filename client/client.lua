-- Queue all progress tasks to prevent infinite loops and overlap
local queue = {}
local cancelCallback = nil -- Added to allow external cancel callback

local function _internalStart(message, miliseconds, cb, theme, color, width, focus)
    if theme == nil then theme = "linear" end
    if color == nil then color = 'rgb(124, 45, 45)' end
    if width == nil then width = '20vw' end

    table.insert(queue, {
        message = message,
        callback = cb,
        focus = focus
    })

    if focus == nil or focus == true then
        SetNuiFocus(true, false)
    end

    SendNUIMessage({
        type = 'open',
        message = message,
        mili = miliseconds,
        theme = theme,
        color = color,
        width = width
    })
end

exports('initiate', function()
    local self = {}
    self.start = _internalStart

    -- Add a cancel hook externally
    self.onCancel = function(cb)
        cancelCallback = cb
    end

    return self
end)

exports('cancelCurrentProgressBar', function()
    SendNUIMessage({ type = "cancel" })
    SetNuiFocus(false, false)
    queue = {}
end)

-- Support legacy export from other progressBar resources
AddEventHandler('__cfx_export_progressBars_startUI', function(callback)
    callback(function (time, text)
        _internalStart(text, time, nil, nil, nil, nil, false)
    end)
end)

-- When progress finishes
RegisterNUICallback('Feather:Prog:Finish', function(args, nuicb)
    if queue[1] and queue[1].focus ~= false then
        SetNuiFocus(false, false)
    end

    if queue[1] and queue[1].callback then
        queue[1].callback()
    end

    table.remove(queue, 1)
    nuicb('ok')
end)

-- When progress is cancelled manually
RegisterNUICallback('Feather:Prog:Cancel', function(args, cb)
    if queue[1] and queue[1].focus ~= false then
        SetNuiFocus(false, false)
    end

    queue = {}

    -- If cancel handler was registered externally
    if cancelCallback then
        cancelCallback()
    end

    cb('ok')
end)
