local baton = require 'baton'
local flux = require "flux"
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
  camera = gamera.new(0, 0, 2000, 2000)
  -- create light world
	lightWorld = LightWorld({
    ambient = {55,55,55},
  })

  -- Player
  player = {x = 0, y = 0, speed = 1500, slide = 1, img = nil, light = nil}
  player.img = love.graphics.newImage("assets/bluelight.png")
  player.light = lightWorld:newLight(0, 0, 20, 200, 40, 300)
  player.light:setGlowStrength(0.5)

  -- Pointer

  pointer = {x = 0, y = 0, img = nil, light = nil}
  pointer.img = love.graphics.newImage("assets/pointer.png")
  pointer.light = lightWorld:newLight(0, 0, 200, 20, 40, 300)
  pointer.light:setGlowStrength(0.3)
end

function love.update(dt)
  flux.update(dt)
  input:update()

  if love.keyboard.isDown('escape') then
  		love.event.push('quit')
  	end

-- Pointer
  pointer.x = love.mouse.getX()
  pointer.y = love.mouse.getY()
  pointer.light:setPosition(pointer.x, pointer.y)

-- Player
  local movementX = (input:get 'right' - input:get 'left')*player.speed
  local movementY = (input:get 'down' - input:get 'up')*player.speed
  flux.to(player, player.slide, {x = player.x+(movementX*dt), y = player.y+(movementY*dt)})
  --player.x = player.x + (movementX*dt)
  --player.y = player.y + (movementY*dt)
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
  love.graphics.draw(player.img, player.x, player.y)
end
