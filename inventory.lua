inventory = {
  items = {},
  padding = 10,
  margin = 10
}
inventory.innerMargin = inventory.margin + inventory.padding

function inventory:refresh()
  self.width = -window.offsetX
  self.height = window.y
  inventory.innerSize = inventory.width-inventory.innerMargin*2
end

function inventory:draw()
  love.graphics.setColor(255, 240, 230)
  love.graphics.rectangle("fill", self.margin, self.margin, self.width-self.margin*2, self.height-self.margin*2, 5, 5)
  love.graphics.setColor(200, 180, 170)
  for i, v in pairs(self.items) do
    local posX = self.innerMargin
    local posY = self.innerMargin + (self.innerSize+self.padding)*(i-1)
    local size = self.innerSize

    love.graphics.rectangle("fill", posX, posY, size, size, 5, 5)
    love.graphics.draw(v.img, posX + size/2, posY + size/2, 0, 1, 1, v.img:getWidth()/2, v.img:getHeight()/2)
  end
end

function inventory:addItem(itemName, amount, place)
  if items[itemName] then
    if self.items[itemName] then
      self.items[itemName].amount = self.items[itemName].amount + amount
    else
      item = {
        name = itemName,
        amount = amount,
        img = items[itemName].img
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

return inventory
