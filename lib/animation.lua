

local Animation = {}

function Animation.new(frames, fps, loop)
   local anim = { frames = frames, loop = loop }
   anim.index = 1
   anim.t = 0
   anim.dt = 1 / fps
   anim.active = false


   -- start / stop
   function anim:start(target, callback)
      self.target = target
      self.callback = callback
      self.index = 1
      self.active = true
      self:onStarted()
   end

   function anim:stop()
      if self.active then
	 self:onStopped()
	 self.active = false
	 self.target = nil
	 if self.callback then
	    self.callback()
	 end
      end
   end

   function anim:onStarted() end
   function anim:onStopped() end

   function anim:updateFrame(dt)
      local change = false
      if self.active then
	 self.t = self.t + dt
	 if self.t > self.dt then
	    self.t = self.t - self.dt
	    if self.t > self.dt then self.t = 0 end -- self.dt is too small
	    self.index = self.index + 1
	    change = true
	 end
	 if self.index > #self.frames then
	    self.index = 1
	    if not self.loop then
	       self:stop()
	    end
	 end
      end

      return change, not self.active
   end

   function anim:update(dt, item)
      -- empty
   end

   return anim
end

function Animation.newKey(frames, fps, loop)
   local anim = Animation.new(frames, fps, loop)

   function anim:update(dt, sprite)
      if self.active then
	 self:updateFrame(dt)
	 sprite.index = self.frames[self.index] + 1
      end
   end
   return anim
end

function Animation.newFlash(frames)
   frames = frames or { 255, 0, 255, 0, 255, 0, 255 }
   local anim = Animation.new(frames, 20, false)

   function anim:onStarted()
      self.org_alpha = self.target.alpha
   end

   function anim:onStopped()
      self.target.alpha = self.org_alpha
   end

   function anim:update(dt, sprite)

      if self.active then
	 changed, ended = self:updateFrame(dt)
	 if not ended then

	    -- interpolate between curr and next frame
	    local indexnext = self.index + 1
	    if indexnext > #self.frames then
	       indexnext = 1
	    end
	    local curr = self.frames[self.index]
	    local next = self.frames[indexnext]
	    local delta = self.t / self.dt

	    sprite.alpha = curr * (1 - delta) + next * delta
	 end
      end
   end
   return anim
end

function Animation.newShake()
   local frames = { 10, 20, 5, 10, 2, 0}
   local anim = Animation.new(frames, 15, false)

   function anim:next()
      local amnt = self.frames[ self.index]
      self.p1 = {
	 x = self.p0.x + math.random(-amnt, amnt),
	 y = self.p0.y + math.random(-amnt, amnt)
      }
   end

   function anim:onStarted()
      self.p0 = { x = self.target.x, y = self.target.y }
      self:next()
   end
   function anim:onStopped()
      self.target.x = self.p0.x
      self.target.y = self.p0.y
   end

   function anim:update(dt, item)
      if self.active then
	 local change, ended = self:updateFrame(dt)
	 if change then
	    self:next()
	 end
	 if not ended then
	    local amnt = self.t / self.dt
	    item.x = item.x * amnt + self.p1.x * (1 - amnt)
	    item.y = item.y * amnt + self.p1.y * (1 - amnt)
	 end
      end
   end

   return anim
end

return Animation
