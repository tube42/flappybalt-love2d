
local img_dove = utils.loadImage("assets/dove.png", 3)

local Player = {}

function Player.new(x, y)
   local player = Sprite.new(x, y, img_dove)

   function player:update(dt)
      self:updateMotion(dt)
      self:updateAnimation(dt)
   end

   function player:flap()
      if self.ay == 0 then
	 self.ay = 500
	 self.vx = 80
      end
      self.vy = -240
      self:play("flap", true)
   end

   function player:kill()
      if self.alive then
	 self.alive = false
	 self.vx = 0
	 self.ax = 0
      end
   end

   function player:reset()

      -- base.reset() :(
      self.vx = 0
      self.vy = 0
      self.ax = 0
      self.ay = 0

      self:stop()
      self.tex.index = 2
      self.alive = true
   end

   player:addAnimation("flap", Animation.newKey( {1,0,1,2}, 12, false))
   player:reset()
   return player
end

return Player
