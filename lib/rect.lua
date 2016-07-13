
local Rect = {}

function Rect.new(x, y, w, h)
   local rect = Item.new(x, y)

   function rect:draw()
      if self.alpha >= 1 then
	 love.graphics.setColor(255,255, 255, self.alpha)
	 love.graphics.rectangle("fill",
				 self.x, self.y,
				 self.w, self.h)
      end
   end

   rect.w = w
   rect.h = h
   rect.alpha = 255
   return rect
end

return Rect
