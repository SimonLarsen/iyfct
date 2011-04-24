Player = {}

function Player.create()
	local p = {}
	p.frame = 0
	p.x = 14
	p.y = 71
	return p
end

function Player.update(self,dt)
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
