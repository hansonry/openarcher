

local function load()
   title = love.graphics.newImage("assets/title.png")
   startgame = false
end


local function keypressed(key)
   
end

local function keyreleased(key)
   if key == " " then
      startgame = true
   end
end

local function update(dt)
   if startgame then
      return "game"
   else
      return "menu"
   end
end

local function draw()
   love.graphics.draw(title, 10, 10);
end

return {
   load        = load,
   keypressed  = keypressed,
   keyreleased = keyreleased,
   update      = update,
   draw        = draw,
}

