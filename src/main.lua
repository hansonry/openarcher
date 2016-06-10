


function love.load()

   const = 
   {
      archer = { speed = 100, img_width = 32, arrow_offset = { x = 0, y = 10 } },
      arrow  = { speed = 200, img_width = 18 }
   }

   arrow_img = love.graphics.newImage("assets/arrow2.png")

   archer = {}
   archer.img = love.graphics.newImage("assets/archer.png")
   archer.x = 300
   archer.y = 200
   archer.facing = "right"
   

   arrow_list = {
      --{ img = arrow_img, x = 300, y = 200, facing = "right" }
   }

end


function love.update(dt)
   if love.keyboard.isDown( "a" ) then
      archer.x = archer.x - dt * const.archer.speed
      archer.facing = "left"
   end
   if love.keyboard.isDown( "d" ) then
      archer.x = archer.x + dt * const.archer.speed
      archer.facing = "right"
   end
   if love.keyboard.isDown( "rctrl" ) then
      new_arrow = { 
         img = arrow_img, 
         x = archer.x + const.archer.arrow_offset.x,
         y = archer.y + const.archer.arrow_offset.y,
         facing = archer.facing
      }
      table.insert(arrow_list, new_arrow)
   end

   for i,arrow in ipairs(arrow_list) do
      if arrow.facing == "right" then
         arrow.x = arrow.x + dt * const.arrow.speed
      else
         arrow.x = arrow.x - dt * const.arrow.speed
      end
   end
end

function love.draw()
   love.graphics.print("Hello World!", 400, 300)
   if archer.facing == "right" then
      love.graphics.draw(archer.img, archer.x, archer.y)
   else
      -- Flip the archer. This also changes it's x pos
      love.graphics.draw(archer.img, archer.x + const.archer.img_width, archer.y, 0, -1, 1)
   end

   -- Arrows
   for i,arrow in ipairs(arrow_list) do
     if arrow.facing == "right" then
         love.graphics.draw(arrow.img, arrow.x, arrow.y)
      else
         -- Flip the archer. This also changes it's x pos
         love.graphics.draw(arrow.img, arrow.x + const.arrow.img_width, arrow.y, 0, -1, 1)
      end
   end

end

