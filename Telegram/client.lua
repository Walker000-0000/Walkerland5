local showNotif = true

RegisterCommand("mail", function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openSend" })
end)

RegisterCommand("inbox", function()
    SetNuiFocus(true, true)
    TriggerServerEvent("vorp_telegram:getInbox")
end)

RegisterNetEvent("vorp_telegram:openInbox")
AddEventHandler("vorp_telegram:openInbox", function(data)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openInbox", telegrams = data })
end)

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "close" })
end)

RegisterNetEvent("vorp_telegram:notify")
AddEventHandler("vorp_telegram:notify", function(text)
    TriggerEvent("vorp:TipBottom", text, 6000)
end)