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

function openInventory()
	local openInventory = {
		{
			id = 1,
			header = 'Open Locker',
			txt = 'Open Locker Room',
			params = {
				event = 'JD_Evidence:triggerLockerMenu',
			}
		},
		{
			id = 2,
			header = 'Open Evidence',
			txt = 'Open Evidence Locker',
			params = {
				event = 'JD_Evidence:triggerEvidenceMenu'
			}
		}
	}
	exports['zf_context']:openMenu(openInventory)
end

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
			evidenceOption(inventoryID)
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
	if args.selection == "delete" then
		local inventoryID = args.inventory
		TriggerServerEvent("JD_Evidence:deleteEvidence", inventoryID)
		ESX.ShowNotification("Deleted Evidence!")
	elseif args.selection == "open" then
		local inventoryID = args.inventory
		exports["mf-inventory"]:openOtherInventory(inventoryID)
	end
end)

----- LOCKER SYSTEM!!!!!!!!!!!!!!!!!!!!
--\\//\\//\\//\\//\\//\\//\\//\\//\\---

function lockerCreate(lockerID)
	local lockerCreate = {
		{
            id = 1,
            header = 'Create New Locker?',
            txt = 'Locker Inventory System'
        },
		{
			id = 2,
			header = 'Confirm Creation?',
			txt = 'confirm',
			params = {
				event = 'JD_Evidence:confirmLocker',
				args = {
					selection = "confirm",
					inventory = lockerID
				}
			}
		},
		{
			id = 3,
			header = 'Cancel Creation?',
			txt = 'cancel',
			params = {
				event = 'JD_Evidence:confirmLocker',
				args = {
					selection = "cancel"
				}
			}
		}
	}

	exports['zf_context']:openMenu(lockerCreate)
	
end

RegisterNetEvent('JD_Evidence:confirmLocker')
AddEventHandler('JD_Evidence:confirmLocker', function(args)
	if args.selection == "confirm" then
		local lockerID = args.inventory
		TriggerServerEvent("JD_Evidence:createLocker", lockerID)
		Wait(1000)
		exports["mf-inventory"]:openOtherInventory(lockerID)
	end
end)

RegisterNetEvent('JD_Evidence:triggerLockerMenu')
AddEventHandler('JD_Evidence:triggerLockerMenu', function()
      local dialog = exports['zf_dialog']:DialogInput({
        header = "LEO Locker", 
        rows = {
            {
                id = 0, 
                txt = "Enter Name"
            },
        }
    })

    if dialog ~= nil then
        if dialog[1].input == nil then
            ESX.ShowNotification('Invalid Entry Made')
        else
			local lockerID = ("LEO_"..dialog[1].input.."")
			TriggerEvent('JD_Evidence:lockerCallbackEvent',lockerID)
        end
    end
end)

RegisterNetEvent('JD_Evidence:lockerCallbackEvent')
AddEventHandler('JD_Evidence:lockerCallbackEvent', function(lockerID)
	ESX.TriggerServerCallback('JD_Evidence:getLocker', function(exists)
		if exists then
			lockerCreate(lockerID)
		else
			lockerOption(lockerID)
		end
	end, lockerID)
end)

function lockerOption(lockerID)
	local lockerOption = {
		{
            id = 1,
            header = 'Locker Options',
            txt = 'Locker Delete/Open'
        },
		{
			id = 2,
			header = 'Delete Locker?',
			txt = 'Delete',
			params = {
				event = 'JD_Evidence:lockerOptions',
				args = {
					selection = "delete",
					inventory = lockerID
				}
			}
		},
		{
			id = 3,
			header = 'Open Locker?',
			txt = 'Open Locker',
			params = {
				event = 'JD_Evidence:lockerOptions',
				args = {
					selection = "open",
					inventory = lockerID
				}
			}
		}
	}

	exports['zf_context']:openMenu(lockerOption)
	
end

RegisterNetEvent('JD_Evidence:lockerOptions')
AddEventHandler('JD_Evidence:lockerOptions', function(args)
	if args.selection == "delete" then
		local lockerID = args.inventory
		TriggerServerEvent("JD_Evidence:deleteLocker", lockerID)
		ESX.ShowNotification("Deleted Locker!")
	elseif args.selection == "open" then
		local lockerID = args.inventory
		exports["mf-inventory"]:openOtherInventory(lockerID)
	end
end)