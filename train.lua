Train = {}
normal_train_quad = love.graphics.newQuad(0,0,132,36,256,256)

function Train.create(speed,type)
	local self = {}
	self.speed = speed
	self.x = WIDTH
	self.y = 56
	self.type = type
	return self
end

function Train.update(self,dt)
	self.x = self.x - self.speed*dt
end

function Train.draw(self)
	if self.type == 1 then -- closed train
		love.graphics.drawq(imgTrains,normal_train_quad,self.x,self.y)
	end
end
