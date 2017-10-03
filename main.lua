local baton = require 'baton'
local gamera = require 'gamera'
local LightWorld = require "light"

local controls = {
  left = {'key:left', 'axis:leftx-', 'button:dpleft'},
  right = {'key:right', 'axis:leftx+', 'button:dpright'},
  up = {'key:up', 'axis:lefty-', 'button:dpup'},
  down = {'key:down', 'axis:lefty+', 'button:dpdown'},
  primary = {'sc:x', 'button:a'},
  secondary = {'sc:z', 'button:x'},
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
  player = {speed = 1500,}
  player.body = love.physics.newBody(world, 650/2, 650/2, "dynamic")
  player.body:setLinearDamping(15)
  player.shape = love.physics.newCircleShape(20)
  player.fixture = love.physics.newFixture(player.body, player.shape, 1)
  player.img = love.graphics.newImage("assets/bluelight.png")
  player.light = lightWorld:newLight(0, 0, 20, 200, 40, 300)
  player.light:setGlowStrength(0.5)

  -- Pointer

  pointer = {x = 0, y = 0, img = nil, light = nil}
  pointer.img = love.graphics.newImage("assets/pointer.png")
  pointer.light = lightWorld:newLight(0, 0, 200, 20, 40, 300)
  pointer.light:setGlowStrength(0.3)

  love.graphics.setBackgroundColor(104, 136, 248)
end

function love.update(dt)
  world:update(dt)
  input:update()

-- Pointer
  pointer.x = love.mouse.getX()
  pointer.y = love.mouse.getY()
  pointer.light:setPosition(pointer.x, pointer.y)

-- Player
  local movementX = (input:get 'right' - input:get 'left')*player.speed
  local movementY = (input:get 'down' - input:get 'up')*player.speed
  player.body:applyForce(movementX, movementY)
  player.light:setPosition(player.body:getPosition())
  camera:setPosition(player.body:getPosition())

  lightWorld:update(dt)
  lightWorld:setTranslation(player.body:getPosition(), 1)
end

function love.draw()
  camera:draw(function(l,t,w,h)
    lightWorld:draw(function()
    end)
  end)
  love.graphics.draw(player.img, player.body:getPosition())
end
