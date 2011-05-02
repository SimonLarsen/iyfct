Player = {}

JUMP_POWER = -300
GRAVITY = 1000
PLAYER_WIDTH = 14
PLAYER_HEIGHT = 21

function Player.create()
	local self = {}
	self.frame = 0
	self.x = 14
	self.y = 71
	self.yspeed = 0
	self.onGround = true
	self.status = 0
	return self
end

function Player.update(self,dt)
	-- Check keyboard input
	if love.keyboard.isDown(' ') and self.onGround == true then
		self.yspeed = JUMP_POWER
		self.onGround = false
	end

	self.onGround = false

	-- Update position
	if self.status == 0 then
		self.y = self.y + self.yspeed*dt
		if self.y > 71 then
			self.y = 71
			self.yspeed = 0
			self.onGround = true
		end
		self.yspeed = self.yspeed + dt*GRAVITY

	elseif self.status == 1 then
		self.x = train.x-10
	
	elseif self.status == 3 then
		self.y = 66
	end

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

function Player.collideWithTrain(self)
	if self.status == 0 then
		-- check collision with front of train
		if Player.collideWithPoint(self,train.x+4,train.y+10) or
		Player.collideWithPoint(self,train.x+2,train.y+24) then
			if train.type == 1 then -- hit by closed train
				self.status = 1 -- hit by train	
				if self.y < train.y-9 then
					self.y = train.y-9
				end
			elseif train.type == 2 then -- hit by open train
				self.status = 3
			end
		end
		-- check if landed on train
		if train.x < self.x and train.x+125 > self.x then
			if self.y > 35 then
				self.y = 35
				self.yspeed = 0
				self.onGround = true
			end
		end
	end

	if self.status == 3 then
		if self.x > train.x+135 then
			self.status = 0
		end
	end
end

function Player.collideWithPoint(self,x,y)
	if x > self.x and x < self.x+PLAYER_WIDTH
	and y > self.y and y < self.y+PLAYER_HEIGHT then
		return true
	else
		return false
	end
end

--[[ Status values:
	0 = alive
	1 = hit by train
	2 = hit by bird
	3 = inside train
	4 = falling through ground
--]]
