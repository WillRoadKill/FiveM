QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

-- Code

local Pings = {}

QBCore.Commands.Add("ping", "", {{name = "actie", help="id | accept | deny"}}, true, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local task = args[1]
    local PhoneItem = Player.Functions.GetItemByName("phone")

    if PhoneItem ~= nil then
        if task == "accept" then
            if Pings[src] ~= nil then
                TriggerClientEvent('qb-pings:client:AcceptPing', src, Pings[src], QBCore.Functions.GetPlayer(Pings[src].sender))
                TriggerClientEvent('QBCore:Notify', Pings[src].sender, Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname.." Accepted your ping!")
                Pings[src] = nil
            else
                TriggerClientEvent('QBCore:Notify', src, "You have no pings open", "error")
            end
        elseif task == "deny" then
            if Pings[src] ~= nil then
                TriggerClientEvent('QBCore:Notify', Pings[src].sender, "Your ping has been rejected", "error")
                TriggerClientEvent('QBCore:Notify', src, "Your denied the ping", "success")
                Pings[src] = nil
            else
                TriggerClientEvent('QBCore:Notify', src, "You have no ping open", "error")
            end
        else
            TriggerClientEvent('qb-pings:client:DoPing', src, tonumber(args[1]))
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "You dont have a telephone", "error")
    end
end)

RegisterServerEvent('qb-pings:server:SendPing')
AddEventHandler('qb-pings:server:SendPing', function(id, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Target = QBCore.Functions.GetPlayer(id)
    local PhoneItem = Player.Functions.GetItemByName("phone")

    if PhoneItem ~= nil then
        if Target ~= nil then
            local OtherItem = Target.Functions.GetItemByName("phone")
            if OtherItem ~= nil then
                TriggerClientEvent('QBCore:Notify', src, "You have sent a ping to"..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname)
                Pings[id] = {
                    coords = coords,
                    sender = src,
                }
                TriggerClientEvent('QBCore:Notify', id, "You have received a ping from"..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname..". /ping 'accept | deny'")
            else
                TriggerClientEvent('QBCore:Notify', src, "Could not send a ping, person may be out of range", "error")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "The person is not in town", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "You do not have a phone", "error")
    end
end)

RegisterServerEvent('qb-pings:server:SendLocation')
AddEventHandler('qb-pings:server:SendLocation', function(PingData, SenderData)
    TriggerClientEvent('qb-pings:client:SendLocation', PingData.sender, PingData, SenderData)
end)