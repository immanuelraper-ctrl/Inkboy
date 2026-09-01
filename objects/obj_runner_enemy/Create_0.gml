// Inherit the parent event
event_inherited();

stay_away_distance = irandom_range(256,512);

spd = random_range(3.5,5);

xscale = image_xscale;
yscale = image_yscale;

vfx_spd = 0.2;
landed = false;
facing = 1;

//instance_create_layer(x,y,"Instances",obj_enemy_axe);