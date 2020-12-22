ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_phone:registerNumber', 'unicorn', 'alerte unicorn', true, true)

TriggerEvent('esx_society:registerSociety', 'unicorn', 'Unicorn', 'society_unicorn', 'society_unicorn', 'society_unicorn', {type = 'public'})

RegisterServerEvent('h4ci_unicorn:annonceopenchacal')
AddEventHandler('h4ci_unicorn:annonceopenchacal', function (target)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
    TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Unicorn', '~b~Annonce Unicorn', '~y~On est ouvert, venez vous détendre !', 'CHAR_MP_STRIPCLUB_PR', 8)

    end
end)

RegisterServerEvent('h4c1_unicorn:annoncerecrutement')
AddEventHandler('h4c1_unicorn:annoncerecrutement', function (target)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
    TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'Unicorn', '~b~Annonce Unicorn', '~y~Recrutement en cours, rendez-vous au Unicorn !', 'CHAR_MP_STRIPCLUB_PR', 8)

    end
end)

RegisterServerEvent('h4ci_unicorn:patronmess')
AddEventHandler('h4ci_unicorn:patronmess', function(PriseOuFin, message)
    local _source = source
    local _raison = PriseOuFin
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    local name = xPlayer.getName(_source)


    for i = 1, #xPlayers, 1 do
        local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
        if thePlayer.job.name == 'unicorn' then
            TriggerClientEvent('h4ci_unicorn:infoservice', xPlayers[i], _raison, name, message)
        end
    end
end)

RegisterServerEvent('h4ci_unicorn:prendreitems')
AddEventHandler('h4ci_unicorn:prendreitems', function(itemName, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local sourceItem = xPlayer.getInventoryItem(itemName)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn', function(inventory)
        local inventoryItem = inventory.getItem(itemName)

        -- is there enough in the society?
        if count > 0 and inventoryItem.count >= count then

            -- can the player carry the said amount of x item?
            if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
                TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
            else
                inventory.removeItem(itemName, count)
                xPlayer.addInventoryItem(itemName, count)
                TriggerClientEvent('esx:showNotification', _source, 'objet retiré', count, inventoryItem.label)
            end
        else
            TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
        end
    end)
end)


RegisterNetEvent('h4ci_unicorn:stockitem')
AddEventHandler('h4ci_unicorn:stockitem', function(itemName, count)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local sourceItem = xPlayer.getInventoryItem(itemName)

    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn', function(inventory)
        local inventoryItem = inventory.getItem(itemName)

        -- does the player have enough of the item?
        if sourceItem.count >= count and count > 0 then
            xPlayer.removeInventoryItem(itemName, count)
            inventory.addItem(itemName, count)
            TriggerClientEvent('esx:showNotification', _source, "objet déposé "..count..""..inventoryItem.label.."")
        else
            TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
        end
    end)
end)


ESX.RegisterServerCallback('h4ci_unicorn:inventairejoueur', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local items   = xPlayer.inventory

    cb({items = items})
end)

ESX.RegisterServerCallback('h4ci_unicorn:prendreitem', function(source, cb)
    TriggerEvent('esx_addoninventory:getSharedInventory', 'society_unicorn', function(inventory)
        cb(inventory.items)
    end)
end)

RegisterNetEvent('h4ci_unicorn:achatbar')
AddEventHandler('h4ci_unicorn:achatbar', function(v, quantite)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getMoney()
    local playerlimite = xPlayer.getInventoryItem(v.item).count

    if playerlimite >= 10 then
        TriggerClientEvent('esx:showNotification', source, "Ton inventaire est plein!")
    
    else
    if playerMoney >= v.prix * quantite then
        xPlayer.addInventoryItem(v.item, quantite)
        xPlayer.removeMoney(v.prix * quantite)

       TriggerClientEvent('esx:showNotification', source, "Tu as acheté ~g~x"..quantite.." ".. v.nom .."~s~ pour ~g~" .. v.prix * quantite.. "$")
    else
        TriggerClientEvent('esx:showNotification', source, "Ta pas assez de sous pour acheter ~g~"..quantite.." "..v.nom)
    end
    
end
    
end)