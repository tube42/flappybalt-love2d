
local utils = {}

local function calcQuads(image, count)
   -- calc sub images in a texture, assuming there is only one row
   local quads = {}
   local sw, sh = image:getDimensions()
   local w = sw / count

   for x = 1,count do
      quads[x] = love.graphics.newQuad((x -1) * w, 0, w, sh, sw, sh)
   end
   return quads, w, sh
end

function utils.loadImage(filename, n)
   local img = love.graphics.newImage(filename)
   img:setFilter("nearest", "nearest")
   local quads, sw, sh = calcQuads(img, n)
   return { image = img, quads = quads, w = sw, h = sh }
end


function utils.dump(name, obj)
   print("\nDumping " .. name ..  ":")

   if type(obj) ~= "table" then
      print(obj)
   else
      for k, v in pairs(obj) do
	 print(k, "->", v)
      end
   end
end

return utils
