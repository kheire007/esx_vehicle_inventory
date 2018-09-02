ESX = nil
ContenuVehicule = 0
MaxCoffreVehicule = nil
TriggerEvent('esx:getSharedObject', function(obj) 
  ESX = obj
end)





RegisterServerEvent('esx_truck_inventory:getInventory')
AddEventHandler('esx_truck_inventory:getInventory', function(plate)


  local inventory_ = {}
  local _source = source
  MySQL.Async.fetchAll(
    'SELECT * FROM `truck_inventory` WHERE `plate` = @plate',
    {
      ['@plate'] = plate
    },
    function(inventory)
	ContenuVehicule = 0
      if inventory ~= nil and #inventory > 0 then
        for i=1, #inventory, 1 do
          table.insert(inventory_, {
            name      = inventory[i].item,
            label      = inventory[i].name,
            count     = inventory[i].count
          })
		 -- print('ContenuVehicule '.. ContenuVehicule)
		 ContenuVehicule = ContenuVehicule + inventory[i].count
		 print('getInventory : ContenuVehicule '.. ContenuVehicule)
		-- TriggerClientEvent('ContenuVehicule', -1, ContenuVehicule)

        end
			
      end

    local xPlayer  = ESX.GetPlayerFromId(_source)
    TriggerClientEvent('esx_truck_inventory:getInventoryLoaded', xPlayer.source, inventory_)
    end)
end)

RegisterServerEvent('esx_truck_inventory:removeInventoryItem')
AddEventHandler('esx_truck_inventory:removeInventoryItem', function(plate, item, count)
  local _source = source
  
  MySQL.Async.fetchAll(
    'UPDATE `truck_inventory` SET `count`= `count` - @qty WHERE `plate` = @plate AND `item`= @item',
    {
      ['@plate'] = plate,
      ['@qty'] = count,
      ['@item'] = item
    },
    function(result)
      local xPlayer  = ESX.GetPlayerFromId(_source)
      if xPlayer ~= nil then
        xPlayer.addInventoryItem(item, count)
		print('removeInventoryItem : ContenuVehicule '.. ContenuVehicule)
		ContenuVehicule = ContenuVehicule - count
		print('removeInventoryItem : ContenuVehicule '.. ContenuVehicule)
		--TriggerClientEvent('ContenuVehicule', -1, ContenuVehicule)
		
      end
    end)
	TriggerClientEvent("esx:showNotification", _source, ('Vous retirez : ' ..count.. ' ~g~'.. name))


end)

RegisterServerEvent('esx_truck_inventory:addInventoryItem')
AddEventHandler('esx_truck_inventory:addInventoryItem', function(type, model, plate, item, count, name)
  local _source = source





 if type == 0 then MaxCoffreVehicule = 50 --compacts
 elseif type == 1 then MaxCoffreVehicule = 65 --sedans
 elseif type == 2 then MaxCoffreVehicule = 70 --SUV's
 elseif type == 3 then MaxCoffreVehicule = 40 --coupes
 elseif type == 4 then MaxCoffreVehicule = 30 --muscle
 elseif type == 5 then MaxCoffreVehicule = 20 --sport classic
 elseif type == 6 then MaxCoffreVehicule = 20 --sport
 elseif type == 7 then MaxCoffreVehicule = 10 --super
 elseif type == 8 then MaxCoffreVehicule = 10 --motorcycle
 elseif type == 9 then MaxCoffreVehicule = 80 --offraod
 elseif type == 10 then MaxCoffreVehicule = 140 --industrial
 elseif type == 11 then MaxCoffreVehicule = 70 --utility
 elseif type == 12 then MaxCoffreVehicule = 100 --vans
 elseif type == 13 then MaxCoffreVehicule = 1 --bicycles
 elseif type == 14 then MaxCoffreVehicule = 50 --boats
 elseif type == 15 then MaxCoffreVehicule = 20 --helicopter
 elseif type == 16 then MaxCoffreVehicule = 20 --plane
 elseif type == 17 then MaxCoffreVehicule = 50 --service
 elseif type == 18 then MaxCoffreVehicule = 50 --emergency
 elseif type == 19 then MaxCoffreVehicule = 50 --military
 else MaxCoffreVehicule = 15
 end
print('MaxCoffreVehicule '.. MaxCoffreVehicule)

--[[
id = 0 --compacts
id = 1 --sedans
id = 2 --SUV's
id = 3, --coupes
id = 4 --muscle
id = 5 --sport classic
id = 6 --sport
id = 7 --super
id = 8 --motorcycle
id = 9 --offroad
id = 10 -industrial
id = 11-utility
id = 12--vans
id = 13 --bicycles
id = 14 --boats
id = 15, --helicopter
id = 16 --plane
id = 17 --service
id = 18 --emergency
id = 19 --military
]]--




  if (ContenuVehicule + count) <= MaxCoffreVehicule then
   print('( '..ContenuVehicule..' ) ContenuVehicule')
   print('( '..count..' ) count')
  MySQL.Async.fetchAll(
    'INSERT INTO truck_inventory (item,count,plate,name) VALUES (@item,@qty,@plate,@name) ON DUPLICATE KEY UPDATE count=count+ @qty',
    {
      ['@plate'] = plate,
      ['@qty'] = count,
      ['@item'] = item,
      ['@name'] = name,
    },
    function(result)
      local xPlayer  = ESX.GetPlayerFromId(_source)
      xPlayer.removeInventoryItem(item, count)
	  ContenuVehicule = ContenuVehicule + count
    end)
	TriggerClientEvent("esx:showNotification", _source, ('Vous déposez : ' ..count.. ' ~g~'.. name))
	print('depot objet')
	else
	TriggerClientEvent("esx:showNotification", _source, ('Pas assez de place... MAX : ').. MaxCoffreVehicule)
	print('manque de place')
	end

	
end)


