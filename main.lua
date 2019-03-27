require "TEsound"
math.randomseed(os.time())

function toRadians(degrees)
	local radians = 0
	radians = degrees*(3.1415926/180)
	return -radians
end


function love.load()
	window_x = 800
	window_y = 600
	scale_sides = true
	
	consecutive_bounces = 0
	
	top_border_y = 22
	bottom_border_y = 590
	left_border_x = 10
	right_border_x = 790
	
	wtf_image_draw = false
	wtf_image_scale = 1
	wtf_zoom_in = true
	wtf_color_change_speed = 15
	wtf_color_switch = false
	wtf_red = 255
	wtf_blue = 0
	wtf_green = 0
	wtf_image_rotation = 0.0
	wtf_image_rotation_change = false
	
	
	you_suck_image_draw = false
	you_suck_image_scale = 0.0
	you_suck_zoom_in = true
	you_suck_image_rotation = 0.0
	you_suck_fade = 0
	you_suck_zoom_out = false
	you_suck_timer = false 
	
	
	volume_line = 685
	volume_line_y = 10
	
	paused_x = 350
	paused_y = 2
	different_wall_sound = 0
	
	scale_funny_counter = 0
	scale_funny_counter_max = 4
	scale_funny_start = false
	scale_x_axis = 1.0
	scale_y_axis = 1.0
	
	
	hit_image_scale_x = 0.0
	hit_image_scale_x = 0.0
	hit_image_counter = 0
	hit_image_counter_max = 100
	hit_image_rotation = 0.0
	hit_image_random = math.random(1,2)
	hit_image_draw = false
	
	stupid_mode = false
	random_red = math.random(1,255)
	random_blue = math.random(1,255)
	random_green = math.random(1,255)
	change_color_counter = 0
	change_color_counter_max = 5
	
	volume_slider = volume_line + 100
	volume_slider_radius = 6
	
	play_first = true
	top_border_limit = top_border_y
	bottom_border_limit = bottom_border_y
	left_border_limit = left_border_x
	right_border_limit = right_border_x
	
	scale_border_counter = 0
	scale_random_side = math.random(1,5)
	scale_previous_roll = 0
	scale_border_left = math.random((right_border_limit-left_border_limit)/4,(right_border_limit-left_border_limit)/2)
	scale_border_right = math.random((right_border_limit-left_border_limit)/4,(right_border_limit-left_border_limit)/2)
	scale_border_top = math.random((bottom_border_limit-top_border_limit)/4,(bottom_border_limit-top_border_limit)/2)
	scale_border_bottom = math.random((bottom_border_limit-top_border_limit)/4,(bottom_border_limit-top_border_limit)/2)
	scale_start = false
	
	scale_difficulty = 1.0
	scale_speed = 4 * scale_difficulty
	scale_change_speed = 100 / scale_difficulty

	-- set window and bg color
	love.graphics.setMode(window_x,window_y,false,true,4)
	love.graphics.setBackgroundColor(32,32,32)
	love.graphics.setCaption("Bounce")
	
	press_play_label = "Press the left mouse button to play"
	text_degree = 0
	text_scale = 1
	
	music = love.audio.newSource("Pixelpeeker2.mp3", "streaming")
	music:setLooping(true)
	love.audio.setVolume(1)
	
	
	
	
	bounce1 = love.audio.newSource("sounds/bounce1.wav","static")
	bounce2 = love.audio.newSource("sounds/bounce2.wav","static")
	bounce3 = love.audio.newSource("sounds/bounce3.wav","static")
	bounce4 = love.audio.newSource("sounds/bounce4.wav","static")
	bounce5 = love.audio.newSource("sounds/bounce5.wav","static")
	bounce6 = love.audio.newSource("sounds/bounce6.wav","static")
	bounce7 = love.audio.newSource("sounds/bounce7.wav","static")
	bounce8 = love.audio.newSource("sounds/bounce8.wav","static")
	bounce9 = love.audio.newSource("sounds/bounce9.wav","static")
	bounce10 = love.audio.newSource("sounds/bounce10.wav","static")
	miss = love.audio.newSource("sounds/miss.wav","static")
	miss2 = love.audio.newSource("sounds/humiliation.mp3","static")
	
	fire_image = love.graphics.newImage("fire.png")
	sick = love.graphics.newImage("sick.png")
	cool = love.graphics.newImage("cool.png")
	mega_awesome = love.graphics.newImage("mega_awesome.png")
	nice_hit_dude = love.graphics.newImage("nice_hit_dude.png")
	super_cool = love.graphics.newImage("super_cool.png")
	sweet = love.graphics.newImage("sweet.png")
	wtf = love.graphics.newImage("WTF.png")
	ball_image = love.graphics.newImage("ball.png")
	ball_x_velocity = math.random(130,200)
	ball_y_velocity = 250
	ball_x = ((right_border_x + left_border_x) / 2) - (ball_image:getWidth() / 2)
	ball_y = top_border_y + 5
	ball_inside_paddle = false
	
	stuck_inside_x = false
	stuck_inside_y = false
	stuck_inside_paddle = false
	
	miss = 0
	hits = 0
	pause = true
	auto_play = false

	paddle_image = love.graphics.newImage("paddle.png")
	paddle_x = ((right_border_x + left_border_x) / 2) - (paddle_image:getWidth()/2)
	paddle_y = bottom_border_y - (paddle_image:getHeight() + 5)

	ball_particles = love.graphics.newParticleSystem(fire_image, 100)
	ball_particles:setColors(255,15,0,0,255,150,0,125)
	ball_particles:setDirection(0)
	ball_particles:setEmissionRate(500)
	ball_particles:setLifetime(-1)
	ball_particles:setParticleLife(0.1,0.15)
	ball_particles:setPosition(ball_x+(ball_image:getWidth()/2),ball_y+(ball_image:getHeight()/2))
	--ball_particles:setRadialAcceleration(-400,0)
	ball_particles:setRotation(0,2*3.1415926)
	ball_particles:setSizes(1)
	ball_particles:setSpeed(1,2)
	ball_particles:setSpread(toRadians(105))
	ball_particles:setSizeVariation(1)
	ball_particles:start()
	

