
utils = require "lib/utils"

Item = require("lib/item")
Sprite = require("lib/sprite")
Text = require("lib/text")
Rect  = require("lib/rect")

Animation = require("lib/animation")

Paddle = require("paddle")
Player = require("player")

local SCALE = 3

local app = { items = {}, score = 0 }
local sw = love.window:getWidth() / SCALE
local sh = love.window:getHeight() / SCALE

function app:load()
   local img_bg = utils.loadImage("assets/background.png", 1)
   local img_bounce = utils.loadImage("assets/bounce.png", 1)

   self.scoreBest = self:loadScore()
   self.camera = require("lib/camera")
   self.camera.scale = SCALE
   self.camera:addAnimation("shake", Animation.newShake())

   self.bg = Sprite.new(0, 0, img_bg)
   self.flash = Rect.new(0, 0, sw, sh)
   self.flash:addAnimation("flash", Animation.newFlash({ 0, 255, 0, 255, 0, 255, 0 }))

   self.player = Player.new(sw / 2 - 4, sh / 2 - 4)

   self.paddleLeft = Paddle.new(6, false)
   self.paddleRight = Paddle.new(sw - 15, true)

   self.bounceLeft = Sprite.new(-3, 17, img_bounce)
   self.bounceRight = Sprite.new(sw - 5, 17, img_bounce)
   self.bounceLeft.facing = true
   self.bounceRight:addAnimation("flash", Animation.newFlash())
   self.bounceLeft:addAnimation("flash", Animation.newFlash())

   self.scoreDisplay = Text.new(sw / 2 - 12, 141, 24)
   self.scoreDisplay.setColor(0xff, 0x4d, 0x4d, 0x59)
   self.highscoreDisplay = Text.new(sw / 2 - 8, 20, 16)
   self.highscoreDisplay.setColor(255, 255, 255, 255)

   self:add( self.bg)
   self:add( self.bounceLeft)
   self:add( self.bounceRight)
   self:add( self.paddleLeft)
   self:add( self.paddleRight)
   self:add( self.highscoreDisplay)
   self:add( self.scoreDisplay)
   self:add( self.player)
   self:add( self.flash)

   self:reset()
end

function app:reset()
   for _,v in pairs(self.items) do
      v:reset()
   end

   if self.scoreBest > 0 then
      self.highscoreDisplay.text = tostring(self.scoreBest)
   else
      self.highscoreDisplay.text = ""
   end

   self.scoreDisplay.text = ""
   self.score = 0

   self.player.facing = false
   self.player.x = sw / 2 - 4
   self.player.y = sh / 2 - 4

   self.paddleLeft:randomize()
   -- self.paddleRight:randomize()
   self.paddleRight.y = (sh - self.paddleRight.h) / 2

   self.flash.alpha = 0
end

function app:loadScore()
   data, size = love.filesystem.read("bestscore.txt")
   if data then
      return tonumber(data)
   end
   return 0
end

function app:saveScore(score)
   love.filesystem.write("bestscore.txt", tostring(score))
end

function app:add(item)
   table.insert(self.items, item)
end

function app:draw()
   self.camera:set()

   for _,v in pairs(self.items) do
      v:draw()
   end

   self.camera:unset()
end

function app:update(dt)
   self.camera:update(dt)
   for _,v in pairs(self.items) do
      v:update(dt)
   end

   local p = self.player
   local pl = self.paddleLeft
   local pr = self.paddleRight
   local bl = self.bounceLeft
   local br = self.bounceRight

   local edges = 14
   if (p.y < edges) or (p.y + p.h > sh - edges) or
   p:overlaps(pl) or p:overlaps(pr) then
      if p.alive then
	 if self.score > self.scoreBest then
	    self.scoreBest = self.score
	    self:saveScore(self.score)
	 end

	 p:kill()
	 self.camera:play("shake")
	 self.flash:play("flash", app.reset(self) )
      end
   elseif p.x < 5 then
      p.x = 5;
      p.vx = -p.vx;
      p.facing = false
      self.score = self.score + 1
      self.scoreDisplay.text = tostring(self.score)
      bl:play("flash")
      pr:randomize()
   elseif p.x + p.w > sw - 5 then
      p.x = sw - p.w - 5
      p.vx = -p.vx;
      p.facing = true
      self.score = self.score + 1
      self.scoreDisplay.text = tostring(self.score)
      br:play("flash")
      pl:randomize()
   end
end


function love.keypressed(k)
   if k == 'escape' then
      love.event.push('quit')
   elseif k == " " then
      app.player:flap()
   end
end


--

function love.load()
   app:load()
end

function love.update(dt)
   app:update(dt)
end

function love.draw()
   app:draw()
end
