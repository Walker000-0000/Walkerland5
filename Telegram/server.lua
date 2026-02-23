RegisterNetEvent("vorp_telegram:send")
AddEventHandler("vorp_telegram:send", function(receiver, message)
    local src = source
    local User = VorpCore.getUser(src)
    if not User then return end

    local sender = User.getUsedCharacter.charIdentifier

    MySQL.Async.fetchScalar("SELECT MAX(po_number) FROM telegrams", {}, function(lastPO)
        local newPO = (lastPO or 0) + 1

        MySQL.Async.execute("INSERT INTO telegrams (sender, receiver, message, po_number) VALUES (@s,@r,@m,@po)", {
            ['@s'] = sender,
            ['@r'] = receiver,
            ['@m'] = message,
            ['@po'] = newPO
        }, function()
            TriggerClientEvent("vorp_telegram:notify", src, "📨 Telegram sent | PO #" .. newPO)

            for _, player in ipairs(GetPlayers()) do
                local target = tonumber(player)
                local TUser = VorpCore.getUser(target)
                if TUser and TUser.getUsedCharacter.charIdentifier == receiver then
                    TriggerClientEvent("vorp_telegram:notify", target, "📬 New Telegram Received")
                end
            end
        end)
    end)
end)

RegisterNetEvent("vorp_telegram:getInbox")
AddEventHandler("vorp_telegram:getInbox", function()
    local src = source
    local User = VorpCore.getUser(src)
    if not User then return end

    local identifier = User.getUsedCharacter.charIdentifier

    MySQL.Async.fetchAll("SELECT * FROM telegrams WHERE receiver=@r ORDER BY id DESC", {
        ['@r'] = identifier
    }, function(result)
        TriggerClientEvent("vorp_telegram:openInbox", src, result)
    end)
end)