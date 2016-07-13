
local img_paddle = utils.loadImage("assets/paddle.png", 1)
local SPEED = 480
local Paddle = {}

function Paddle.new(x, facing)
   local paddle = Sprite.new(x, 0, img_paddle)

   function paddle:randomize()
      self.targetY = 16 + math.random()*(208-self.h);
      if self.targetY < self.y then
	 self.vy = -SPEED
      else
	 self.vy = SPEED
      end
   end

   function paddle:update(dt)
      self:updateMotion(dt)

      if ((self.vy < 0) and (self.y <= self.targetY + SPEED * dt)) or
      ((self.vy > 0) and (self.y >= self.targetY - SPEED * dt)) then
	 self.vy = 0;
	 self.y = self.targetY;
      end
   end

   paddle.targetY = 0
   paddle.facing = facing
   paddle:randomize()
   return paddle
end

return Paddle
