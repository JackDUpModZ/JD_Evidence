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
				event = 'JD_Evidence:lockerCallbackEvent',
			}
		},
		{
			id = 2,
			header = 'Open Evidence',
			txt = 'Open Evidence Locker',
			params = {
				event = 'JD_Evidence:triggerEvidenceMenu'
			}
		},
		{
			id = 3,
			header = 'Chief Options',
			txt = 'Chief ONLY!',
			params = {
				event = 'JD_Evidence:ChiefMenu'
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
        header = "LSPD Evidence", 
        rows = {
            {
                id = 0, 
                txt = "Incident Number (#...)"
            },
        }
    })

    if dialog ~= nil then
        if dialog[1].input == nil then
            ESX.ShowNotification('Invalid Entry Made')
        else
			local inventoryID = ("case"..dialog[1].input.."")
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

RegisterNetEvent('JD_Evidence:lockerCallbackEvent')
AddEventHandler('JD_Evidence:lockerCallbackEvent', function(lockerID)
    ESX.TriggerServerCallback('JD_Evidence:getPlayerName', function(data)
        if data ~= nil then
			local lockerID = ("LEO:"..data.firstname.." "..data.lastname)
			ESX.TriggerServerCallback('JD_Evidence:getLocker', function(lockerID)
				if lockerID then
					local lockerID = ("LEO:"..data.firstname.." "..data.lastname)
					lockerCreate(lockerID)
				else
					local lockerID = ("LEO:"..data.firstname.." "..data.lastname)
					lockerOption(lockerID)
				end
			end,lockerID)
		else
            ESX.ShowNotification("Info can\'t be found!")
        end
    end,data)
end)


--## CHIEF MENU!!!!!

function refreshjob()
    Citizen.Wait(1)
    PlayerData = ESX.GetPlayerData()
end

RegisterNetEvent('JD_Evidence:ChiefMenu')
AddEventHandler('JD_Evidence:ChiefMenu',function()
	refreshjob()
	if  PlayerData.job.grade_name == Config.Rank then
		ChooseOption()
	else
		ESX.ShowNotification("You Do Not Have the Reguired Job!")
	end
end)

function ChooseOption()
	local chooseOption = {
		{
            id = 0,
            header = 'Choose Option',
            txt = 'Locker Delete/Open'
        },
		{
			id = 1,
			header = 'Open Locker',
			txt = 'Open Personal Locker',
			params = {
				event = 'JD_Evidence:ChiefLookup',
			}
		},
		{
			id = 2,
			header = 'Open Case?',
			txt = 'Open Case Locker',
			params = {
				event = 'JD_Evidence:ChiefCaseMenu',
			}
		}
	}

	exports['zf_context']:openMenu(chooseOption)

end

RegisterNetEvent('JD_Evidence:ChiefLookup')
AddEventHandler('JD_Evidence:ChiefLookup', function()
      local dialog = exports['zf_dialog']:DialogInput({
        header = "LEO Locker Check",
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
			local lockerID = ("LEO:"..dialog[1].input.."")
			TriggerEvent('JD_Evidence:ChiefLockerCheck',lockerID)
		end	
    end
end)

RegisterNetEvent('JD_Evidence:ChiefCaseMenu')
AddEventHandler('JD_Evidence:ChiefCaseMenu', function()
	local dialog = exports['zf_dialog']:DialogInput({
	  header = "LSPD Cases",
	  rows = {
		  	{
			  id = 0,
			  txt = "Enter Case#"
		  	},
	  	}
  	})

  	if dialog ~= nil then
	  	if dialog[1].input == nil then
		  	ESX.ShowNotification('Invalid Entry Made')
	  	else
		  	local inventoryID = ("case"..dialog[1].input.."")
		 	 TriggerEvent('JD_Evidence:ChiefInventory',inventoryID)	
	  	end	
  	end
end)

RegisterNetEvent('JD_Evidence:ChiefLockerCheck')
AddEventHandler('JD_Evidence:ChiefLockerCheck',function(lockerID)
	ESX.TriggerServerCallback('JD_Evidence:getLocker', function(exists)
		if not exists then
			lockerOption(lockerID)
		else
			ESX.ShowNotification(string.format('No Lockers with name:'..lockerID))	
		end
	end, lockerID)
end)

RegisterNetEvent('JD_Evidence:ChiefInventory')
AddEventHandler('JD_Evidence:ChiefInventory',function(inventoryID)
	ESX.TriggerServerCallback('JD_Evidence:getInventory', function(exists)
		if not exists then
			evidenceOption(inventoryID)
		else
			ESX.ShowNotification(string.format('No Lockers with name: '..inventoryID))
		end
	end, inventoryID)
end)