pointer = {
  x = 0,
  y = 0,
  range = 1,
  img = love.graphics.newImage("assets/pointer.png"),
  light = lightWorld:newLight(0, 0, 200, 100, 40, 400)
}
pointer.width, pointer.height = pointer.img:getWidth(), pointer.img:getHeight()
pointer.light:setGlowStrength(0.3)
pointer.body = love.physics.newBody(world, pointer.x, pointer.y,"kinematic")
pointer.shape = love.physics.newCircleShape(64)
pointer.fixture = love.physics.newFixture(pointer.body, pointer.shape, 0)
pointer.fixture:setSensor(true)
function pointer:update()
  local controller = {x = (input:get 'pointerRight' - input:get 'pointerLeft'), y = (input:get 'pointerDown' - input:get 'pointerUp')}
  local mouse = {x = love.mouse.getX()+window.offsetX, y = love.mouse.getY()}
  mouse.distanceFromCenter = math.dist(mouse.x, mouse.y, window.width/2, window.height/2)
  self.distanceFromCenter = math.clamp(0, mouse.distanceFromCenter, math.min(window.height, window.width)/2)
  self.angleFromCenter = math.angle(mouse.x,mouse.y,window.width/2,window.height/2)
  self.x, self.y = math.coords(player.x, player.y, self.distanceFromCenter * self.range, self.angleFromCenter)
  self.body:setPosition(self.x, self.y)
  self.light:setPosition(self.x, self.y)
  if self.distanceFromCenter<mouse.distanceFromCenter then
    love.mouse.setVisible(true)
  else love.mouse.setVisible(false) end
end
return pointer
