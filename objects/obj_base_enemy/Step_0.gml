if !instance_exists(obj_player) exit;

on_ground = place_meeting(x,y+1,obj_collide);

if on_ground {
	dust_carryover = dust_carryover_amount
} else {
	dust_carryover--;
}

if hsp != 0 and dust_carryover > 0 {
	repeat(dust_count) {
		instance_create_layer(
			x+irandom_range(-dust_offset, dust_offset),
			y+irandom_range(-dust_offset, dust_offset),
			"Effects",
			obj_dust);
	}
}

sprite_angle = smooth_rotate(hsp * rotation_intensity, rotation_speed, sprite_angle);

x = clamp(x, 32, room_width - 32);
y = clamp(y, 32, room_height - 32);

if flash {
	flash--;
}

xscale = lerp(xscale, 1, vfx_spd);
yscale = lerp(yscale, 1, vfx_spd);