end

function love.update( dt )
	TEsound.cleanup()
	if love.mouse.getX() >= volume_line - 20 and love.mouse.getX() <= volume_line + 120 then
		if love.mouse.getY() >= volume_line_y - volume_slider_radius and love.mouse.getY() <= volume_line_y + volume_slider_radius  then
			if love.mouse.isDown("l") then
				volume_slider = love.mouse.getX()
				if volume_slider > volume_line + 100 then
					volume_slider = volume_line + 100
				end
				if volume_slider < volume_line then
					volume_slider = volume_line
				end
				love.audio.setVolume((volume_slider - volume_line) / 100)
			end
		end
	end
	
	
	if love.mouse.getX() > left_border_x and love.mouse.getX() < right_border_x and love.mouse.getY() < bottom_border_y and love.mouse.getY() > top_border_y then
			if love.mouse.isDown("l") then
				if pause == true then
					if stupid_mode == true then
						TEsound.resume("background")
					end
				end
				if play_first == true then
					if stupid_mode == true then
						TEsound.playLooping({"Pixelpeeker2.mp3", "sailpipe.mp3"}, "background")
					end
				end
				pause = false
				play_first = false
			end
			if love.mouse.isDown("r") then
				pause = true
				if stupid_mode == true then
					TEsound.pause("background")
				end
			end
	end
	
	
	
	if pause == false then
		
		if stupid_mode == true then
			--TEsound.tagVolume("all",5)
			change_color_counter = change_color_counter + 1
			
			
			if hit_image_draw == true then
				hit_image_counter = hit_image_counter + 1
				if hit_image_rotation < 360 then
					hit_image_rotation = hit_image_rotation + 0.2
				end
				hit_image_scale_x = hit_image_scale_x + 0.01
				hit_image_scale_y = hit_image_scale_y + 0.01
			end
			if hit_image_counter >= hit_image_counter_max then
				hit_image_counter = 0
				hit_image_draw = false
			end
			
			if wtf_image_draw == true then
				if wtf_image_rotation_change == false then
					wtf_image_rotation = wtf_image_rotation + 0.15
					if wtf_image_rotation >= 0.6 then
						wtf_image_rotation_change = true
					end
				end
				if wtf_image_rotation_change == true then
					wtf_image_rotation = wtf_image_rotation - 0.15
					if wtf_image_rotation <= -0.6 then
						wtf_image_rotation_change = false
					end
				end
				if wtf_zoom_in == true then
					wtf_image_scale = wtf_image_scale + 0.2
				end
				if wtf_image_scale >= 2 then
					wtf_zoom_in = false
				end
				
				if wtf_zoom_in == false then
					wtf_image_scale = wtf_image_scale - 0.2
				end
				if wtf_image_scale <= 1 then
					wtf_zoom_in = true
				end
				
				wtf_color_change_speed = wtf_color_change_speed + 1
				if wtf_color_change_speed >= 15 and wtf_color_switch == false then
					wtf_color_switch = true
					wtf_red = 255
					wtf_blue = 0
					wtf_green = 0
					wtf_color_change_speed = 0
				end
				if wtf_color_change_speed >= 15 and wtf_color_switch == true then
					wtf_color_switch = false
					wtf_red = 0
					wtf_blue = 0
					wtf_green = 0
					wtf_color_change_speed = 0
				end
				
			end
				
			
			if change_color_counter >= change_color_counter_max then
				random_red = math.random(1,255)
				random_blue = math.random(1,255)
				random_green = math.random(1,255)
				love.graphics.setBackgroundColor(random_red,random_blue,random_green)
				change_color_counter = 0
			end
			
		
		
		
		end
		
		
		ball_particles:setPosition(ball_x+(ball_image:getWidth()/2),ball_y+(ball_image:getHeight()/2))
		ball_particles:update(dt)
		
		if love.keyboard.isDown("a") then
			auto_play = true
		end
		if love.keyboard.isDown("s") then
			auto_play = false
		end
		if love.keyboard.isDown("m") then
			if stupid_mode == false then
				TEsound.playLooping({"Pixelpeeker2.mp3", "sailpipe.mp3"}, "background")
			end
			stupid_mode = true
		end
		if love.keyboard.isDown("n") then
			stupid_mode = false
			TEsound.pause("background")
			love.graphics.setBackgroundColor(32,32,32)
		end
		
		--scale sides counter when scaling is enabled
		if scale_sides == true then
			scale_border_counter = scale_border_counter + 1
			scale_speed = 4 * scale_difficulty
		end
		
		
		--vary the speed according to how long the ball has been in play and difficulty
		
		
		--choose a random wall to scale
		-- the  * ((((right_border_limit - left_border_limit) / 780) + ((bottom_border_limit - top_border_limit) / 570)) / 2) 
		-- is to make sure that the counter between scaling walls changes based upon how big the windows is. This makes it so
		-- if you have a huge window, the scaling counterwill change to give the game enough time to finish scaling the walls 
		-- (or at least more time) before retracting without actually speeding up the movement speed of the walls
		if scale_border_counter >= (scale_change_speed * ((((right_border_limit - left_border_limit) / 780) + ((bottom_border_limit - top_border_limit) / 570)) / 2)) / scale_difficulty then
			scale_random_side = math.random(1,5)
			if scale_random_side == 1 then
				scale_border_left = math.random((right_border_limit-left_border_limit)/4,(right_border_limit-left_border_limit)/2)
				--make sure the box doesn't get shorter than the paddle!
				if right_border_x - left_border_x - scale_border_left < paddle_image:getWidth() then
					scale_border_left = (paddle_image:getWidth() - (right_border_x - left_border_x)) * -1
				end
			end
			if scale_random_side == 2 then
				scale_border_right = math.random((right_border_limit-left_border_limit)/4,(right_border_limit-left_border_limit)/2)
				--make sure the box doesn't get shorter than the paddle
				if right_border_x - left_border_x - scale_border_right < paddle_image:getWidth() then
					scale_border_right = (paddle_image:getWidth() - (right_border_x - left_border_x)) * -1
				end
			end
			if scale_random_side == 3 then
				scale_border_top = math.random((bottom_border_limit-top_border_limit)/4,(bottom_border_limit-top_border_limit)/2)
				--make sure the box doesn't get shorter than the paddle height + the ball height + 40
				if bottom_border_y - top_border_y - scale_border_top < ball_image:getHeight() + paddle_image:getHeight() + 40 then
					scale_border_top = ((ball_image:getHeight() + paddle_image:getHeight() + 40) - (bottom_border_y - top_border_y)) * -1
				end
			end
			if scale_random_side == 4 then
				scale_border_bottom = math.random((bottom_border_limit-top_border_limit)/4,(bottom_border_limit-top_border_limit)/2)
				--make sure the box doesn't get shorter than the paddle height + the ball height + 40
				if bottom_border_y - top_border_y - scale_border_bottom < ball_image:getHeight() + paddle_image:getHeight() + 40 then
					scale_border_bottom = ((ball_image:getHeight() + paddle_image:getHeight() + 40) - (bottom_border_y - top_border_y)) * -1
				end
			end
			scale_border_counter = 0
			scale_start = true
		end
		
		
		--this is all just making sure the walls scale with a randomly chosen number for the wall
		if scale_start == true then
			if scale_random_side == 1 then
				if left_border_x < left_border_limit + scale_border_left then
					left_border_x = left_border_x + scale_speed
				end
				if right_border_x < right_border_limit then
					right_border_x = right_border_x + scale_speed
				end
				if top_border_y > top_border_limit then
					top_border_y = top_border_y - scale_speed
				end
				if bottom_border_y < bottom_border_limit then
					bottom_border_y = bottom_border_y + scale_speed
				end
			end	
			if scale_random_side == 2 then
				if left_border_x > left_border_limit then
					left_border_x = left_border_x - scale_speed
				end
				if right_border_x > right_border_limit - scale_border_right then
					right_border_x = right_border_x - scale_speed
				end
				if top_border_y > top_border_limit then
					top_border_y = top_border_y - scale_speed
				end
				if bottom_border_y < bottom_border_limit then
					bottom_border_y = bottom_border_y + scale_speed
				end
			end	
			if scale_random_side == 3 then
				if left_border_x > left_border_limit then
					left_border_x = left_border_x - scale_speed
				end
				if right_border_x < right_border_limit then
					right_border_x = right_border_x + scale_speed
				end
				if top_border_y < top_border_limit + scale_border_top then
					top_border_y = top_border_y + scale_speed
				end
				if bottom_border_y < bottom_border_limit then
					bottom_border_y = bottom_border_y + scale_speed
				end
			end	
			if scale_random_side == 4 then
				if left_border_x > left_border_limit then
					left_border_x = left_border_x - scale_speed
				end
				if right_border_x < right_border_limit then
					right_border_x = right_border_x + scale_speed
				end
				if top_border_y > top_border_limit then
					top_border_y = top_border_y - scale_speed
				end
				if bottom_border_y > bottom_border_limit - scale_border_bottom then
					bottom_border_y = bottom_border_y - scale_speed
				end
			end
			if scale_random_side == 5 then
				if left_border_x > left_border_limit then
					left_border_x = left_border_x - scale_speed
				end
				if right_border_x < right_border_limit then
					right_border_x = right_border_x + scale_speed
				end
				if top_border_y > top_border_limit then
					top_border_y = top_border_y - scale_speed
				end
				if bottom_border_y < bottom_border_limit then
					bottom_border_y = bottom_border_y + scale_speed
				end
			end
			if top_border_y < top_border_limit then
				top_border_y = top_border_limit
			end
			if bottom_border_y > bottom_border_limit then
				bottom_border_y = bottom_border_limit
			end
			if left_border_x < left_border_limit then
				left_border_x = left_border_limit
			end
			if right_border_x > right_border_limit then
				right_border_x = right_border_limit
			end
			
		end
		
		--move paddle here after the border movement has been done so the paddle is always with the border
		if auto_play == false then
			paddle_x = love.mouse.getX()-(paddle_image:getWidth()/2)
		end
		if auto_play == true then
			paddle_x = (ball_x + ball_image:getWidth()/2) - (paddle_image:getWidth()/2)
		end
		paddle_y = bottom_border_y - (paddle_image:getHeight() + 5)
		
		--limit paddle movement
		if paddle_x < left_border_x then
			paddle_x = left_border_x
		elseif paddle_x + paddle_image:getWidth() > (right_border_x) then
			paddle_x = (right_border_x) - paddle_image:getWidth()
		end
		
		
		
		--move ball
		ball_x = ball_x + (ball_x_velocity * dt)
		ball_y = ball_y + (ball_y_velocity * dt)
		
		--make sure the ball isn't touching the paddle in the preceding frame before we add a hit
		if ball_x+ball_image:getWidth() >= paddle_x and ball_x < paddle_x + paddle_image:getWidth() then
			if ball_y + ball_image:getHeight() < paddle_y then
				ball_inside_paddle = false
			end
		end
		
		--check collision with paddle
		if ball_x+ball_image:getWidth() >= paddle_x and ball_x < paddle_x + paddle_image:getWidth() then
			if ball_y + ball_image:getHeight() >= paddle_y then
				ball_y = paddle_y - ball_image:getHeight()
				ball_y_velocity = (ball_y_velocity * -1)
				ball_x_velocity = ball_x_velocity + math.random(-80,80)
				if ball_inside_paddle == false then
					hits = hits + 1
					consecutive_bounces = consecutive_bounces + 1
					if stupid_mode == true then
						if consecutive_bounces == 5 then
							TEsound.play("sounds/impressive.mp3")
						end
						if consecutive_bounces == 10 then
							TEsound.play("sounds/combowhore.mp3")
						end
						if consecutive_bounces == 15 then
							TEsound.play("sounds/dominating.mp3")
						end
						if consecutive_bounces == 20 then
							TEsound.play("sounds/wickedsick.mp3")
						end
						if consecutive_bounces == 25 then
							TEsound.play("sounds/unstoppable.mp3")
						end
						if consecutive_bounces == 30 then
							TEsound.play("sounds/rampage.mp3")
						end
						if consecutive_bounces == 35 then
							TEsound.play("sounds/godlike.mp3")
						end
						if consecutive_bounces < 40 then
							wtf_image_draw = false
						end
						if consecutive_bounces >= 40 then
							TEsound.play("sounds/holyshit.mp3")
							wtf_image_draw = true
						end
					end
					if stupid_mode == true then
						TEsound.play({"sounds/bounce.wav", "sounds/bounce1.wav", "sounds/bounce2.wav", 
						"sounds/bounce3.wav", "sounds/bounce4.wav", "sounds/bounce5.wav", "sounds/bounce6.wav", 
						"sounds/bounce7.wav", "sounds/bounce8.wav", "sounds/bounce9.wav", "sounds/bounce10.wav"})
						hit_image_random = math.random(1,6)
						hit_image_draw = true
						hit_image_counter = 0
						hit_image_rotation = 0
						hit_image_scale_x = 0.0
						hit_image_scale_y = 0.0
						different_wall_sound = 1
						
					end
					if stupid_mode == false then
						TEsound.play("sounds/bounce.wav")
						different_wall_sound = 1
					end
					ball_x_velocity = ball_x_velocity * (1.05)
					ball_y_velocity = ball_y_velocity * (1.05)
					scale_difficulty = scale_difficulty + 0.05
				end
				ball_inside_paddle = true
			end
		end
		
		--check collision with side walls
		if ball_x < left_border_x then
			if stupid_mode == true then
				if different_wall_sound ~= 2 then
					TEsound.play({"sounds/bounce.wav", "sounds/bounce1.wav", "sounds/bounce2.wav", 
					"sounds/bounce3.wav", "sounds/bounce4.wav", "sounds/bounce5.wav", "sounds/bounce6.wav", 
					"sounds/bounce7.wav", "sounds/bounce8.wav", "sounds/bounce9.wav", "sounds/bounce10.wav"})
					different_wall_sound = 2
				end
			end
			if stupid_mode == false then
				if different_wall_sound ~= 2 then
					TEsound.play("sounds/bounce.wav")
					different_wall_sound = 2
				end
			end
			if stuck_inside_x == false then
				ball_x_velocity = (ball_x_velocity * -1)
				ball_x = (left_border_x + 1)
			end
		end
		if ball_x + (ball_image:getWidth()) > (right_border_x) then
			if stupid_mode == true then
				if different_wall_sound ~= 3 then
					TEsound.play({"sounds/bounce.wav", "sounds/bounce1.wav", "sounds/bounce2.wav", 
					"sounds/bounce3.wav", "sounds/bounce4.wav", "sounds/bounce5.wav", "sounds/bounce6.wav", 
					"sounds/bounce7.wav", "sounds/bounce8.wav", "sounds/bounce9.wav", "sounds/bounce10.wav"})
					different_wall_sound = 3
				end
			end
			if stupid_mode == false then
				if different_wall_sound ~= 3 then
					TEsound.play("sounds/bounce.wav")
					different_wall_sound = 3
				end
			end
			if stuck_inside_x == false then
				ball_x_velocity = (ball_x_velocity * -1)
				ball_x = (right_border_x - 1) - ball_image:getWidth()
			end
		end
		
		--check collision with top wall
		if ball_y < top_border_y then
			if stupid_mode == true then
				if different_wall_sound ~= 4 then
					TEsound.play({"sounds/bounce.wav", "sounds/bounce1.wav", "sounds/bounce2.wav", 
					"sounds/bounce3.wav", "sounds/bounce4.wav", "sounds/bounce5.wav", "sounds/bounce6.wav", 
					"sounds/bounce7.wav", "sounds/bounce8.wav", "sounds/bounce9.wav", "sounds/bounce10.wav"})
					different_wall_sound = 4
				end
			end
			if stupid_mode == false then
				if different_wall_sound ~= 4 then
					TEsound.play("sounds/bounce.wav")
					different_wall_sound = 4
				end
			end
			if stuck_inside_y == false then
				ball_y_velocity = (ball_y_velocity * -1)
				ball_y = top_border_y + 1
			end
		end
		
		
		--check to see if it goes below the paddle and reset position if it does
		if ball_y+ball_image:getHeight() > (bottom_border_y - 1) then
			if stupid_mode == true then
				if consecutive_bounces < 10 then
					TEsound.play("sounds/humiliation.mp3")
				end
				if consecutive_bounces >= 10 then
					TEsound.play("sounds/miss.wav")
				end
			end
			if stupid_mode == false then
				TEsound.play("sounds/miss.wav")
			end
			ball_x_velocity = math.random(130,200)
			ball_y_velocity = 250
			ball_x = ((right_border_x + left_border_x) / 2) - (ball_image:getWidth() / 2)
			ball_y = top_border_y + 5
			ball_speed = 0
			scale_difficulty = 1.0
			miss = miss + 1
			consecutive_bounces = 0
		end
		

	end
	
	
