ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	RefreshunicornMoney()
end)





--blips

Citizen.CreateThread(function()

        local unicornmap = AddBlipForCoord(131.38, -1302.73, 29.23)
        SetBlipSprite(unicornmap, 121)
        SetBlipColour(unicornmap, 61)
        SetBlipAsShortRange(unicornmap, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Unicorn")
        EndTextCommandSetBlipName(unicornmap)


end)

--fin blips



--travail unicorn

Citizen.CreateThread(function()
    
    while true do
        Citizen.Wait(0)
        local coords, letSleep = GetEntityCoords(PlayerPedId()), true

        for k,v in pairs(unicorn.pos) do
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then 
            if (unicorn.Type ~= -1 and GetDistanceBetweenCoords(coords, v.position.x, v.position.y, v.position.z, true) < unicorn.DrawDistance) then
                DrawMarker(unicorn.Type, v.position.x, v.position.y, v.position.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, unicorn.Size.x, unicorn.Size.y, unicorn.Size.z, unicorn.Color.r, unicorn.Color.g, unicorn.Color.b, 100, false, true, 2, false, false, false, false)
                letSleep = false
            end
        end
        end

        if letSleep then
            Citizen.Wait(500)
        end
    
end
end)

-- bar unicorn

RMenu.Add('barunicorn', 'main', RageUI.CreateMenu("Bar", "Pour la consommation des clients"))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('barunicorn', 'main'), true, true, true, function()    
         
        for k, v in pairs(unicorn.baritem) do
            RageUI.Button(v.nom.." ~r~$"..v.prix.."/u", nil, {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
                if (Selected) then  
                local quantite = 1    
                local item = v.item
                local prix = v.prix
                local nom = v.nom    
                TriggerServerEvent('h4ci_unicorn:achatbar', v, quantite)
            end
            end)

        end
        end, function()
        end)
            Citizen.Wait(0)
        end
    end)

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
                local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
                local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, unicorn.pos.bar.position.x, unicorn.pos.bar.position.y, unicorn.pos.bar.position.z)
            if jobdist <= 1.0 then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then  
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au bar")
                    if IsControlJustPressed(1,51) then
                        RageUI.Visible(RMenu:Get('barunicorn', 'main'), not RageUI.Visible(RMenu:Get('barunicorn', 'main')))
                    end   
                end
               end 
        end
end)

-------garage

RMenu.Add('garageunicorn', 'main', RageUI.CreateMenu("Garage", "Pour sortir un mini-bus."))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('garageunicorn', 'main'), true, true, true, function() 
            RageUI.Button("Ranger voiture", "Pour ranger une voiture.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
            if dist4 < 4 then
                ESX.ShowAdvancedNotification("Garagiste karim", "La voiture est de retour merci!", "", "CHAR_BIKESITE", 1)
                DeleteEntity(veh)
            end 
            end
            end)         
            RageUI.Button("Mini-bus", "Pour sortir un mini-bus.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then
            ESX.ShowAdvancedNotification("Garagiste karim", "La voiture arrive dans quelques instant..", "", "CHAR_BIKESITE", 1) 
            Citizen.Wait(2000)   
            spawnuniCar("rentalbus")
            ESX.ShowAdvancedNotification("Garagiste karim", "Abime pas la voiture grosse folle !", "", "CHAR_BIKESITE", 1) 
            end
            end)
            

            
        end, function()
        end)
            Citizen.Wait(0)
        end
    end)

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    

    
                local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, unicorn.pos.garage.position.x, unicorn.pos.garage.position.y, unicorn.pos.garage.position.z)
            if dist3 <= 3.0 then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then    
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au garage")
                    if IsControlJustPressed(1,51) then           
                        RageUI.Visible(RMenu:Get('garageunicorn', 'main'), not RageUI.Visible(RMenu:Get('garageunicorn', 'main')))
                    end   
                end
               end 
        end
end)

function spawnuniCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, unicorn.pos.spawnvoiture.position.x, unicorn.pos.spawnvoiture.position.y, unicorn.pos.spawnvoiture.position.z, unicorn.pos.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "UNICORN"..math.random(1,9)
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1) 
end


--coffre

RMenu.Add('coffreunicorn', 'main', RageUI.CreateMenu("Coffre", "Pour déposer/récuperer des choses dans le coffre."))

