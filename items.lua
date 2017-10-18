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

for i, v in ipairs(Items) do
  local item = v
  setmetatable(item, { __index = itemClass })
  items[i] = item
end

-- Inventory
inventory = {
  width = -window.offsetX,
  height = window.y,
  padding = 10,
  margin = 10
}
function inventory:addItem(item, amount, place)
  if items[item] then
    if self[item] then
      self[item].amount = self[item].amount + amount
    else
      item.amount = amount
      if place then
        table.insert(self, place, item)
      else
        table.insert(self, item)
      end
    end
    return true
  else
    print("Can't add item " + item)
    return false
  end
end

function inventory:removeItem(item, amount)
  if items[item] and self[item] then
    if self[item].amount > amount then
      self[item].amount = self[item].amount - amount
      return true
    elseif self[item].amount == amount then
      table.remove(self, item)
      return true
    else
      print("Can't remove item " + item)
      return false
    end
  end
end

return items
