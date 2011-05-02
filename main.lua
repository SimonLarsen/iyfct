require("player")
require("cloud")
require("train")

WIDTH = 300
HEIGHT = 100
SCALE = 2
SCRNWIDTH = WIDTH*SCALE
SCRNHEIGHT = HEIGHT*SCALE

track_quad = love.graphics.newQuad(0,48,121,5,128,128)

global_speed = 1.0

function love.load()
	love.graphics.setMode(SCRNWIDTH,SCRNHEIGHT,false)
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setLineWidth(2)

	loadResources()

	pl = Player.create()
	clouds = {}
	track_frame = 0
	nextCloud = 0

	train = Train.create(10,1)
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
	if train.x < -200 then
		train.x = WIDTH
		train.speed = global_speed*math.random(TRAIN_MIN_SPEED,TRAIN_MAX_SPEED)
		train.type = math.random(1,2)
	end

	Player.collideWithTrain(pl)
	
	-- Move tracks
	track_frame = track_frame + global_speed * dt * 150
	if track_frame >= 11 then
		track_frame = 0
	end

	-- Increase speed
	global_speed = global_speed + 0.05*dt
end

function love.draw()
	love.graphics.scale(SCALE,SCALE)

	-- Draw background clouds
	for i,v in ipairs(clouds) do
		if v.speed < 37 then Cloud.draw(v) end
	end

	-- Draw train
	Train.draw(train)

	-- Draw player
	love.graphics.setColor(255,255,255,255)
	Player.draw(pl)

	-- Draw foreground clouds
	for i,v in ipairs(clouds) do
		if v.speed >= 37 then Cloud.draw(v) end
	end

	-- Draw railroad tracks
	for i=0,2 do
		love.graphics.drawq(imgSprites,track_quad,i*121 - track_frame,92)
	end
end

function loadResources()
	imgSprites = love.graphics.newImage("gfx/sprites.png")
	imgSprites:setFilter("nearest","nearest")
	
	imgTrains = love.graphics.newImage("gfx/trains.png")
	imgTrains:setFilter("nearest","nearest")
end
