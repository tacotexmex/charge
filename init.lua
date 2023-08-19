charge = {
	amount = {},
	sound = {},
}

local function cancel(player)
	local name = player:get_player_name()
	charge.amount[name] = 0
	if charge.sound[name] then
		minetest.sound_fade(charge.sound[name], 10, 0)
	end
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	charge.amount[name] = 0
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	charge.amount[name] = nil
end)

controls.register_on_press(function(player, control_name)
	if control_name == "sneak" then
		local name = player:get_player_name()
		local pos = player:get_pos()
		if charge.amount[name] == 0 then
			charge.amount[name] = 1
			charge.sound[name] = minetest.sound_play("charge", {
				pos = pos,
				gain = 0,
			})
			minetest.sound_fade(charge.sound[name], 0.25, 1)
		end
	end
end)

controls.register_on_hold(function(player, control_name, time)
	local name = player:get_player_name()
	if control_name == "sneak" then
		if charge.amount[name] > 0 then
			-- For some reason controls mod reports half-seconds!?
			charge.amount[name] = time * 2
		end
		minetest.chat_send_all(charge.amount[name])
		if charge.amount[name] > 3 then
			charge.amount[name] = 0
			minetest.sound_fade(charge.sound[name], 5, 0)
		end
	end
end)

controls.register_on_release(function(player, control_name, time)
	if control_name == "sneak" then
		cancel(player)
	end
end)

controls.register_on_hold(function(player, control_name)
	if
		control_name == "right"
		or control_name == "left"
		or control_name == "LMB"
		or control_name == "RMB"
		or control_name == "aux1"
		or control_name == "down"
		or control_name == "up"
		or control_name == "zoom"
		or control_name == "dig"
		or control_name == "place"
	then
		cancel(player)
	end
end)
