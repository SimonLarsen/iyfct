Player = {}

JUMP_POWER = -300
GRAVITY = 1000

function Player.create()
	local self = {}
	self.frame = 0
	self.x = 14
	self.y = 71
	self.yspeed = 0
	self.onGround = true
	return self
end

function Player.update(self,dt)
	-- Check keyboard input
	if love.keyboard.isDown(' ') and self.onGround == true then
		self.yspeed = JUMP_POWER
		self.onGround = false
	end

	-- Update position
	self.y = self.y + self.yspeed*dt
	if self.y > 71 then
		self.y = 71
		self.yspeed = 0
		self.onGround = true
	end
	self.yspeed = self.yspeed + dt*GRAVITY

	-- Update walk frame
	self.frame = self.frame + 20*dt
	if self.frame >= 6 then
		self.frame = 0
	end
end

function Player.draw(self)
	local frame = 15*math.floor(self.frame)
	local quad = love.graphics.newQuad(frame,0,15,21,128,128)
	love.graphics.drawq(imgSprites,quad,self.x,self.y)
end
