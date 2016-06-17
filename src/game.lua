
local function toMap(width, data)
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

local function newRound()
   arrow_list = {}

   archer_list[1].hits = 0
   archer_list[1].arrows = 3
   archer_list[1].x = map.start1.x
   archer_list[1].y = map.start1.y
   archer_list[1].isAlive = true

   archer_list[2].hits = 0
   archer_list[2].arrows = 3
   archer_list[2].x = map.start2.x
   archer_list[2].y = map.start2.y
   archer_list[2].isAlive = true
end

local function collisionAABB(a, b)
   return a.x1 < b.x2 and a.x2 > b.x1 and
          a.y1 < b.y2 and a.y2 > b.y1
           
end

local function intersection(a, b)
   local intbox = {}
   if a.x1 > b.x1 then intbox.x1 = a.x1 else intbox.x1 = b.x1 end
   if a.y1 > b.y1 then intbox.y1 = a.y1 else intbox.y1 = b.y1 end
   if a.x2 > b.x2 then intbox.x2 = b.x2 else intbox.x2 = a.x2 end
   if a.y2 > b.y2 then intbox.y2 = b.y2 else intbox.y2 = a.y2 end

   return intbox
end

local function center(a)
   return { x = (a.x1 + a.x2) / 2, y = (a.y1 + a.y2) / 2}
end

local function load()

   const = {
      key = {
         player1 = {
            left  = "a",
            right = "d",
            jump  = "w",
            shoot = "v"
         },
         player2 = {
            left  = "j",
            right = "l",
            jump  = "i",
            shoot = "/"
         },
      },
      archer = { 
         speed        = 100, 
         img_width    = 32, 
         arrow_offset = { x = 0, y = 10 },
         hitbox = {
            x1 = 6,
            y1 = 4,
            x2 = 6 + 18,
            y2 = 4 + 62,
         },
         jumpvel = -125
      },
      arrow = { 
         speed     = 200, 
         img_width = 18,
         hitbox = {
            x1 = 0,
            y1 = 0,
            x2 = 18,
            y2 = 3
         },
         stuck = {
            timeout = 5, -- Seconds
            wallPen = 5
         }
         
      },
      map = {
         img_width  = 35,
         img_height = 35
      },
      phys = {
         grav = 100
      }
   } -- Const
   images = {
      arrow    = love.graphics.newImage("assets/arrow2.png"),
      archer   = love.graphics.newImage("assets/archer.png"),
      archer2  = love.graphics.newImage("assets/archer2.png"),
      platform = love.graphics.newImage("assets/platform.png")
   } -- images


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
      }),
      start1 = {
         x = 40,
         y = 40
      },
      start2 = {
         x = 200,
         y = 200
      }
   } -- Map

   archer_list = {
      {
         img = images.archer,
         x = 0,
         y = 0,
         vy = 0,
         facing = "right",
         onGround = false,
         bow = {
            chargingTime = 0,
            isPulling = false 
         },
         key = {
            left  = const.key.player1.left,
            right = const.key.player1.right,
            jump  = const.key.player1.jump,
            shoot = const.key.player1.shoot
         },
         hits = 0,
         arrows = 3,
         wins = 0
      },
      {
         img = images.archer2,
         x = 0,
         y = 0,
         vy = 0,
         facing = "right",
         onGround = false,
         bow = {
            chargingTime = 0,
            isPulling = false 
         },
         key = {
            left  = const.key.player2.left,
            right = const.key.player2.right,
            jump  = const.key.player2.jump,
            shoot = const.key.player2.shoot
         },
         hits = 0,
         arrows = 3,
         wins = 0,
         isAlive = true
      }
   } -- Archer List
   
   newRound()
   
end



local function keypressed(key)
   for i,archer in ipairs(archer_list) do
      if key == archer.key.shoot then
         archer.bow.isPulling = true
         archer.bow.chargingTime = 0
      end
   end

end