end

function love.draw()

		
	love.graphics.draw(ball_particles)
	love.graphics.draw(ball_image, ball_x, ball_y)
	love.graphics.draw(paddle_image, paddle_x, paddle_y)
	
	if stupid_mode == true then
		if hit_image_random == 1 and hit_image_draw == true then
			love.graphics.draw(cool, 400, 100,hit_image_rotation, hit_image_scale_x, hit_image_scale_y, cool:getWidth()/2, cool:getHeight()/2)
		end
		if hit_image_random == 2 and hit_image_draw == true then
			love.graphics.draw(sick, 400, 100,hit_image_rotation, hit_image_scale_x, hit_image_scale_y, cool:getWidth()/2, cool:getHeight()/2)
		end
		if hit_image_random == 3 and hit_image_draw == true then
			love.graphics.draw(mega_awesome, 400, 100,hit_image_rotation, hit_image_scale_x, hit_image_scale_y, mega_awesome:getWidth()/2, mega_awesome:getHeight()/2)
		end
		if hit_image_random == 4 and hit_image_draw == true then
			love.graphics.draw(nice_hit_dude, 400, 100,hit_image_rotation, hit_image_scale_x, hit_image_scale_y, nice_hit_dude:getWidth()/2, nice_hit_dude:getHeight()/2)
		end
		if hit_image_random == 5 and hit_image_draw == true then
			love.graphics.draw(super_cool, 400, 100,hit_image_rotation, hit_image_scale_x, hit_image_scale_y, super_cool:getWidth()/2, super_cool:getHeight()/2)
		end
		if hit_image_random == 6 and hit_image_draw == true then
			love.graphics.draw(sweet, 400, 100,hit_image_rotation, hit_image_scale_x, hit_image_scale_y, sweet:getWidth()/2, sweet:getHeight()/2)
		end
		
		if wtf_image_draw == true then
			love.graphics.draw(wtf, 200, 400,wtf_image_rotation, wtf_image_scale, wtf_image_scale, wtf:getWidth()/2, wtf:getHeight()/2)
			love.graphics.draw(wtf, 600, 400,wtf_image_rotation, wtf_image_scale, wtf_image_scale, wtf:getWidth()/2, wtf:getHeight()/2)
		end
	end
	
	love.graphics.line(volume_line,volume_line_y,volume_line+100,volume_line_y)
	love.graphics.print("Volume: " .. (volume_slider - volume_line) .. "%", volume_line - 100,volume_line_y - 8)
	love.graphics.circle("fill", volume_slider, volume_line_y, volume_slider_radius, volume_line_y)
	
	love.graphics.rectangle("line",left_border_x,top_border_y,right_border_x - left_border_x,bottom_border_y - top_border_y)
	love.graphics.print("Hits: " .. hits .. "      Misses: " .. miss .. "       Consecutive Bounces: " .. consecutive_bounces,10, 5)
	
	--love.graphics.print(scale_border_counter,left_border_x, top_border_y + 20)
	if play_first == true then
		love.graphics.setNewFont(32)
		love.graphics.print(press_play_label, (((right_border_x + left_border_x) / 2) - 290),((top_border_y + bottom_border_y) / 2) - 100)
		love.graphics.setNewFont(12)
	end
	
	if pause == true then
		love.graphics.print("Game Paused", paused_x, paused_y)
		love.graphics.setCaption("Christarp's pong (GAME PAUSED)")
	end
	if pause == false then
		love.graphics.setCaption("Christarp's pong")
	end
	
	
end