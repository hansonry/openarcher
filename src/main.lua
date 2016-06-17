local game = require('game')


function love.load()
   game.load()
end


function love.keypressed(key)
   game.keypressed(key)
end

function love.keyreleased(key)
   game.keyreleased(key)
end

function love.update(dt)
   game.update(dt)
end

function love.draw()
   game.draw()
end

