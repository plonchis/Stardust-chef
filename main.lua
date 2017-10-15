local Baton = require 'baton'
local Camera = require 'camera'
local LightWorld = require "light"

-- Controls --
local controls = {
  left = {'sc:a', 'axis:leftx-', 'button:dpleft'},
  right = {'sc:d', 'axis:leftx+', 'button:dpright'},
  up = {'sc:w', 'axis:lefty-', 'button:dpup'},
  down = {'sc:s', 'axis:lefty+', 'button:dpdown'},
  primary = {'sc:f', 'mouse:1', 'button:a'},
  secondary = {'sc:g', 'mouse:1', 'button:x'},
  zoomin = {'sc:q', 'axis:triggerleft'},
  zoomout = {'sc:e', 'axis:triggereight'}
}
input = Baton.new(controls, love.joystick.getJoysticks()[1])

-- Math functions --
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end
function math.coords(x,y, dist,angle) return x - math.cos(angle) * dist, y - math.sin(angle) * dist end

-- Load --
function love.load()
  love.window.setMode(800, 600, {resizable=true, minwidth=400, minheight=300})
  love.physics.setMeter(64) -- 1m = 64px
  world = love.physics.newWorld(0, 0, true)
	lightWorld = LightWorld({
    ambient = {150,150,150},
    refractionStrength = 32.0,
    reflectionVisibility = 0.75,
  })
  cursor = love.mouse.newCursor("assets/cursor.png", 2, 2)
  love.mouse.setCursor(cursor)
  -- Player
  player = {x = 0, y = 0, speed = 2000}
  player.body = love.physics.newBody(world, 0, 0, "dynamic")
  player.body:setLinearDamping(player.speed/100)
  player.shape = love.physics.newCircleShape(20)
  player.fixture = love.physics.newFixture(player.body, player.shape, 1)
  player.img = love.graphics.newImage("assets/ainu.png")
  player.width, player.height = player.img:getWidth(), player.img:getHeight()

  -- Pointer

  pointer = {x = 0, y = 0, range = 50}
  pointer.img = love.graphics.newImage("assets/pointer.png")
  pointer.width, pointer.height = pointer.img:getWidth(), pointer.img:getHeight()

  -- Create lights
  pointer.light = lightWorld:newLight(0, 0, 200, 100, 40, 300)
  pointer.light:setGlowStrength(0.5)

  -- Create shadow bodys
  player.shadow = lightWorld:newImage(player.img,0,0)
  player.shadow:setNormalMap(player.shadow:generateNormalMap(1))

  -- Camera
  cam = Camera.new()
end

function love.update(dt)
  love.window.setTitle("Stardust chef (FPS:" .. love.timer.getFPS() .. ")")
  world:update(dt)
  input:update()
  window = {x = love.graphics.getWidth(), y = love.graphics.getHeight()}

  -- Player
  local movementX = (input:get 'right' - input:get 'left')*player.speed
  local movementY = (input:get 'down' - input:get 'up')*player.speed
  player.body:applyForce(movementX, movementY)
  player.x, player.y = player.body:getPosition()
  player.shadow:setPosition(player.x, player.y)
  -- Camera
  cam:zoomTo(cam.scale+(input:get 'zoomout' - input:get 'zoomin')*dt/10)
  --cam:lookAt(player.x, player.y)
  cam:lockPosition(player.x, player.y, Camera.smooth.damped(10))

-- Pointer

  local mouse = {x = love.mouse.getX(), y = love.mouse.getY()}
  mouse.distance = math.dist(mouse.x, mouse.y, window.x/2, window.y/2)
  pointer.distance = math.clamp(0, mouse.distance, math.min(window.y, window.x)/2)
  pointer.angle = math.angle(mouse.x,mouse.y,window.x/2,window.y/2)
  pointer.x, pointer.y = math.coords(player.x, player.y, (pointer.distance/100) * pointer.range, pointer.angle)
  pointer.light:setPosition(pointer.x, pointer.y)
  if pointer.distance<mouse.distance then
    love.mouse.setVisible(true)
  else love.mouse.setVisible(false) end

  lightWorld:update(dt)
  lightWorld:setTranslation(-cam.x*cam.scale+window.x/2, -cam.y*cam.scale+window.y/2, cam.scale)
end

function love.draw()
  cam:attach()
    lightWorld:draw(function()
      love.graphics.setColor(255, 255, 255)
      love.graphics.rectangle("fill", 0, 0, 2000, 2000)
      love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, player.width / 2, player.height / 2)
      love.graphics.draw(pointer.img, pointer.x, pointer.y, 0, 0.5, 0.5, pointer.width / 2, pointer.height / 2)
    end)
  cam:detach()
end
