Tunnel = {}

TUNNEL_PROBABILITY = 6
tunnel_start_back = love.graphics.newQuad(0,0,58,100,128,128)
tunnel_start_front = love.graphics.newQuad(58,0,6,100,128,128)
tunnel_end = love.graphics.newQuad(64,0,53,100,128,128)

function Tunnel.create()
	local self = {}
	self.x = WIDTH+52
	self.alive = true
	return self
end

function Tunnel.update(self,dt)
	if self.alive == false then
		return
	end

	self.x = self.x - global_speed * dt * TRACK_SPEED

	if self.x < -200 then
		self.alive = false
	end
end

function Tunnel.drawBack(self)
	if self.alive == true then
		love.graphics.drawq(imgTerrain,tunnel_start_back,self.x-58,0)
	end
end

function Tunnel.drawFront(self)
	if self.alive == true then
		love.graphics.setColor(255,255,255,255)
		love.graphics.rectangle("fill",self.x+6,0,97,HEIGHT)
		love.graphics.drawq(imgTerrain,tunnel_start_front,self.x,0)
		love.graphics.drawq(imgTerrain,tunnel_end,self.x+90,0)
	end
end
