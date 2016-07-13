local Text = {}

local Item = require("lib/item")

function Text.new(x, y, fontsize)
   local text = Item.new(x, y)

   function text:draw()
      love.graphics.setColor(self.color.r, self.color.g,
			     self.color.b, self.color.a)
      love.graphics.setFont(self.font)
      love.graphics.print(self.text,
			  self.x ,
			  self.y)
   end


   function text:reset()

   end

   function text:setAlignment(sx, sy, tx, ty)
      self.align = { sx = sx, sy = sy, tx = tx, ty = ty }
   end

   function text:setColor(r, g, b, a)
      a = a or 255
      text.color = { r = r, g = g, b = b, alpha = a }
   end


   text.font = love.graphics.newFont(fontsize)
   text.text = ""
   text.w = 1
   text.h = 1
   text:setColor(255, 255, 255, 255)
   text:setAlignment(0, 0, 0, 0)
   text:reset()

   return text
end

return Text
