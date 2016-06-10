function love.load()
 img_archer = love.graphics.newImage("assets/archer.png")
end


function love.draw()
   love.graphics.print("Hello World!", 400, 300)
   love.graphics.draw(img_archer, 300, 200)
end