Citizen.CreateThread(function()
    while true do

        RageUI.IsVisible(RMenu:Get('coffreunicorn', 'main'), true, true, true, function()
            RageUI.Button("Prendre objet", "Pour prendre un objet.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            RageUI.CloseAll()
            OpenGetStocksunicornMenu()
            end
            end)
            RageUI.Button("Déposer objet", "Pour déposer un objet.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            RageUI.CloseAll()
            OpenPutStocksunicornMenu()
            end
            end)
            end, function()
            end)
            Citizen.Wait(0)
        end
    end)

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
                local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
                local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, unicorn.pos.coffre.position.x, unicorn.pos.coffre.position.y, unicorn.pos.coffre.position.z)
            if jobdist <= 1.0 then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then  
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au coffre")
                    if IsControlJustPressed(1,51) then
                        RageUI.Visible(RMenu:Get('coffreunicorn', 'main'), not RageUI.Visible(RMenu:Get('coffreunicorn', 'main')))
                    end   
                end
               end 
        end
end)

function OpenGetStocksunicornMenu()
    ESX.TriggerServerCallback('h4ci_unicorn:prendreitem', function(items)
        local elements = {}

        for i=1, #items, 1 do
            table.insert(elements, {
                label = 'x' .. items[i].count .. ' ' .. items[i].label,
                value = items[i].name
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css      = 'unicorn',
            title    = 'unicorn stockage',
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
                css      = 'unicorn',
                title = 'quantité'
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if not count then
                    ESX.ShowNotification('quantité invalide')
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('h4ci_unicorn:prendreitems', itemName, count)

                    Citizen.Wait(300)
                    OpenGetStocksunicornMenu()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenPutStocksunicornMenu()
    ESX.TriggerServerCallback('h4ci_unicorn:inventairejoueur', function(inventory)
        local elements = {}

        for i=1, #inventory.items, 1 do
            local item = inventory.items[i]

            if item.count > 0 then
                table.insert(elements, {
                    label = item.label .. ' x' .. item.count,
                    type = 'item_standard',
                    value = item.name
                })
            end
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
            css      = 'unicorn',
            title    = 'inventaire',
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
            local itemName = data.current.value

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
                css      = 'unicorn',
                title = 'quantité'
            }, function(data2, menu2)
                local count = tonumber(data2.value)

                if not count then
                    ESX.ShowNotification('quantité invalide')
                else
                    menu2.close()
                    menu.close()
                    TriggerServerEvent('h4ci_unicorn:stockitem', itemName, count)

                    Citizen.Wait(300)
                    OpenPutStocksunicornMenu()
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end
--vestiaire

RMenu.Add('vestiaireunicorn', 'main', RageUI.CreateMenu("Vestiaire", "Pour prendre votre tenue de service ou reprendre votre tenue civil."))

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('vestiaireunicorn', 'main'), true, true, true, function()
            RageUI.Button("Tenue civil", "Pour prendre votre tenue civil.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
            ESX.ShowNotification('Vous avez repris votre ~b~tenue civil')
            end)
            end
            end)
            
            RageUI.Button("Tenue de barman", "Pour prendre votre tenue de barman.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
                clothesSkin = {
                            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                            ['torso_1'] = 40,   ['torso_2'] = 0,
                            ['decals_1'] = 0,   ['decals_2'] = 0,
                            ['arms'] = 40,
                            ['pants_1'] = 28,   ['pants_2'] = 2,
                            ['shoes_1'] = 38,   ['shoes_2'] = 4,
                            ['chain_1'] = 118,  ['chain_2'] = 0
                        }
            else
                clothesSkin = {
                            ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
                            ['torso_1'] = 8,    ['torso_2'] = 2,
                            ['decals_1'] = 0,   ['decals_2'] = 0,
                            ['arms'] = 5,
                            ['pants_1'] = 44,   ['pants_2'] = 4,
                            ['shoes_1'] = 0,    ['shoes_2'] = 0,
                            ['chain_1'] = 0,    ['chain_2'] = 2
                        }
            end
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            ESX.ShowNotification('Vous avez équipé votre ~b~tenue de barman')
            end)

            end
            end)

            RageUI.Button("Tenue de danseur", "Pour prendre votre tenue de danseur.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
                clothesSkin = {
                            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                            ['torso_1'] = 15,   ['torso_2'] = 0,
                            ['decals_1'] = 0,   ['decals_2'] = 0,
                            ['arms'] = 40,
                            ['pants_1'] = 61,   ['pants_2'] = 9,
                            ['shoes_1'] = 16,   ['shoes_2'] = 9,
                            ['chain_1'] = 118,  ['chain_2'] = 0
                        }
            else
                clothesSkin = {
                            ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
                            ['torso_1'] = 22,   ['torso_2'] = 0,
                            ['decals_1'] = 0,   ['decals_2'] = 0,
                            ['arms'] = 4,
                            ['pants_1'] = 22,   ['pants_2'] = 0,
                            ['shoes_1'] = 18,   ['shoes_2'] = 0,
                            ['chain_1'] = 61,   ['chain_2'] = 1
                        }
            end
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            ESX.ShowNotification('Vous avez équipé votre ~b~tenue de danseur')
            end)

            end
            end)
          
            RageUI.Button("Tenue de danseur 2", "Pour prendre votre tenue de danseur.", {RightLabel = "→→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
            if skin.sex == 0 then
                clothesSkin = {
                            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                            ['torso_1'] = 15,   ['torso_2'] = 0,
                            ['decals_1'] = 0,   ['decals_2'] = 0,
                            ['arms'] = 40,
                            ['pants_1'] = 61,   ['pants_2'] = 9,
                            ['shoes_1'] = 16,   ['shoes_2'] = 9,
                            ['chain_1'] = 118,  ['chain_2'] = 0
                        }
            else
                clothesSkin = {
                            ['tshirt_1'] = 3,   ['tshirt_2'] = 0,
                            ['torso_1'] = 111,  ['torso_2'] = 6,
                            ['decals_1'] = 0,   ['decals_2'] = 0,
                            ['arms'] = 15,
                            ['pants_1'] = 63,   ['pants_2'] = 6,
                            ['shoes_1'] = 41,   ['shoes_2'] = 6,
                            ['chain_1'] = 0,    ['chain_2'] = 0
                        }
            end
            TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            ESX.ShowNotification('Vous avez équipé votre ~b~tenue de danseur')
            end)

            end
            end)
        end, function()
        end)
            Citizen.Wait(0)
        end
    end)

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
                local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
                local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, unicorn.pos.vestiaire.position.x, unicorn.pos.vestiaire.position.y, unicorn.pos.vestiaire.position.z)
            if jobdist <= 1.0 then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then  
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au vestiaire")
                    if IsControlJustPressed(1,51) then
                        RageUI.Visible(RMenu:Get('vestiaireunicorn', 'main'), not RageUI.Visible(RMenu:Get('vestiaireunicorn', 'main')))
                    end   
                end
               end 
        end
