globalvar input_right, input_left, input_down, input_jump, input_interact, input_primary, input_secondary, input_primary_pressed, input_secondary_pressed, input_debug, input_pause, input_ui_up, input_ui_down;

function player_input() {
	input_right = keyboard_check(ord("D"));
	input_left = keyboard_check(ord("A"));
	input_down = keyboard_check(ord("S"));
	input_jump = keyboard_check_pressed(vk_space);
	input_interact = keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter);
	input_primary = mouse_check_button(mb_left);
	input_secondary = mouse_check_button(mb_right);
	input_primary_pressed = mouse_check_button_pressed(mb_left);
	input_secondary_pressed = mouse_check_button_pressed(mb_right);
	input_pause = keyboard_check_pressed(vk_escape);
	input_debug = keyboard_check_pressed(vk_f3);
	input_ui_up = keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up);
	input_ui_down = keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down);
}

function smooth_rotate(pointdir, rspeed, angle) {
	angle += sin(degtorad(pointdir - angle)) * rspeed;
	return angle;
}

function approach(start_val, end_val, shift_val) {
	if (start_val < end_val)
	    return min(start_val + shift_val, end_val); 
	else
	    return max(start_val - shift_val, end_val);
}

function movement_init() {
	hsp = 0;
	vsp = 0;
	hsp_carry = 0;
	vsp_carry = 0;
}

function movement_collision() {
	// First, push player OUT of walls if stuck inside
	if (place_meeting(x, y, obj_collide)) {
		var push_distance = 1;
		var pushed = false;
		
		// Try pushing right
		if (!place_meeting(x + push_distance, y, obj_collide)) {
			x += push_distance;
			pushed = true;
		}
		// Try pushing left
		else if (!place_meeting(x - push_distance, y, obj_collide)) {
			x -= push_distance;
			pushed = true;
		}
		// Try pushing down
		else if (!place_meeting(x, y + push_distance, obj_collide)) {
			y += push_distance;
			pushed = true;
		}
		// Try pushing up
		else if (!place_meeting(x, y - push_distance, obj_collide)) {
			y -= push_distance;
			pushed = true;
		}
	}
	
	var hsp_final = hsp + hsp_carry;
	var vsp_final = vsp + vsp_carry;
	
	// Horizontal collision
	if (hsp_final != 0 and place_meeting(x + hsp_final, y, obj_collide)) {
		repeat (abs(hsp_final) + 1) {
			if (place_meeting(x + sign(hsp_final), y, obj_collide))
				break;
			x += sign(hsp_final);
		}
		hsp = 0;
	} else {
		x += hsp_final;
	}

	// Vertical collision
	if (vsp_final != 0 and place_meeting(x, y + vsp_final, obj_collide)) {
		repeat (abs(vsp_final) + 1) {
			if (place_meeting(x, y + sign(vsp_final), obj_collide))
				break;
			y += sign(vsp_final);
		}
		vsp = 0;
	} else {
		y += vsp_final;
	}
}

function bullet_hitdust(count = 20, dust_offset = 4) {
	repeat(count) {
		instance_create_layer(
			x+irandom_range(-dust_offset, dust_offset),
			y+irandom_range(-dust_offset, dust_offset),
			"Effects",
			obj_dust);
	}
}

function screenshake(shakeAmount, rotateAmount, length) {
	with(instance_create_depth(x,y,-1,obj_screenshake)) {
		shakeIntensity = shakeAmount;
		rotationIntensity = rotateAmount;
		alarm[0] = length * room_speed;
	}
}

function afterimage_init() {
	frame = 0;
}

function afterimage_step(spacing, fadespeed, angle = image_angle, blend = image_blend, sprite = sprite_index) {
	frame++;
	if frame == spacing {
		frame = 0;
		var a = instance_create_layer(x,y,"Effects",obj_afterimage);
		a.sprite_index = sprite;
		a.image_xscale = image_xscale;
		a.image_yscale = image_yscale;
		a.image_angle = angle;
		a.image_blend = blend;
		//a.image_index = image_index;
		a.x = x;
		a.y = y;
		a.fadespeed = fadespeed;
	}
}

function launchpad_jump(dust_width) {
	hsp = lengthdir_x(other.jump_power, other.image_angle - 90);
	vsp = lengthdir_y(other.jump_power, other.image_angle - 90);

	for(var i = -dust_width; i < dust_width; i++) {
		var xoff = lengthdir_x(i, other.image_angle);
		var yoff = lengthdir_y(i, other.image_angle);
	
		instance_create_layer(other.x + xoff, other.y + yoff, "Instances", obj_dust);
	}
	
	with(other) {
		draw_x_set += lengthdir_x(jump_power * intensity, image_angle + 90);
		draw_y_set += lengthdir_y(jump_power * intensity, image_angle + 90);
	}
}

function move_off_object(spd) {
	var dir = point_direction(other.x,other.y,x,y);

	hsp = lengthdir_x(spd, dir);
	
	if x == other.x {
		x++;
	}
}
