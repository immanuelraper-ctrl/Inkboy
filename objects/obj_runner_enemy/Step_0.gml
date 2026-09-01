event_inherited();

if !instance_exists(obj_player) exit;

image_xscale = obj_player.x > x ? 1 : -1;

var p = point_in_circle(obj_player.x,obj_player.y,x,y,stay_away_distance);
var c = collision_rectangle(x-48,y,x+48,y-64,obj_collide,false,true) != noone;

target_spd = p || c ? spd * -image_xscale : spd * image_xscale;

hsp = approach(hsp, target_spd, acc);
hsp += gunkickx;
vsp = (vsp + global.world_grv) + gunkicky;

gunkickx = 0;
gunkicky = 0;

if place_meeting(x+hsp,y,obj_collide) && place_meeting(x,y+1,obj_collide) {
	vsp = jump_power;
	hsp = jump_hsp * -image_xscale;
}

if on_ground {
	if !landed {
		xscale = 2.3;
		yscale = 0.35;
		landed = true;
	}
} else {
	landed = false;
}

movement_collision();
