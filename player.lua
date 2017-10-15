player = {
  x = 0,
  y = 0,
  speed = 2000,
  body = love.physics.newBody(world, 0, 0, "dynamic"),
  shape = love.physics.newCircleShape(20),
  img = love.graphics.newImage("assets/ainu.png"),
}
player.body:setLinearDamping(player.speed/100)
player.fixture = love.physics.newFixture(player.body, player.shape, 1)
player.width, player.height = player.img:getWidth(), player.img:getHeight()
player.shadow = lightWorld:newImage(player.img,0,0,player.width/2,player.width/2)
player.shadow:setNormalMap(player.shadow:generateNormalMap(1))
function player:move(x,y)
  self.body:applyForce(x,y)
  self.x, self.y = self.body:getPosition()
  self.shadow:setPosition(self.x, self.y)
end
return player