local function keyreleased(key)
   for i,archer in ipairs(archer_list) do
      if key == archer.key.shoot  and archer.arrows > 0 then
         archer.bow.isPulling = false      
         if archer.bow.chargingTime > 1 then archer.bow.chargingTime = 1 end
         local speed
         if archer.facing == "right" then
            speed = const.arrow.speed * (1 + archer.bow.chargingTime)
         else
            speed = -const.arrow.speed * (1 + archer.bow.chargingTime)
         end
         new_arrow = { 
            img = images.arrow, 
            x = archer.x + const.archer.arrow_offset.x,
            y = archer.y + const.archer.arrow_offset.y,
            vy = archer.vy,
            vx = speed,
            state = "flying",
            facing = archer.facing,
            stuckTime = 0,
            previousVictim = archer,
            archerOffset = {
               x = 0,
               y = 0
            }
         } -- New Arrow
         table.insert(arrow_list, new_arrow)
         archer.arrows = archer.arrows - 1
      end
   end
end

local function update(dt)
   -- archer
   local aliveCount = 0
   local archerAlive = nil
   for i,archer in ipairs(archer_list) do
      if archer.isAlive then
         aliveCount = aliveCount + 1
         archerAlive = archer
      end
      if love.keyboard.isDown( archer.key.left ) then
         archer.x = archer.x - dt * const.archer.speed
         archer.facing = "left"
      end
      if love.keyboard.isDown( archer.key.right ) then
         archer.x = archer.x + dt * const.archer.speed
         archer.facing = "right"
      end
      if love.keyboard.isDown( archer.key.jump ) and archer.onGround then
         archer.vy = const.archer.jumpvel
      end


      local archer_hitbox = {
         x1 = archer.x + const.archer.hitbox.x1,
         y1 = archer.y + const.archer.hitbox.y1,
         x2 = archer.x + const.archer.hitbox.x2,
         y2 = archer.y + const.archer.hitbox.y2
      }
      local archer_center = center(archer_hitbox)
      archer.onGround = false
      -- ground detection
      for i, tile in ipairs(map.data) do
         local x = tile.x * const.map.img_width
         local y = tile.y * const.map.img_height
         local tile_hitbox = {
            x1 = x, y1 = y,
            x2 = x + const.map.img_width,
            y2 = y + const.map.img_height
         }
         if collisionAABB(tile_hitbox, archer_hitbox) then
            local intbox = intersection(tile_hitbox, archer_hitbox)
            local intbox_center = center(intbox)
            if archer_hitbox.x2 - intbox.x1 < 10 then
               archer.x = tile_hitbox.x1 - const.archer.hitbox.x2
            elseif intbox.x2 - archer_hitbox.x1 < 10 then
               archer.x = tile_hitbox.x2 - const.archer.hitbox.x1
            end

         end
        
      end


      -- archer falling
      archer.vy = archer.vy + const.phys.grav * dt


      archer.y = archer.y + archer.vy * dt

      local archer_hitbox = {
         x1 = archer.x + const.archer.hitbox.x1,
         y1 = archer.y + const.archer.hitbox.y1,
         x2 = archer.x + const.archer.hitbox.x2,
         y2 = archer.y + const.archer.hitbox.y2
      }
      local archer_center = center(archer_hitbox)
      archer.onGround = false
      -- ground detection
      for i, tile in ipairs(map.data) do
         local x = tile.x * const.map.img_width
         local y = tile.y * const.map.img_height
         local tile_hitbox = {
            x1 = x, y1 = y,
            x2 = x + const.map.img_width,
            y2 = y + const.map.img_height
         }
         if collisionAABB(tile_hitbox, archer_hitbox) then
            local intbox = intersection(tile_hitbox, archer_hitbox)
            --local intbox_center = center(intbox)
            if archer_hitbox.y2 - intbox.y1 < 10 then
               archer.vy = 0
               archer.y = tile_hitbox.y1 - const.archer.hitbox.y2
               archer.onGround = true
            elseif intbox.y2 - archer_hitbox.y1 < 10 then
               archer.vy = 0
               archer.y = tile_hitbox.y2 - const.archer.hitbox.y1
            end

         end
        
      end
      -- Bow
      if archer.bow.isPulling then
         archer.bow.chargingTime = archer.bow.chargingTime + dt
      end
      -- Arrow Hit detection
      for i = #arrow_list, 1, -1 do
         local arrow = arrow_list[i]
         if arrow.state == "flying" or 
            arrow.state == "stuck" then
            arrow_hitbox = {
               x1 = arrow.x + const.arrow.hitbox.x1,
               y1 = arrow.y + const.arrow.hitbox.y1,
               x2 = arrow.x + const.arrow.hitbox.x2,
               y2 = arrow.y + const.arrow.hitbox.y2
            }
         else
            arrow_hitbox = {
               x1 = arrow.x + const.arrow.hitbox.x1,
               y1 = arrow.y + const.arrow.hitbox.y1,
               x2 = arrow.x + const.arrow.hitbox.y2,
               y2 = arrow.y + const.arrow.hitbox.x2 
            } -- Flipped becuase the arrow is pointing down
         end
         if arrow.state == "stuck" or 
            arrow.state == "fallen" then
            if collisionAABB(arrow_hitbox, archer_hitbox) then
               table.remove(arrow_list, i)
               archer.arrows = archer.arrows + 1
            end
         elseif arrow.state == "flying" or 
            arrow.state == "falling" then
            if collisionAABB(arrow_hitbox, archer_hitbox) and
               arrow.previousVictim ~= archer then
               -- hit
               arrow.previousVictim = archer
               archer.hits = archer.hits + 1
               arrow.state = "archer"
               arrow.archerOffset.x = arrow.x - archer.x
               arrow.archerOffset.y = arrow.y - archer.y
               arrow.stuckTime = 0
               if archer.hits >= 3 then
                  archer.isAlive = false
               end

            end
         end

      end

   end

   -- End Game
   if aliveCount <= 1 then
      if archerAlive ~= nil then
         archerAlive.wins = archerAlive.wins + 1
      end
      newRound()
   end

   -- arrow
   for i,arrow in ipairs(arrow_list) do 
      local arrow_hitbox
      if arrow.state == "flying" or 
         arrow.state == "stuck" then
         arrow_hitbox = {
            x1 = arrow.x + const.arrow.hitbox.x1,
            y1 = arrow.y + const.arrow.hitbox.y1,
            x2 = arrow.x + const.arrow.hitbox.x2,
            y2 = arrow.y + const.arrow.hitbox.y2
         }
      else
         arrow_hitbox = {
            x1 = arrow.x + const.arrow.hitbox.x1,
            y1 = arrow.y + const.arrow.hitbox.y1,
            x2 = arrow.x + const.arrow.hitbox.y2,
            y2 = arrow.y + const.arrow.hitbox.x2 
         } -- Flipped becuase the arrow is pointing down
      end

      if arrow.state == "flying" or
         arrow.state == "falling" then
         arrow.vy = arrow.vy + const.phys.grav * dt
         arrow.y = arrow.y + arrow.vy * dt
         arrow.x = arrow.x + arrow.vx * dt
      elseif arrow.state == "archer" then
         arrow.x = arrow.previousVictim.x + arrow.archerOffset.x
         arrow.y = arrow.previousVictim.y + arrow.archerOffset.y
      end
      if arrow.state == "stuck" or 
         arrow.state == "archer" then
         arrow.stuckTime = arrow.stuckTime + dt
      end


      if arrow.state == "flying" then

         for i, tile in ipairs(map.data) do
            local x = tile.x * const.map.img_width
            local y = tile.y * const.map.img_height
            local tile_hitbox = {
               x1 = x, y1 = y,
               x2 = x + const.map.img_width,
               y2 = y + const.map.img_height
            }
            if collisionAABB(tile_hitbox, arrow_hitbox) then
               arrow.state = "stuck"
               arrow.previousVictim = nil
               arrow.stuckTime = 0 
               if arrow.vx > 0 then
                  arrow.x = tile_hitbox.x1 - const.arrow.img_width + const.arrow.stuck.wallPen
               else
                  arrow.x = tile_hitbox.x2 - const.arrow.stuck.wallPen
               end
               break;
            end
     
         end
      elseif arrow.state == "stuck" then
         if arrow.stuckTime >= const.arrow.stuck.timeout then

            if arrow.vx < 0 then
               -- Shift the arrow over
               arrow.x = arrow.x + const.arrow.img_width
            end
            arrow.state = "falling"
            arrow.vx = 0
            arrow.vy = 0
            arrow.facing = "down"
            
         end 
      elseif arrow.state == "falling" then         
         for i, tile in ipairs(map.data) do
            local x = tile.x * const.map.img_width
            local y = tile.y * const.map.img_height
            local tile_hitbox = {
               x1 = x, y1 = y,
               x2 = x + const.map.img_width,
               y2 = y + const.map.img_height
            }
            if collisionAABB(tile_hitbox, arrow_hitbox) then
               arrow.state = "fallen"
               break;
            end
         end
      elseif arrow.state == "archer" then
         if arrow.stuckTime >= const.arrow.stuck.timeout then
            arrow.state = "falling"
            arrow.vx = 0
            arrow.vy = arrow.previousVictim.vy
            arrow.facing = "down"
         end

      end

   end


