local game = require('game')
local menu = require('menu')

function love.load()
   state = "menu"
   game.load()
   menu.load()
end


function love.keypressed(key)
   if state == "game" then
      game.keypressed(key)
   elseif state == "menu" then
      menu.keypressed(key)
   end
end

function love.keyreleased(key)
   if state == "game" then
      game.keyreleased(key)
   elseif state == "menu" then
      menu.keyreleased(key)
   end
end

function love.update(dt)
   if state == "game" then
      game.update(dt)
   elseif state == "menu" then
      state = menu.update(dt)
   end
end

function love.draw()
   if state == "game" then
      game.draw()
   elseif state == "menu" then
      menu.draw()
   end
end

