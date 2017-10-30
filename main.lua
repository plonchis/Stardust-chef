local Baton = require "baton"
local Camera = require "camera"
local LightWorld = require "light"

-- Controls --
local controls = {
  left = {'sc:a', 'axis:leftx-', 'button:dpleft'},
  right = {'sc:d', 'axis:leftx+', 'button:dpright'},
  up = {'sc:w', 'axis:lefty-', 'button:dpup'},
  down = {'sc:s', 'axis:lefty+', 'button:dpdown'},
  pointerLeft = {'axis:rightx-'},
  pointerRight = {'axis:rightx+'},
  pointerUp = {'axis:righty-'},
  pointerDown = {'axis:righty+'},
  primary = {'sc:f', 'mouse:1', 'button:a'},
  secondary = {'sc:g', 'mouse:1', 'button:x'},
  zoomin = {'sc:q', 'axis:triggerleft+'},
  zoomout = {'sc:e', 'axis:triggerright+'}
}
input = Baton.new(controls, love.joystick.getJoysticks()[1])

-- Math
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end
function math.coords(x,y, dist,angle) return x - math.cos(angle) * dist, y - math.sin(angle) * dist end

function updateWindow()
  window = {width = love.graphics.getWidth(), height = love.graphics.getHeight()}
  window.offsetX = math.clamp(-200, -window.width*0.2, -100)
  local windowScale = math.min(window.height, window.width)/1080

end

function love.load()
  -- Window
  love.window.setMode(800, 600, {resizable=true, minwidth=400, minheight=300})
  window = {}
  updateWindow()
  -- Physics
  love.physics.setMeter(64) -- 1m = 64px
  world = love.physics.newWorld(0, 0, true)
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)

  -- LightWorld
	lightWorld = LightWorld({
    ambient = {220,220,220},
    refractionStrength = 32.0,
    reflectionVisibility = 0.75,
  })
  -- Hardware cursor
  love.mouse.setCursor(love.mouse.newCursor("assets/cursor.png", 2, 2))

  player = require "player"
  pointer = require "pointer"
  items = require "items"
  inventory = require "inventory"
  inventory:refresh()

  -- Camera
  camera = Camera.new(player.x, player.y)
  function camera:set(x,y,scale)
    scale = math.clamp(0.5, scale, 1)
    x = x + window.offsetX/2
    self:lockPosition(x, y, Camera.smooth.damped(10))
    self:zoomTo(scale)
    lightWorld:setTranslation(-self.x*scale+window.width/2, -self.y*scale+window.height/2, scale)
  end
  spawnedItems = {}
  local item = items.carrot:spawn(200,200)
  table.insert(spawnedItems, item)
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
  -- Pointer

  -- Camera
  local scale = camera.scale+(input:get 'zoomout' - input:get 'zoomin')*dt/2
  camera:set(player.x, player.y, scale)

  for i, v in pairs(spawnedItems) do
    v:update()
  end
end

function beginContact(a, b, col)
end


function love.draw()
  camera:attach()
    lightWorld:draw(function()
      love.graphics.setColor(255, 255, 255)
      love.graphics.rectangle("fill", -1000, -1000, 2000, 2000)
      love.graphics.draw(player.img, player.x, player.y, 0, 1, 1, player.width / 2, player.height / 2)
      love.graphics.draw(pointer.img, pointer.x, pointer.y, 0, 1, 1, pointer.width / 2, pointer.height / 2)
      for i, v in pairs(spawnedItems) do
        v:draw()
      end
    end)
  camera:detach()
  inventory:draw()
end

function love.resize(w, h)
  updateWindow()
  lightWorld:refreshScreenSize(window.width, window.height)
  inventory:refresh()
end
