vsp += global.world_grv;

hsp = approach(hsp, 0, acc);

rotation_spd = approach(rotation_spd, 0, slow_rotation_spd);

image_angle += rotation_spd * rotate_dir;

movement_collision();

fade_away_timer--;
if fade_away_timer <= 0 {
	image_alpha = lerp(image_alpha, 0, fade_spd);
	
	if image_alpha <= 0.03 {
		instance_destroy();
	}
}