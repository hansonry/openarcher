


function love.load()

   const = {
      key = {
         left  = "a",
         right = "d",
         shoot = "rctrl"
      },
      archer = { 
         speed        = 100, 
         img_width    = 32, 
         arrow_offset = { x = 0, y = 10 } 
      },
      arrow = { 
         speed     = 200, 
         img_width = 18 
      },
      map = {
         img_width  = 35,
         img_height = 35
      },
      phys = {
         grav = 100
      }
   }
   images = {
      arrow    = love.graphics.newImage("assets/arrow2.png"),
      archer   = love.graphics.newImage("assets/archer.png"),
      platform = love.graphics.newImage("assets/platform.png")
   }



   archer = {
      img = images.archer,
      x = 200,
      y = 200,
      vy = 0,
      facing = "right"
   }
   

   arrow_list = {
      --{ img = arrow_img, x = 300, y = 200, facing = "right" }
   }

   map = {
      data = toMap(10, {
         1, 1, 1, 1 ,1, 1, 1, 1, 1 ,1,
         1, 0, 0, 0, 1, 1, 1, 1, 1 ,1,
         1, 0, 0, 0, 1, 1, 1, 1, 1 ,1,
         1, 0, 0, 1, 1, 1, 1, 1, 1 ,1,
         1, 0, 0, 1 ,1, 1, 1, 1, 1 ,1,
         1, 0, 0, 0 ,0, 0, 0, 0, 0 ,1,
         1, 0, 0, 0 ,0, 0, 0, 0, 0 ,1,
         1, 0, 0, 1 ,1, 0, 0, 0, 0 ,1,
         1, 0, 0, 0 ,0, 0, 0, 0, 0 ,1,
         1, 1, 1, 1 ,1, 1, 1, 1, 1 ,1,
      })
   }

end

function toMap(width, data)
   local out = {}
   local x = 0
   local y = 0
   for i, tile in ipairs(data) do
      if tile == 1 then
         ele = {
            x = x,
            y = y
         }
         table.insert(out, ele)
      end
      x = x + 1
      -- Wrap
      if x >= width then
         x = 0
         y = y + 1
      end
   end
   return out
end



function love.update(dt)
   -- archer
   if love.keyboard.isDown( const.key.left ) then
      archer.x = archer.x - dt * const.archer.speed
      archer.facing = "left"
   end
   if love.keyboard.isDown( const.key.right ) then
      archer.x = archer.x + dt * const.archer.speed
      archer.facing = "right"
   end
   if love.keyboard.isDown( const.key.shoot ) then
      new_arrow = { 
         img = images.arrow, 
         x = archer.x + const.archer.arrow_offset.x,
         y = archer.y + const.archer.arrow_offset.y,
         facing = archer.facing
      }
      table.insert(arrow_list, new_arrow)
   end

   -- archer falling
   if true then
      archer.vy = archer.vy + const.phys.grav * dt
   end

   -- ground detection
   for i, tile in ipairs(map.data) do
      local x = tile.x * const.map.img_width
      local y = tile.y * const.map.img_height
      if
   end

   archer.y = archer.y + archer.vy * dt

   -- arrow
   for i,arrow in ipairs(arrow_list) do
      if arrow.facing == "right" then
         arrow.x = arrow.x + dt * const.arrow.speed
      else
         arrow.x = arrow.x - dt * const.arrow.speed
      end
   end
end

function love.draw()
   --love.graphics.print("Hello World!", 400, 300)
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

   --love.graphics.draw(images.platform, 10, 10);

   
   for i, tile in ipairs(map.data) do
      local x = tile.x * const.map.img_width
      local y = tile.y * const.map.img_height
      love.graphics.draw(images.platform, x, y)
   end

end

