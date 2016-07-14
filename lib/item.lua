local Item = {}


function Item.new(x, y)
   local item = { }

   -- animations
   function item:addAnimation(name, anim)
      table.insert(self.animations, { name = name, anim = anim })
   end

   function item:getAnimation(name)
      for _, v in pairs(self.animations) do
	 if v.name == name then
	    return v.anim
	 end
      end
      return nil
   end

   function item:play(name, force, callback)
      local a = self:getAnimation(name)
      if a then
	 local f = force or false
	 self.curr_anim = a
	 if not a.active or f then
	    a:start(self, callback)
	 end
      else
	 print("Animation not found: " .. name)
      end
   end


   function item:stop()
      if self.curr_anim then
	 self.curr_anim:stop(self)
	 self.curr_anim = nil
      end
   end

   function item:updateAnimation(dt)
      if self.curr_anim then
	 self.curr_anim:update(dt, self)
	 if not self.curr_anim.active then
	    self.curr_anim = nil
	 end
      end
   end

   function item:update(dt)
      self:updateAnimation(dt)
   end

   function item:draw() end
   function item:reset() end

   item.x = x
   item.y = y
   item.animations = {}
   item.curr_anim = nil
   return item
end

return Item
