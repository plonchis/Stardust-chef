local Baton = require "baton"
local Camera = require "camera"
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

-- Math
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end
function math.coords(x,y, dist,angle) return x - math.cos(angle) * dist, y - math.sin(angle) * dist end

function updateWindow()
  window = {x = love.graphics.getWidth(), y = love.graphics.getHeight()}
  window.offsetX = -window.x*0.2
end

function love.load()
  -- Window
  love.window.setMode(800, 600, {resizable=true, minwidth=400, minheight=300})
  window = {}
  updateWindow()

  -- Physics
  love.physics.setMeter(64) -- 1m = 64px
  world = love.physics.newWorld(0, 0, true)

  -- LightWorld
	lightWorld = LightWorld({
    ambient = {200,200,200},
    refractionStrength = 32.0,
    reflectionVisibility = 0.75,
  })
  -- Hardware cursor
  love.mouse.setCursor(love.mouse.newCursor("assets/cursor.png", 2, 2))

  player = require "player"
  pointer = require "pointer"
  items = require "items"

  -- Camera
  camera = Camera.new(player.x, player.y)
  function camera:set(x,y,scale)
    x = x+window.offsetX
    self:zoomTo(scale)
    self:lockPosition(x, y, Camera.smooth.damped(10))
    lightWorld:setTranslation(-x*scale+window.x/2, -y*scale+window.y/2, scale)
  end
end

-- Update
function love.update(dt)
  love.window.setTitle("Stardust chef (FPS:" .. love.timer.getFPS() .. ")")
  world:update(dt)
  input:update()
  lightWorld:update(dt)
  pointer:update()

  -- Player
  local x, y = (input:get 'right' - input:get 'left')*player.speed, (input:get 'down' - input:get 'up')*player.speed
  player:move(x, y)
  -- Cameraeeeeeee
  camera:set(player.x, player.y, camera.scale+(input:get 'zoomout' - input:get 'zoomin')*dt/10)
end

function love.draw()
  camera:attach()
    lightWorld:draw(function()
      love.graphics.setColor(255, 255, 255)
      love.graphics.rectangle("fill", -1000, -1000, 2000, 2000)
      love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, player.width / 2, player.height / 2)
      love.graphics.draw(pointer.img, pointer.x, pointer.y, 0, 0.5, 0.5, pointer.width / 2, pointer.height / 2)
    end)
  camera:detach()
love.graphics.rectangle("fill", 0, 0, -window.offsetX, window.y)
end

function love.resize(w, h)
  updateWindow()
  lightWorld:refreshScreenSize(window.x, window.y)
end
