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

 -- Removed Event to Open Inventory 

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
			confirmCreate(inventoryID) -- Creates the Evidence
		else
			evidenceOption(inventoryID) -- If Evidence is Created it will Open Another Menu!
		end
	end, inventoryID)
end)

function evidenceOption(inventoryID)
	local evidenceOption = {
		{
            id = 1,
            header = 'Evidence Options',
            txt = 'Evidence Delete/Open'
        },
		{
			id = 2,
			header = 'Delete Inventory?',
			txt = 'delete',
			params = {
				event = 'JD_Evidence:evidenceOptions',
				args = {
					selection = "delete",
					inventory = inventoryID
				}
			}
		},
		{
			id = 3,
			header = 'Open Evidence?',
			txt = 'Open Evidence',
			params = {
				event = 'JD_Evidence:evidenceOptions',
				args = {
					selection = "open",
					inventory = inventoryID
				}
			}
		}
	}

	exports['zf_context']:openMenu(evidenceOption)
	
end

RegisterNetEvent('JD_Evidence:evidenceOptions')
AddEventHandler('JD_Evidence:evidenceOptions', function(args)
	if args.selection == "delete" then   -- Will now Delete inventoryID from the DataBase!
		local inventoryID = args.inventory
		TriggerServerEvent("JD_Evidence:deleteEvidence", inventoryID)
	elseif args.selection == "open" then -- Moved the Open event here for a better lay out!
		local inventoryID = args.inventory
		exports["mf-inventory"]:openOtherInventory(inventoryID)
	end
end)