end

local function draw()
   --love.graphics.print("Hello World!", 400, 300)

   -- Draw Archer
   for i,archer in ipairs(archer_list) do
      if archer.facing == "right" then
         love.graphics.draw(archer.img, archer.x, archer.y)
      else
         -- Flip the archer. This also changes it's x pos
         love.graphics.draw(archer.img, archer.x + const.archer.img_width, archer.y, 0, -1, 1)
      end
      love.graphics.print(archer.hits,   i * 20, 400)
      love.graphics.print(archer.arrows, i * 20, 415)
      love.graphics.print(archer.wins,   i * 20, 430)
   end

   -- Draw Archer Hitbox
   --[[
   love.graphics.line(
      archer.x + const.archer.hitbox.x1, archer.y + const.archer.hitbox.y1,
      archer.x + const.archer.hitbox.x2, archer.y + const.archer.hitbox.y1,
      archer.x + const.archer.hitbox.x2, archer.y + const.archer.hitbox.y2,
      archer.x + const.archer.hitbox.x1, archer.y + const.archer.hitbox.y2,
      archer.x + const.archer.hitbox.x1, archer.y + const.archer.hitbox.y1)
   --]]

   -- Arrows
   for i,arrow in ipairs(arrow_list) do
      if arrow.facing == "down" then
         love.graphics.draw(arrow.img, arrow.x, arrow.y, math.rad(90), 1, 1, 0, 0)

      elseif arrow.facing == "right" then
         love.graphics.draw(arrow.img, arrow.x, arrow.y)
      elseif arrow.facing == "left" then
         -- Flip the archer. This also changes it's x pos
         love.graphics.draw(arrow.img, arrow.x + const.arrow.img_width, arrow.y, 0, -1, 1)
      end
      -- Arrow Hitbox
      --[[
      love.graphics.line(
         arrow.x + const.arrow.hitbox.x1, arrow.y + const.arrow.hitbox.y1,
         arrow.x + const.arrow.hitbox.x2, arrow.y + const.arrow.hitbox.y1,
         arrow.x + const.arrow.hitbox.x2, arrow.y + const.arrow.hitbox.y2,
         arrow.x + const.arrow.hitbox.x1, arrow.y + const.arrow.hitbox.y2,
         arrow.x + const.arrow.hitbox.x1, arrow.y + const.arrow.hitbox.y1)
      --]]
      

   end

   --love.graphics.draw(images.platform, 10, 10);

   
   for i, tile in ipairs(map.data) do
      local x = tile.x * const.map.img_width
      local y = tile.y * const.map.img_height
      love.graphics.draw(images.platform, x, y)
   end

end


return {
   load = load,
   keypressed = keypressed,
   keyreleased = keyreleased,
   update = update,
   draw = draw
}

