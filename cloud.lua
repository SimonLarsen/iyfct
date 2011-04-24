Cloud = {}

function Cloud.create(y,size,type)
	local self = {}
	self.x = WIDTH
	self.y = y
	self.size = size
	self.speed = math.random(25,50)
	self.type = type
	return self
end

function Cloud.update(self,dt)
	self.x = self.x - dt*self.speed
end

function Cloud.draw(self)
	local quad = nil
	if self.size == 1 then
		quad = love.graphics.newQuad(self.type*16,32,16,16,128,128)
	elseif self.size == 2 then
		quad = love.graphics.newQuad(48+self.type*32,32,32,16,128,128)
	end
	if quad ~= nil then
		love.graphics.drawq(imgSprites,quad,self.x,self.y)
	end
end
