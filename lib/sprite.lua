
local MAXVEL = 30000
local Sprite = {}

function Sprite.new(x, y, tex)
   local sprite = Item.new(x, y)


   function sprite:updateMotion(dt)
      self.vx = math.max( -MAXVEL, math.min( MAXVEL, self.vx + self.ax * dt));
      self.vy = math.max( -MAXVEL, math.min( MAXVEL, self.vy + self.ay * dt));
      self.x = self.x + self.vx * dt;
      self.y = self.y + self.vy * dt;
   end

   function sprite:update(dt)
      self:updateMotion(dt)
      self:updateAnimation(dt, self)
   end

   function sprite:draw()
      if self.alpha > 0 then
	 local sx, x = 1, self.x
	 if self.facing then
	    sx = -1
	    x = x + self.w
	 end

	 love.graphics.setColor(255,255, 255, self.alpha)
	 love.graphics.draw(self.tex.image,
			    self.tex.quads[self.index],
			    x, self.y, 0, sx, 1)
      end
   end

   function sprite:reset()
      self.ax = 0
      self.ay = 0
      self.vx = 0
      self.vy = 0
   end

   function sprite:overlaps(si)
      local ax1, ay1 = self.x, self.y
      local ax2, ay2 = ax1 + self.w, ay1 + self.h
      local bx1, by1 = si.x, si.y
      local bx2, by2 = bx1 + si.w, by1 + si.h
      return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1;
   end


   sprite.tex = tex
   sprite.alpha = 255
   sprite.index = 1
   sprite.w = tex.w
   sprite.h = tex.h
   sprite:reset()

   return sprite
end

return Sprite
