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

on_ground = place_meeting(x, y + 1, obj_collide);

hsp = approach(hsp, input * spd, acc);
hsp += gunkickx;

vsp = ((vsp + global.world_grv) + gunkicky + vsp_carry) * !is_dashing;

hsp = clamp(hsp, -hsp_bounds, hsp_bounds);
vsp = clamp(vsp, -vsp_bounds, vsp_bounds);

gunkickx = 0;
gunkicky = 0;

hsp_carry = 0;
vsp_carry = 0;

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

// Removed rotation-based sprite_angle to keep player upright while running

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

var wall_left = place_meeting(x-1, y, obj_collide);
var wall_right = place_meeting(x+1, y, obj_collide);
var wall_contact = false;
var wall_direction;

wall_contact = wall_left || wall_right;

if (wall_left) {
    wall_direction = 1;
} else if (wall_right) {
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

// Block movement into walls ONLY when falling and not on ground
// Don't block when jumping (vsp < 0)
if !on_ground and vsp > 0 {
	if input < 0 and wall_left and hsp < 0 {
		hsp = 0;
	}
	if input > 0 and wall_right and hsp > 0 {
		hsp = 0;
	}
}

/// ANIMATION STATE (inserted by Copilot)
var target_sprite = anim_idle;

// airborne?
if !on_ground {
    // moving up = jump, moving down = fall
    if vsp < 0 {
        target_sprite = anim_jump;
    } else {
        target_sprite = anim_fall;
    }
} else {
    // on ground: running or idle
    if abs(hsp) > anim_hsp_threshold {
        target_sprite = anim_run;
    } else {
        target_sprite = anim_idle;
    }
}

// if the sprite changed, reset image_index so animation starts cleanly
if sprite_index != target_sprite {
    sprite_index = target_sprite;
    image_index = 0;
}

// set image_speed per animation
if sprite_index == anim_run {
    // scale run animation with speed so faster movement speeds up frames
    var run_speed = (abs(hsp) / max(spd_og, 0.0001)) * run_anim_speed;
    image_speed = clamp(run_speed, 0.5, 2);
} else if sprite_index == anim_idle {
    image_speed = idle_anim_speed;
} else {
    // jump/fall: use air_anim_speed (0 for static frame)
    image_speed = air_anim_speed;
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
