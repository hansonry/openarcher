local game = require('game')
local menu = require('menu')

function love.load()
   state = "game"
   game.load()
end


function love.keypressed(key)
   if state == "game" then
      game.keypressed(key)
   end
end

function love.keyreleased(key)
   if state == "game" then
      game.keyreleased(key)
   end
end

function love.update(dt)
   if state == "game" then
      game.update(dt)
   end
end

function love.draw()
   if state == "game" then
      game.draw()
   end
end

