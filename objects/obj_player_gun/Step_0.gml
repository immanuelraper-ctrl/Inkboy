if !instance_exists(obj_player) {
	instance_destroy();
	exit;
}

x = obj_player.x;
y = obj_player.y - 16;

var _dir = point_direction(x, y, mouse_x, mouse_y);
var _diff = angle_difference(_dir, image_angle);
image_angle += _diff * 0.3;

image_yscale = _dir > 90 && _dir < 270 ? -1 : 1;

firerate_timer--;

recoil_amount = max(0,recoil_amount - recoil_recharge_rate);
rotation_recoil_amount = max(0,rotation_recoil_amount - rotation_recoil_recharge_rate);
knockback_amount = max(0,knockback_amount - knockback_amount_recharge_rate);

bullet_angle_amount = global.num_of_bullets == 1 ? 0 : 15;

x -= lengthdir_x(recoil_amount,image_angle);
y -= lengthdir_y(recoil_amount,image_angle);

if obj_player.is_dashing {
	afterimage_step(obj_player.afterimage_spacing, obj_player.afterimage_fadespeed);
}

if input_primary and firerate_timer <= 0 and global.player_ammo > 0 and !place_meeting(x,y,obj_collide) {
	firerate_timer = global.firerate;
	
	recoil_amount = global.recoil;
	rotation_recoil_amount = global.rotation_recoil;
	knockback_amount = global.knockback;
	
	for(var ofs = -global.num_of_bullets / 2; ofs < global.num_of_bullets / 2; ofs ++) {
		global.player_ammo--;
		
		screenshake(3, 0.6, 0.1);
		
		var ofs_amount = ofs * bullet_angle_amount;
		var bloom = random_range(-global.bullet_bloom, global.bullet_bloom);
		
		var xpos = x + lengthdir_x(x_ofs, image_angle) - lengthdir_y(y_ofs, image_angle);
		var ypos = y + lengthdir_y(x_ofs, image_angle) + lengthdir_x(y_ofs, image_angle);
		
		var bullet = instance_create_layer(xpos, ypos, "Weapons", obj_player_bullet);
		
		with(bullet) {
			speed = global.bullet_speed;
			direction = other.image_angle + bloom + ofs_amount;
			image_angle = direction;
			damage = global.bullet_damage;
		}
		
		var flash = instance_create_layer(xpos, ypos, "Weapons", obj_muzzle_flash);
		
		with(flash) {
			direction = other.image_angle + bloom + ofs_amount;
			image_angle = direction;
		}
		
		var casing = instance_create_layer(x,y,"Instances",obj_shell_casing);
		
		with(casing) {
			var dir = other.image_angle + ((90 + irandom_range(-30, 0)) * other.image_yscale);
	
			var spd = 12;
			hsp = lengthdir_x(spd, dir);
			vsp = lengthdir_y(spd, dir);
		}
		
		with(obj_player) {
			gunkickx = lengthdir_x(other.knockback_amount,other.image_angle-180);
			gunkicky = lengthdir_y(other.knockback_amount,other.image_angle-180);
		}
	}
}
