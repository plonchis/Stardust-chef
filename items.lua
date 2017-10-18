local Items = require "food"

itemClass = {}
--[[function itemClass:combinewith(item)
  combined = self
  combined.quality = (self.quality + item.quality)/2
  for i=1, combined.properties do
    combined.properties[i] = self.properties[i] + item.properties[i]/2
  end
  for i=1, combined.flavor do
    combined.flavor[i] = self.flavor[i] + item.flavor[i]/2
  end
  return combined
end]]--

function itemClass:cook(method)
  if self.methods[method] then
    for i=1, self.properties do
      self.properties[i] = self.properties[i]*self.methods[method][i]*dt
    end
    for i=1, self.flavor do
      self.flavor[i] = self.flavor[i]*self.cooking[i]*self.properties.temp*dt
    end
  else
    print("Can't use method " + method)
  end
end

items = Items
for i, v in pairs(items) do
  setmetatable(v, { __index = itemClass })
end

-- Inventory
inventory = {
  items = {},
  width = -window.offsetX,
  height = window.y,
  padding = 10,
  margin = 10
}
function inventory:addItem(itemName, amount, place)
  if items[itemName] then
    if self.items[itemName] then
      self.items[itemName].amount = self.items[itemName].amount + amount
    else
      item = {
        name = itemName,
        amount = amount
      }
      if place then
        table.insert(self.items, place, item)
      else
        table.insert(self.items, item)
      end
    end
    return true
  else
    print("Can't add item ", itemName)
    return false
  end
end

function inventory:removeItem(itemName, amount)
  if items[itemName] and self[itemName] then
    if self[itemName].amount > amount then
      self[itemName].amount = self[itemName].amount - amount
      return true
    elseif self[itemName].amount == amount then
      table.remove(self, itemName)
      return true
    else
      print("Can't remove item ", itemName)
      return false
    end
  end
end
inventory:addItem("carrot", 2)
inventory:addItem("onion", 4)

return items
