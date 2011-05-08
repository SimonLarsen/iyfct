require("player")
require("cloud")
require("train")
require("tunnel")

WIDTH = 300
HEIGHT = 100
SCALE = 2

TRACK_SPEED = 150

track_quad = love.graphics.newQuad(0,48,121,5,128,128)


function love.load()
	math.randomseed(os.time())
	love.graphics.setBackgroundColor(255,255,255)

	loadResources()
	restart()
	updateScale()
end

function restart()
	pl = Player.create()
	clouds = {}
	track_frame = 0
	nextCloud = 0
	global_speed = 1.0

	train = Train.create()
	train.alive = false
	tunnel = Tunnel.create()
	tunnel.alive = false
	train.x = -190
end

function love.update(dt)
	-- Update player
	Player.update(pl,dt)

	-- Update clouds
	spawnClouds(dt)
	for i,v in ipairs(clouds) do
		Cloud.update(v,dt)
		if v.x < -32 then
			table.remove(clouds,i)
		end
	end
	
	-- Update trains
	Train.update(train,dt)
	Player.collideWithTrain(pl)
	
	-- Update tunnel
	Tunnel.update(tunnel,dt)
	Player.collideWithTunnel(pl)
	
	-- Move tracks
	track_frame = track_frame + global_speed * dt * TRACK_SPEED
	if track_frame >= 11 then
		track_frame = track_frame % 11
	end

	-- Increase speed
	global_speed = global_speed + 0.05*dt

	-- Respawn train or tunnel
	if train.alive == false then
		if tunnel.alive == false then
			if math.random(1,TUNNEL_PROBABILITY) == 1 then -- spawn tunnel
				tunnel = Tunnel.create()
			else -- spawn train
				train = Train.createRandom()
			end
		else
			if math.random(1,32) == 1 then
				train = Train.create(2)
			end
		end
	end
end

function love.draw()
	love.graphics.scale(SCALE,SCALE)

	-- Draw background clouds
	for i,v in ipairs(clouds) do
		if v.speed < 37 then Cloud.draw(v) end
	end

	-- Draw back of tunnel
	Tunnel.drawBack(tunnel)

	-- Draw railroad tracks
	for i=0,2 do
		love.graphics.drawq(imgSprites,track_quad,i*121 - track_frame,92)
	end

	-- Draw train
	Train.draw(train)

	-- Draw player
	love.graphics.setColor(255,255,255,255)
	Player.draw(pl)

	-- Draw front of tunnel
	Tunnel.drawFront(tunnel)

	-- Draw foreground clouds
	for i,v in ipairs(clouds) do
		if v.speed >= 37 then Cloud.draw(v) end
	end
end

function loadResources()
	imgSprites = love.graphics.newImage("gfx/sprites.png")
	imgSprites:setFilter("nearest","nearest")
	
	imgTrains = love.graphics.newImage("gfx/trains.png")
	imgTrains:setFilter("nearest","nearest")

	imgTerrain = love.graphics.newImage("gfx/terrain.png")
	imgTerrain:setFilter("nearest","nearest")
end

function love.keypressed(key,unicode)
	if key == ' ' then -- will be space most of the time
		return         -- avoid unnecessary checks
	elseif key == 'r' or key == "return" then
		restart()
	elseif key == '1' then
		SCALE = 1
		updateScale()
	elseif key == '2' then
		SCALE = 2
		updateScale()
	elseif key == '3' then
		SCALE = 3
		updateScale()
	elseif key == '4' then
		SCALE = 4
		updateScale()
	end
end

function updateScale()
	SCRNWIDTH = WIDTH*SCALE
	SCRNHEIGHT = HEIGHT*SCALE
	love.graphics.setMode(SCRNWIDTH,SCRNHEIGHT,false)
end
