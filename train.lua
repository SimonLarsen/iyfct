Train = {}
normal_train_quad = love.graphics.newQuad(0,0,132,36,256,256)
open_train_quad = love.graphics.newQuad(0,48,146,36,256,256)
inside_train_quad = love.graphics.newQuad(0,96,146,36,256,256)

TRAIN_MIN_SPEED = 160
TRAIN_MAX_SPEED = 220

function Train.create()
	return Train.createWithParams(math.random(TRAIN_MIN_SPEED,TRAIN_MAX_SPEED),math.random(1,2))
end

function Train.createWithParams(speed,type)
	local self = {}
	self.speed = speed
	self.x = WIDTH
	self.y = 56
	self.type = type
	self.alive = true
	return self
end

function Train.update(self,dt)
	if self.alive == false then
		return
	end

	self.x = self.x - self.speed*dt*global_speed
	if self.x < -146 then
		self.alive = false
	end
end

function Train.draw(self)
	if self.alive == false then
		return
	end

	if self.type == 1 then -- closed train
		love.graphics.drawq(imgTrains,normal_train_quad,self.x,self.y)
	elseif self.type == 2 then -- open train from outside
		if pl.status == 3 then
			love.graphics.drawq(imgTrains,inside_train_quad,self.x-7,self.y)
		else
			love.graphics.drawq(imgTrains,open_train_quad,self.x-7,self.y)
		end
	end
end