end)

--menu f6
local societyunicornmoney = nil

RMenu.Add('unicornf6', 'main', RageUI.CreateMenu("Menu Unicorn", "Pour mettre des factures bien fraiche chacal"))
RMenu.Add('unicornf6', 'patron', RageUI.CreateSubMenu(RMenu:Get('unicornf6', 'main'), "Option patron", "Option disponible pour le patron"))

Citizen.CreateThread(function()
    while true do
    	

        RageUI.IsVisible(RMenu:Get('unicornf6', 'main'), true, true, true, function()
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' and ESX.PlayerData.job.grade_name == 'boss' then	
        RageUI.Button("Option patron", "Option disponible pour le patron", {RightLabel = "→→→"},true, function()
        end, RMenu:Get('unicornf6', 'patron'))
        end
        RageUI.Button("Facture", "Pour mettre une facture à la personne proche de toi", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                

                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer == -1 or closestDistance > 3.0 then
                        ESX.ShowNotification('Personne autour')
                    else
                    	local amount = KeyboardInput('Veuillez saisir le montant de la facture', '', 4)
                        TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_unicorn', 'unicorn', amount)
                    end

            end
            end)
        RageUI.Button("Annonce ouvert", "Pour annoncer au gens que le Unicorn est ouvert chacal", {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                TriggerServerEvent('h4ci_unicorn:annonceopenchacal')
            end
            end)
            end, function()
        end)
        RageUI.IsVisible(RMenu:Get('unicornf6', 'patron'), true, true, true, function()
            if societyunicornmoney ~= nil then
            RageUI.Button("Montant disponible dans la société :", nil, {RightLabel = "$" .. societyunicornmoney}, true, function()
            end)
        end
        RageUI.Button("Message aux Unicorn", "Pour écrire un message aux Unicorn", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
                local info = 'patron'
                local message = KeyboardInput('Veuillez mettre le messsage à envoyer', '', 40)
				TriggerServerEvent('h4ci_unicorn:patronmess', info, message)
            end
            end)
        RageUI.Button("Annonce recrutement", "Pour annoncer des recrutements au Unicorn", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then   
				TriggerServerEvent('h4c1_unicorn:annoncerecrutement')
            end
            end)
        end, function()
        end)
            Citizen.Wait(0)
        end
    end)

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
                
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then  
                    
                    if IsControlJustPressed(1,167) then
                        RageUI.Visible(RMenu:Get('unicornf6', 'main'), not RageUI.Visible(RMenu:Get('unicornf6', 'main')))
                        RefreshunicornMoney()
                    end   
                
               end 
        end
end)

