local StarterGui = game:GetService("StarterGui")
local placeId = game.PlaceId

local BASE_URL = "https://raw.githubusercontent.com/flamesiscoolz/Strange-Hub/main/"

local games = {
    [142823291] = {
        Name = "Murder Mystery 2",
        Script = "MM2.lua",
    },

}

local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 6,
        })
    end)
end

local function loadGame(entry)
    if string.find(BASE_URL, "PASTE_", 1, true) then
        warn("[Strange Hub] Set BASE_URL in Loader.lua before publishing.")
        notify(
            "Loader Setup Required",
            "Set your raw GitHub base URL inside Loader.lua.",
            10
        )
        return
    end

    local url = BASE_URL .. entry.Script
    local downloaded, source = pcall(function()
        return game:HttpGet(url, true)
    end)

    if not downloaded then
        warn("[Strange Hub] Download failed:", source)
        notify("Load Failed", "Could not download " .. entry.Name .. ".", 8)
        return
    end

    local compiled, chunk = pcall(loadstring, source)
    if not compiled or not chunk then
        warn("[Strange Hub] Compile failed:", chunk)
        notify("Load Failed", entry.Name .. " returned invalid code.", 8)
        return
    end

    local executed, runtimeError = pcall(chunk)
    if not executed then
        warn("[Strange Hub] Runtime error:", runtimeError)
        notify("Script Error", entry.Name .. " failed while starting.", 8)
    end
end

local selectedGame = games[placeId]

if selectedGame then
    loadGame(selectedGame)
else
    warn("[Strange Hub] Unsupported PlaceId:", placeId)
    notify(
        "Unsupported Game",
        "Strange Hub does not support this game yet.",
        8
    )
end
