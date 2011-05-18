menu_difficulties = {"normal","hard","oh god!"}

enter_pressed = false

function updateMenu(dt)
	updateTerrain(dt)
	updateTracks(dt)
	if submenu == 0 then -- splash
		if enter_pressed == true then
			submenu = 2 -- Jumps straight to difficulty.
			enter_pressed = false
			auSelect:stop() auSelect:play()
		end
	elseif submenu == 1 then -- main menu

	elseif submenu == 2 then -- difficulty selection
		if enter_pressed == true then
			if selection == 0 then  -- normal
				START_SPEED = 1.5
				SPEED_INCREASE = 0.03
				MAX_SPEED = 2.25
			elseif selection == 1 then -- hard
				START_SPEED = 1.7
				SPEED_INCREASE = 0.04
				MAX_SPEED = 2.5
			else -- OH GOD
				START_SPEED = 2.25 
				SPEED_INCREASE = 0.06
				MAX_SPEED = 3.1
			end
			auSelect:stop() auSelect:play()
			gamestate = 0
			restart()
			enter_pressed = false
		end
	end
end

function drawMenu()
	drawTerrain()
	drawTracks()

	if submenu == 0 then
		love.graphics.draw(imgSplash,86,0)		
	elseif submenu == 1 then
	elseif submenu == 2 then
		love.graphics.printf("select difficulty",0,22,WIDTH,"center")
		if selection > 2 then selection = 0
		elseif selection < 0 then selection = 2 end

		for i = 0,2 do
			if i == selection then
				love.graphics.printf("·"..menu_difficulties[i+1].."·",0,42+i*13,WIDTH,"center")
			else
				love.graphics.printf(menu_difficulties[i+1],0,42+i*13,WIDTH,"center")
			end
		end
	end
end

function love.quit()
	print(exit_message)
end

exit_message = [[           _______________
          /               \
         |  Thank you for  | 
   .---. |  playing IYFCT  |
   |,__|  \  _____________/
   |o o|   |/
  _| O |_|
 | |\|/|
   |___|
   \/ \
       \ ]]
