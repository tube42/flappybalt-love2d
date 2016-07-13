
local lg = love.graphics


local camera = Item.new(0, 0)
camera.scale = 1
camera.rot = 0

function camera:set()
   lg.push()
   lg.translate( - self.x, - self.y)
   lg.rotate( self.rot)
   lg.scale( self.scale, self.scale)
end

function camera:unset()
   lg.pop()
end

return camera
