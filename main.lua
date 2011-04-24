require("player")
require("cloud")

WIDTH = 300
HEIGHT = 100
SCALE = 2
SCRNWIDTH = WIDTH*SCALE
SCRNHEIGHT = HEIGHT*SCALE

CLOUD_SPAWN_RATE = 0.25

function love.load()
	love.graphics.setMode(SCRNWIDTH,SCRNHEIGHT,false)
	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setLineWidth(2)

	loadResources()

	pl = Player.create()
	clouds = {}
	table.insert(clouds,Cloud.create(0,1,1))
	nextCloud = 0
end

function love.update(dt)
	Player.update(pl,dt)

	spawnClouds(dt)
	for i,v in ipairs(clouds) do
		Cloud.update(v,dt)
	end
end

function love.draw()
	love.graphics.scale(SCALE,SCALE)
	-- Draw railroad tracks
	love.graphics.setColor(0,0,0,255)
	love.graphics.line(0,92.5,WIDTH,92.5)
	love.graphics.line(0,94.5,WIDTH,94.5)

	-- Draw player
	love.graphics.setColor(255,255,255,255)
	Player.draw(pl)
	-- Draw clouds
	for i,v in ipairs(clouds) do
		Cloud.draw(v)
	end
end

function loadResources()
	imgSprites = love.graphics.newImage("gfx/sprites.png")
	imgSprites:setFilter("nearest","nearest")
end

function spawnClouds(dt)
	nextCloud = nextCloud - dt
	if nextCloud <= 0 then
		if math.random(4) == 1 then
			if math.random(2) == 1 then -- small cloud
				table.insert(clouds,Cloud.create(math.random(30),1,math.random(0,2)))
			else -- large cloud
				table.insert(clouds,Cloud.create(math.random(30),2,math.random(0,1)))
			end
		end
		nextCloud = CLOUD_SPAWN_RATE
	end
end
