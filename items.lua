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

function itemClass:spawn (x,y)
  self.width, self.height = self.img:getWidth(), self.img:getHeight()
  self.body = love.physics.newBody(world, x, y, "dynamic")
  self.body:setLinearDamping(10)
  self.shape = love.physics.newCircleShape(64)
  self.fixture = love.physics.newFixture(self.body, self.shape, 0.1)
  self.x, self.y = self.body:getPosition()
  self.shadow = lightWorld:newCircle(self.x,self.y,32)

  return self
end

function itemClass:move(x,y)
  self.body:applyForce(x,y)
end

function itemClass:update()
  self.x, self.y = self.body:getPosition()
  self.shadow:setPosition(self.x, self.y)
end

function itemClass:draw()
  love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
end

items = Items
for i, v in pairs(items) do
  setmetatable(v, { __index = itemClass })
end

return items
