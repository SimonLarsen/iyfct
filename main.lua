require("player")
require("cloud")
require("train")

WIDTH = 300
HEIGHT = 100
SCALE = 2
SCRNWIDTH = WIDTH*SCALE
SCRNHEIGHT = HEIGHT*SCALE

track_quad = love.graphics.newQuad(0,48,121,5,128,128)

function love.load()
	love.graphics.setMode(SCRNWIDTH,SCRNHEIGHT,false)
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setLineWidth(2)

	loadResources()

	pl = Player.create()
	clouds = {}
	track_frame = 0
	nextCloud = 0

	trains = {}
	table.insert(trains,Train.create(135,1))
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
	for i,v in ipairs(trains) do
		Train.update(v,dt)
		if v.x < -150 then
			table.remove(trains,i)
		end
	end
	
	-- Move tracks
	track_frame = track_frame + dt*150
	if track_frame >= 11 then
		track_frame = 0
	end
end

function love.draw()
	love.graphics.scale(SCALE,SCALE)

	-- Draw background clouds
	for i,v in ipairs(clouds) do
		if v.speed < 37 then
			Cloud.draw(v)
		end
	end

	-- Draw player
	love.graphics.setColor(255,255,255,255)
	Player.draw(pl)

	-- Draw foreground clouds
	for i,v in ipairs(clouds) do
		if v.speed >= 37 then
			Cloud.draw(v)
		end
	end

	-- Draw trains
	for i,v in ipairs(trains) do
		Train.draw(v)
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