RegisterNetEvent('h4ci_unicorn:infoservice')
AddEventHandler('h4ci_unicorn:infoservice', function(service, nom, message)
	if service == 'patron' then
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
		ESX.ShowAdvancedNotification('INFO unicorn', '~b~A lire', 'Patron: ~g~'..nom..'\n~w~Message: ~g~'..message..'', 'CHAR_MP_STRIPCLUB_PR', 8)
		Wait(1000)
		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)	
	end
end)

function RefreshunicornMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateSocietyunicornMoney(money)
        end, ESX.PlayerData.job.name)
    end
end

function UpdateSocietyunicornMoney(money)
    societyunicornmoney = ESX.Math.GroupDigits(money)
end

--bureau boss


Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
                local plycrdboss = GetEntityCoords(GetPlayerPed(-1), false)
                local bossdist = Vdist(plycrdboss.x, plycrdboss.y, plycrdboss.z, unicorn.pos.boss.position.x, unicorn.pos.boss.position.y, unicorn.pos.boss.position.z)
		    if bossdist <= 1.0 then
		    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' and ESX.PlayerData.job.grade_name == 'boss' then	
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder à la gestion d'entreprise")
                    if IsControlJustPressed(1,51) then
                        OpenBossActionsunicornMenu()
                    end   
                end
               end 
        end
end)

function OpenBossActionsunicornMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'unicorn',{
        title    = 'Action patron Unicorn',
        align    = 'top-left',
        elements = {
            {label = 'Gestion employées', value = 'boss_unicornactions'},
    }}, function (data, menu)
        if data.current.value == 'boss_unicornactions' then
            TriggerEvent('esx_society:openBossMenu', 'unicorn', function(data, menu)
                menu.close()
            end)
        end
    end, function (data, menu)
        menu.close()

    end)
end

-------fin bureau boss


--tp bar

Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
                local plyCoords2 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist2 = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, unicorn.pos.tpentrer.position.x, unicorn.pos.tpentrer.position.y, unicorn.pos.tpentrer.position.z)
            if dist2 <= 1.0 then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then   
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour accéder au bar")
                    if IsControlJustPressed(1,51) then
                        DoScreenFadeOut(100)
                        Citizen.Wait(750)
                        ESX.Game.Teleport(PlayerPedId(), {x = unicorn.pos.tpsortie.position.x, y = unicorn.pos.tpsortie.position.y, z = unicorn.pos.tpsortie.position.z})
                        DoScreenFadeIn(100)
                    end   
                end
               end 
        end
end)


Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
                local plyCoords2 = GetEntityCoords(GetPlayerPed(-1), false)
                local dist2 = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, unicorn.pos.tpsortie.position.x, unicorn.pos.tpsortie.position.y, unicorn.pos.tpsortie.position.z)
            if dist2 <= 1.0 then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then   
                    ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour sortir du bar")
                    if IsControlJustPressed(1,51) then
                        DoScreenFadeOut(100)
                        Citizen.Wait(750)
                        ESX.Game.Teleport(PlayerPedId(), {x = unicorn.pos.tpentrer.position.x, y = unicorn.pos.tpentrer.position.y, z = unicorn.pos.tpentrer.position.z})
                        DoScreenFadeIn(100)
                    end   
                end
               end 
        end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)


    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end