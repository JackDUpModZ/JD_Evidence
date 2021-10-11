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

RegisterNetEvent('JD_Evidence:inventoryOpen')
AddEventHandler('JD_Evidence:inventoryOpen', function(inventoryID)
	exports["mf-inventory"]:openOtherInventory(inventoryID)
end)

function confirmCreate(inventoryID)
	local confirmCreate = {
		{
            id = 1,
            header = 'Create New Evidence Inventory?',
            txt = 'Evidence Inventory System'
        },
		{
			id = 2,
			header = 'Confirm Creation?',
			txt = 'confirm',
			params = {
				event = 'JD_Evidence:confirmorcancel',
				args = {
					selection = "confirm",
					inventory = inventoryID
				}
			}
		},
		{
			id = 3,
			header = 'Cancel Creation?',
			txt = 'cancel',
			params = {
				event = 'JD_Evidence:confirmorcancel',
				args = {
					selection = "cancel"
				}
			}
		}
	}

	exports['zf_context']:openMenu(confirmCreate)
	
end

RegisterNetEvent('JD_Evidence:confirmorcancel')
AddEventHandler('JD_Evidence:confirmorcancel', function(args)
	if args.selection == "confirm" then
		local inventoryID = args.inventory
		TriggerServerEvent("JD_Evidence:createInventory", inventoryID)
		Wait(1000)
		exports["mf-inventory"]:openOtherInventory(inventoryID)
	end
end)

RegisterNetEvent('JD_Evidence:triggerEvidenceMenu')
AddEventHandler('JD_Evidence:triggerEvidenceMenu', function()
      local dialog = exports['zf_dialog']:DialogInput({
        header = "LSCSO Evidence", 
        rows = {
            {
                id = 0, 
                txt = "Evidence Case ID (#)"
            },
        }
    })

    if dialog ~= nil then
        if dialog[1].input == nil then
            ESX.ShowNotification('Invalid Entry Made')
        else
			local inventoryID = ("evidence_"..dialog[1].input.."")
			TriggerEvent('JD_Evidence:callbackEvent',inventoryID)
        end
    end
end)

RegisterNetEvent('JD_Evidence:callbackEvent')
AddEventHandler('JD_Evidence:callbackEvent', function(inventoryID)
	ESX.TriggerServerCallback('JD_Evidence:getInventory', function(exists)
		if exists then
			confirmCreate(inventoryID)
		else
			exports["mf-inventory"]:openOtherInventory(inventoryID)
		end
	end, inventoryID)
end)
