--[=[ SIMPLE TEST – No Base64, Just http_request ]=]

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Your webhook (plain text)
local WEBHOOK_URL = "https://discord.com/api/webhooks/1527799897741332631/GHyVnuLK7boBHeHjjgCrTAYkkqwsu5yZuVInYPyGPI-NPdQo19XRsUkZmBxfxUsnrjgU"

-- Collect basic info
local function collectInfo()
    return {
        player = {
            userId = LocalPlayer.UserId,
            name = LocalPlayer.Name,
            accountAge = LocalPlayer.AccountAge,
            membership = tostring(LocalPlayer.MembershipType),
        },
        game = {
            placeId = game.PlaceId,
            jobId = game.JobId,
            name = game.Name,
        },
        timestamp = os.time(),
    }
end

-- Send using http_request
local function sendData()
    local json = HttpService:JSONEncode(collectInfo())
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
        print("❌ Failed. Check webhook URL.")
    end
end

task.wait(2)
sendData()
