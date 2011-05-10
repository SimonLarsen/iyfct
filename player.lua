Player = {}

JUMP_POWER = -300
GRAVITY = 1000
PLAYER_WIDTH = 14
PLAYER_HEIGHT = 21
PLAYER_START_X = 64

function Player.create()
	local self = {}
	self.frame = 0
	self.x = PLAYER_START_X
	self.y = 71
	self.yspeed = 0
	self.onGround = true
	self.status = 0
	self.alive = true
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
	self.yspeed = self.yspeed + dt*GRAVITY

	if self.status == 0 then -- normal ourside
		self.y = self.y + self.yspeed*dt
		if self.y > 71 then
			self.y = 71
			self.yspeed = 0
			self.onGround = true
		end
	
	elseif self.status == 3 then -- inside train
		self.y = self.y + self.yspeed*dt
		if self.y > 66 then
			self.y = 66
			self.yspeed = 0
			self.onGround = true
		elseif self.y < 60 then
			self.y = 60
			self.yspeed = 0
		end

	elseif self.status == 1 then -- hit by train
		self.y = self.y + self.yspeed*dt
		self.x = self.x - dt*300
	
	elseif self.status == 5 then -- hit by mountain
		self.x = self.x - global_speed * dt * TRACK_SPEED * 1.5
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
	if self.status == 0 then
		love.graphics.drawq(imgSprites,quad,self.x,self.y)

	elseif self.status == 1 or self.status == 5 then
		love.graphics.drawq(imgSprites,quad,self.x,self.y, -self.x/10, 1,1,7,10)

	else -- default case
		love.graphics.drawq(imgSprites,quad,self.x,self.y)
	end
end

function Player.collideWithTrain(self)
	if train.alive == false then
		return
	end

	if self.status == 0 then
		-- check collision with front of train
		if Player.collideWithPoint(self,train.x+4,train.y+10) or
		Player.collideWithPoint(self,train.x+2,train.y+24) then
			if train.type == 1 then -- hit by closed train
				self.status = 1 -- hit by train	
				self.alive = false
				self.yspeed = -100
				if self.y < train.y-9 then
					self.y = train.y-9
				end

			elseif train.type == 2 then -- hit by open train
				if self.yspeed >= 0 then
					self.status = 3
				else
					self.status = 1
				end
			end
		-- check if landed on train
		elseif train.x < self.x and train.x+125 > self.x and self.yspeed > 0 then
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

function Player.collideWithTunnel(self)
	if tunnel.alive == false then
		return
	end

	if self.status == 0 then
		if self.y < 47 and self.x < tunnel.x and
		self.x > tunnel.x-16 then
			self.status = 5
			self.alive = false
		end
	end
end

function Player.collideWithBirds(self)
	for i,v in ipairs(birds) do
		if Player.collideWithPoint(self,v.x+5.5,v.y+5) then
			self.status = 1
			self.alive = false
			return
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
	4 = falling through ground? UNUSED
	5 = hit by mountain
--]]
