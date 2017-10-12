local baton = require 'baton'
local gamera = require 'gamera'
local LightWorld = require "light"

local controls = {
  left = {'sc:a', 'axis:leftx-', 'button:dpleft'},
  right = {'sc:d', 'axis:leftx+', 'button:dpright'},
  up = {'sc:w', 'axis:lefty-', 'button:dpup'},
  down = {'sc:s', 'axis:lefty+', 'button:dpdown'},
  primary = {'sc:e', 'mouse:1', 'button:a'},
  secondary = {'sc:f', 'mouse:1', 'button:x'},
}
input = baton.new(controls, love.joystick.getJoysticks()[1])


function love.load()
  love.physics.setMeter(64) -- 1m = 64px
  world = love.physics.newWorld(0, 0, true)
  camera = gamera.new(0, 0, 2000, 2000)
  -- create light world
	lightWorld = LightWorld({
    ambient = {55,55,55},
  })

  -- Player
  player = {x = 0, y = 0, speed = 2000}
  player.body = love.physics.newBody(world, 650/2, 650/2, "dynamic")
  player.body:setLinearDamping(player.speed/100)
  player.shape = love.physics.newCircleShape(20)
  player.fixture = love.physics.newFixture(player.body, player.shape, 1)
  player.img = love.graphics.newImage("assets/ainu.png")
  player.width = player.img:getWidth()
  player.height = player.img:getHeight()
  player.light = lightWorld:newLight(0, 0, 20, 200, 40, 300)
  player.light:setGlowStrength(0.5)

  -- Pointer

  pointer = {x = 0, y = 0, range = 50}
  pointer.img = love.graphics.newImage("assets/pointer.png")
  pointer.width = pointer.img:getWidth()
  pointer.height = pointer.img:getHeight()
  pointer.light = lightWorld:newLight(0, 0, 200, 20, 40, 300)
  pointer.light:setGlowStrength(0.3)

  love.graphics.setBackgroundColor(50, 70, 150)
end

function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end
function math.coords(x,y, dist,angle) return x - math.cos(angle) * dist, y - math.sin(angle) * dist end

function love.update(dt)
  world:update(dt)
  input:update()

-- Pointer

  local mouse = {x = love.mouse.getX(), y = love.mouse.getY()}
  local window = {x = love.graphics.getWidth(), y = love.graphics.getHeight()}
  local cursorBox = {size = math.min(window.y, window.x)}
  cursorBox.borderY = (window.y-cursorBox.size)/2
  cursorBox.borderX = (window.x-cursorBox.size)/2
  mouse.x = math.clamp(cursorBox.borderX, mouse.x, cursorBox.borderX + cursorBox.size)
  mouse.y = math.clamp(cursorBox.borderY, mouse.y, cursorBox.borderY + cursorBox.size)
  mouse.distance = math.dist(mouse.x, mouse.y, window.x/2, window.y/2)
  mouse.angle = math.angle(mouse.x,mouse.y,window.x/2,window.y/2)
  pointer.x, pointer.y = math.coords(player.x, player.y, (mouse.distance/100) * pointer.range, mouse.angle)
  pointer.light:setPosition(pointer.x, pointer.y)

-- Player
  local movementX = (input:get 'right' - input:get 'left')*player.speed
  local movementY = (input:get 'down' - input:get 'up')*player.speed
  player.x, player.y = player.body:getPosition()
  player.body:applyForce(movementX, movementY)
  player.light:setPosition(player.x, player.y)
  camera:setPosition(player.x, player.y)

  lightWorld:update(dt)
  lightWorld:setTranslation(player.x, player.y, 1)
end

function love.draw()
  camera:draw(function(l,t,w,h)
    lightWorld:draw(function()
    end)
  end)
  love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, player.width / 2, player.height / 2)
  love.graphics.draw(pointer.img, pointer.x, pointer.y, 0, 0.5, 0.5, pointer.width / 2, pointer.height / 2)
end
