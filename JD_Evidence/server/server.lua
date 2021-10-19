ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('JD_Evidence:createInventory')
AddEventHandler('JD_Evidence:createInventory', function(inventoryID)
  print(string.format("creating new inventory for identifier '%s'",inventoryID))
  local xPlayer = ESX.GetPlayerFromId(source)    -- Defines xPlayer For the next step
  local name = xPlayer.getName()                 -- Uses xPlayer to find Name And Send it in Webhook!
    -- Server side, called once for creation:

  local uniqueIdentifier = inventoryID    -- Unique identifier for this inventory.
  local inventoryType = "inventory"                                 -- Inventory type. Default is "inventory", other types are "shop" and "recipe".
  local inventorySubType = "inventory"                                -- Inventory sub-type, used to modify degrade modifiers by the config table.
  local inventoryLabel = inventoryID                           -- The inventorys UI label index (which will pull the translation value).
  local maxWeight = 5000.0                                           -- Max weight for the inventory.
  local maxSlots = 50                                               -- Max slots for the inventory.
  local items = exports["mf-inventory"]:buildInventoryItems({       -- Construct table of valid items for the inventory from pre-existing ESX items table (OR a blank table/{}).
  })

  exports["mf-inventory"]:createInventory(uniqueIdentifier,inventoryType,inventorySubType,inventoryLabel,maxWeight,maxSlots,items)
  sendCreateDiscord(source, name, "Created Evidence",inventoryID)  -- Sends the Webhook
end)

ESX.RegisterServerCallback('JD_Evidence:getInventory', function(source, cb, inventoryID)
    local inv = exports["mf-inventory"]:getInventory(inventoryID)
    if not inv then
      cb(true)
    else
      cb(false)
    end
end)

RegisterNetEvent('JD_Evidence:deleteEvidence')
AddEventHandler('JD_Evidence:deleteEvidence', function(inventoryID)
  local xPlayer = ESX.GetPlayerFromId(source)
  local name = xPlayer.getName()
  exports["mf-inventory"]:deleteInventory(inventoryID)  -- Deletes the inventoryID from the DataBase!
  sendDeleteDiscord(source, name, "Deleted Evidence",inventoryID)  -- Sends the Webhook
end)

sendDeleteDiscord = function(color, name, message, footer)
  local embed = {
        {
            ["color"] = 3085967,              -- Color for Embed
            ["title"] = "**".. name .."**",   -- The Name of the Person
            ["description"] = message,        -- Action (I.E. Create/Delete)
            ["footer"] = {
                ["text"] = footer,            -- personal info for you! (goes off below info!)
            },
            ["author"] = {
              ["name"] = 'Made by | SickJuggalo666',            -- change this or leave it up to you!
              ['icon_url'] = 'https://i.imgur.com/arJnggZ.png'  -- Change this to your city logo or personal logo!
            }
        }
    }

  PerformHttpRequest(Config.Discord_url, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

sendCreateDiscord = function(color, name, message, footer)
  local embed = {
        {
            ["color"] = 3085967,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = footer,
            },
            ["author"] = {
              ["name"] = 'Made by | SickJuggalo666',
              ['icon_url'] = 'https://i.imgur.com/arJnggZ.png'
            }
        }
    }

  PerformHttpRequest(Config.Discord_url, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

Citizen.CreateThread( function()
	updatePath = "/JackDUpModZ/JD_Evidence" -- your git user/repo path
	resourceName = "JD_Evidence ("..GetCurrentResourceName()..")" -- the resource name
	
	function checkVersion(err,responseText, headers)
		curVersion = LoadResourceFile(GetCurrentResourceName(), "version") -- make sure the "version" file actually exists in your resource root!
	
		if curVersion ~= responseText and tonumber(curVersion) < tonumber(responseText) then
			print("\n#############################################################\n")
			print(""..resourceName.." is outdated!\n\nLatest Available!\n \nVersion : "..responseText.."\nCurrent Resource\n\nVersion : "..curVersion.."\nplease update it from https://github.com"..updatePath.."")
			print("\n#############################################################\n")
		elseif tonumber(curVersion) > tonumber(responseText) then
			print("You somehow skipped a few versions of "..resourceName.." or the git went offline, if it's still online i advise you to update ( or downgrade? )")
		else
			print("\n"..resourceName.." is up to date, have fun!")
		end
	end
	
	PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version", checkVersion, "GET")
end)