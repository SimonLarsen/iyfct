require("player")
require("cloud")
require("train")
require("tunnel")
require("bird")
require("terrain")

WIDTH = 300
HEIGHT = 100
SCALE = 3

bgcolor = {236,243,201,255}

TRACK_SPEED = 150
SPEED_INCREASE = 0.04

track_quad = love.graphics.newQuad(0,48,121,5,128,128)

function love.load()
	math.randomseed(os.time())
	love.graphics.setBackgroundColor(bgcolor)

	loadResources()
	love.graphics.setFont(imgfont)
	pl = Player.create()
	restart()
	updateScale()
end

function restart()
	pl:reset()
	clouds = {}
	next_cloud = 0
	birds = {}
	next_bird = 1
	global_speed = 1.7 
	track_frame = 0
	scrn_shake = 0

	train = Train.create()
	train.alive = false
	tunnel = Tunnel.create()
	tunnel.alive = false

	score = 0
	coffee = 0
end

function love.update(dt)
	-- Update screenshake thingy
	if scrn_shake > 0 then
		scrn_shake = scrn_shake - dt
	end

	-- Update player
	pl:update(dt)

	-- Update clouds
	spawnClouds(dt)
	for i,cl in ipairs(clouds) do
		cl:update(dt)
		if cl.x < -32 then
			table.remove(clouds,i)
		end
	end

	-- Update trains
	train:update(dt)
	pl:collideWithTrain()
	
	-- Update tunnel
	tunnel:update(dt)
	pl:collideWithTunnel()
	
	-- Update birds
	spawnBirds(dt)
	for i,b in ipairs(birds) do
		b:update(dt)
		if b.alive == false then
			table.remove(birds,i)
		end
	end
	pl:collideWithBirds()

	-- Move tracks
	track_frame = track_frame + global_speed * dt * TRACK_SPEED
	if track_frame >= 11 then
		track_frame = track_frame % 11
	end

	-- Update terrain (skyscrapers etc.)
	updateTerrain(dt)

	-- Increase speed and score
	--if pl.status == 0 or pl.status == 3 then
	if pl.alive == true then
		global_speed = global_speed + SPEED_INCREASE*dt
		if global_speed > 2.5 then global_speed = 2.5 end
		score = score + 20*dt
	end

	-- Respawn train or tunnel
	if train.alive == false then
		if tunnel.alive == false then
			if math.random(1,TUNNEL_PROBABILITY) == 1 then -- spawn tunnel
				tunnel = Tunnel.create()
			else -- spawn train
				train = Train.createRandom()
			end
		else
			if tunnel.x > WIDTH then
				train = Train.create(2)
				train.x = tunnel.x + math.random(1,250) - (tunnel.x - WIDTH)
			end
		end
	end
end

function love.draw()
	love.graphics.scale(SCALE,SCALE)
	love.graphics.setColor(255,255,255,255)
	love.graphics.setLineStyle("rough")

	-- Shake camera if hit
	if scrn_shake > 0 then
		love.graphics.translate(5*(math.random()-0.5),5*(math.random()-0.5))
	end

	-- Draw terrain (skyscrapers etc.)
	drawTerrain()

	-- Draw clouds
	for i,cl in ipairs(clouds) do
		cl:draw()
	end

	-- Draw back of tunnel
	tunnel:drawBack()

	-- Draw railroad tracks
	for i=0,2 do
		love.graphics.drawq(imgSprites,track_quad,i*121 - track_frame,92)
	end

	-- Draw train
	train:draw()

	-- Draw player
	love.graphics.setColor(255,255,255,255)
	pl:draw()

	-- Draw front of tunnel
	tunnel:drawFront()

	-- Draw birds
	for i,b in ipairs(birds) do
		b:draw(v)
	end

	-- Draw score
	love.graphics.setColor(0,0,0,255)
	love.graphics.print(math.floor(score),8,8)

	if pl.alive == false then
		love.graphics.printf("you didn't make it to work\npress r to retry",0,45,WIDTH,"center")
	end

	-- Draw coffee meter
	local cquad = love.graphics.newQuad(48+math.floor(coffee)*9,64,9,9,128,128)
	if coffee < 5 or pl.frame < 4 then
		love.graphics.drawq(imgSprites,cquad,284,7)
	end
end

function loadResources()
	imgSprites = love.graphics.newImage("gfx/sprites.png")
	imgSprites:setFilter("nearest","nearest")
	
	imgTrains = love.graphics.newImage("gfx/trains.png")
	imgTrains:setFilter("nearest","nearest")

	imgTerrain = love.graphics.newImage("gfx/terrain.png")
	imgTerrain:setFilter("nearest","nearest")

	fontimg = love.graphics.newImage("gfx/imgfont.png")
	fontimg:setFilter("nearest","nearest")
	imgfont = love.graphics.newImageFont(fontimg," abcdefghijklmnopqrstuvwxyz0123456789.!'-")
	imgfont:setLineHeight(2)
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
	elseif key == 'g' then
		coffee = coffee+1
	end
end

function updateScale()
	SCRNWIDTH = WIDTH*SCALE
	SCRNHEIGHT = HEIGHT*SCALE
	love.graphics.setMode(SCRNWIDTH,SCRNHEIGHT,false)
end
