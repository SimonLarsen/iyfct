front_x = 0
back_x = 0

back_terrain = love.graphics.newQuad(0,112,300,94,512,512)
front_terrain = love.graphics.newQuad(0,224,300,94,512,512)

function updateTerrain(dt)
	front_x = (front_x + 65*dt) % WIDTH
	back_x = (back_x + 40*dt) % WIDTH
end

function drawTerrain()
	love.graphics.drawq(imgTerrain,back_terrain,0-back_x,0)
	love.graphics.drawq(imgTerrain,back_terrain,WIDTH-back_x,0)
	love.graphics.drawq(imgTerrain,front_terrain,0-front_x,0)
	love.graphics.drawq(imgTerrain,front_terrain,WIDTH-front_x,0)
end
