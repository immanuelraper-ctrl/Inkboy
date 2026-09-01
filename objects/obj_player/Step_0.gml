input = (input_right - input_left);

dash_length_timer--;
dash_afterimage_carryover_timer--;
dash_cooldown_timer--;

if dash_length_timer <= 0 and is_dashing {
	dash_cooldown_timer = dash_cooldown_timer_wait;
}

if dash_length_timer <= 0 {
	is_dashing = false;
}

if input != 0 {
	dash_dir = input;
}

if input_secondary_pressed and dash_length_timer <= 0 and dash_cooldown_timer <= 0 { 
	dash_length_timer = dash_length;
	
	is_dashing = true;
}

if is_dashing {
	input = dash_dir;
	spd = dash_spd;
	acc = 100;
	dash_afterimage_carryover_timer = dash_afterimage_carryover_timer_wait;
} else {
	spd = spd_og;
	acc = acc_og;
}

if is_dashing or dash_afterimage_carryover_timer > 0 {
	is_invincible = true;
	afterimage_step(afterimage_spacing, afterimage_fadespeed, sprite_angle, afterimage_blend);	
} else {
	is_invincible = false;
}

hsp = approach(hsp, input * spd, acc);
hsp += gunkickx;

vsp = ((vsp + global.world_grv) + gunkicky + vsp_carry) * !is_dashing;

hsp = clamp(hsp, -hsp_bounds, hsp_bounds);
vsp = clamp(vsp, -vsp_bounds, vsp_bounds);

gunkickx = 0;
gunkicky = 0;

hsp_carry = 0;
vsp_carry = 0;

on_ground = place_meeting(x, y + 1, obj_collide);

if hsp != 0 and input != 0 and !input_primary {
	facing = sign(hsp);
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

if on_ground {
	if !landed {
		xscale = 2.3;
		yscale = 0.35;
		landed = true;
	}
	
	current_jumps = 0;
	dust_carryover = dust_carryover_amount
} else {
	dust_carryover--;
	landed = false;
}

if current_jumps < max_jumps and input_jump and vsp > 0 {
	vsp = jump_power;
	current_jumps++;
	
	xscale = 0.4;
	yscale = 1.4;
	
	for(var i = -dust_jump_width/2; i < dust_jump_width/2; i++) {
		instance_create_layer(x+i,y,"Effects",obj_dust);
	}
}

var wall_contact = false;
var wall_direction;

wall_contact = place_meeting(x-1, y, obj_collide) || place_meeting(x+1, y, obj_collide);

if (place_meeting(x-1, y, obj_collide)) {
    wall_direction = 1;
} else if (place_meeting(x+1, y, obj_collide)) {
    wall_direction = -1;
}

if (wall_contact && input_jump && !on_ground) {
    vsp = wall_jump_power;
    hsp = wall_direction * wall_jump_hsp;

    /*for (var i = -dust_jump_width / 2; i < dust_jump_width / 2; i++) {
        instance_create_layer(x + i, y, "Effects", obj_dust);
    }*/
	
	bullet_hitdust(24,7);
}

movement_collision();

if flash {
	flash--;
}

xscale = lerp(xscale, 1, vfx_spd);
yscale = lerp(yscale, 1, vfx_spd);

var bounds = 16;
x = clamp(x, bounds, room_width - bounds);
y = clamp(y, bounds, room_height - bounds);