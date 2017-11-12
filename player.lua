player = {
  x = 0,
  y = 0,
  speed = 2000,
  body = love.physics.newBody(world, 0, 0, "dynamic"),
  shape = love.physics.newCircleShape(64),
  img = love.graphics.newImage("assets/ainu.png"),
}
player.body:setLinearDamping(player.speed/150)
player.fixture = love.physics.newFixture(player.body, player.shape, 0.1)
player.fixture:setSensor(true)
player.width, player.height = player.img:getWidth(), player.img:getHeight()
player.shadow = lightWorld:newImage(player.img,0,0,player.width/2,player.width/2)
function player:move(x,y)
  self.body:applyForce(x,y)
  self.x, self.y = self.body:getPosition()
  self.shadow:setPosition(self.x, self.y)
end
return player
