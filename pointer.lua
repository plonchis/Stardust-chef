pointer = {
  x = 0,
  y = 0,
  range = 100,
  img = love.graphics.newImage("assets/pointer.png"),
  light = lightWorld:newLight(0, 0, 200, 100, 40, 400)
}
pointer.width, pointer.height = pointer.img:getWidth(), pointer.img:getHeight()
pointer.light:setGlowStrength(0.3)
function pointer:update()
  local mouse = {x = love.mouse.getX()+window.offsetX, y = love.mouse.getY()}
  mouse.distance = math.dist(mouse.x, mouse.y, window.x/2, window.y/2)
  self.distance = math.clamp(0, mouse.distance, math.min(window.y, window.x)/2)
  self.angle = math.angle(mouse.x,mouse.y,window.x/2,window.y/2)
  self.x, self.y = math.coords(player.x, player.y, (self.distance/100) * self.range, self.angle)
  self.light:setPosition(self.x, self.y)
  if self.distance<mouse.distance then
    love.mouse.setVisible(true)
  else love.mouse.setVisible(false) end
end
return pointer
