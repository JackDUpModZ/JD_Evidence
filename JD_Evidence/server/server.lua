ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('JD_Evidence:createInventory')
AddEventHandler('JD_Evidence:createInventory', function(inventoryID)
  print(string.format("creating new inventory for identifier '%s'",inventoryID))
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
end)

ESX.RegisterServerCallback('JD_Evidence:getInventory', function(source, cb, inventoryID)
    local inv = exports["mf-inventory"]:getInventory(inventoryID)
    if not inv then
      cb(true)
    else
      cb(false)
    end
end)