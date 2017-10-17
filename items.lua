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
  if not self.methods[method] then
    print("Can't do this")
  else
    for i=1, self.properties do
      self.properties[i] = self.properties[i]*self.methods[method][i]*dt
    end
    for i=1, self.flavor do
      self.flavor[i] = self.flavor[i]*self.cooking[i]*self.properties.temp*dt
    end
  end
end

for i, v in ipairs(Items) do
  local item = v
  setmetatable(item, { __index = itemClass })
  items[i] = item
end
return items
