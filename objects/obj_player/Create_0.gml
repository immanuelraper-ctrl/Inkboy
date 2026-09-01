movement_init()
acc = 0.7;
spd = 7;
jump_power = -9;
spd_og = spd;
acc_og = acc;
input = 1;

dash_spd = 20;
dash_length_timer = 0;
dash_dir = input;
is_dashing = false;
dash_afterimage_carryover_timer = 0;
dash_afterimage_carryover_timer_wait = 8;
dash_cooldown_timer = 0;
can_dash = true;

dash_cooldown_timer_wait = 45;
dash_length = 4;
max_jumps = 3;

is_invincible = false;

afterimage_init();

afterimage_spacing = 3;
afterimage_fadespeed = 0.05;
afterimage_blend = #c8c9d6;

gunkickx = 0;
gunkicky = 0;

hsp_bounds = 50;
vsp_bounds = 50;

on_ground = false;

current_jumps = 0;

sprite_angle = 0;
rotation_intensity = 1.4;
rotation_speed = 12;

dust_count = irandom_range(1,3);
dust_offset = 2;
dust_carryover = 0;
dust_carryover_amount = 2;
dust_jump_width = 24;

image_index = 0;

flash = 0;

is_dashing = false;

max_jumps = 2;

xscale = image_xscale;
yscale = image_yscale;

vfx_spd = 0.2;
landed = false;
facing = 1;

wall_jump_power = -9;
wall_jump_hsp = 14;

instance_create_layer(x,y,"Effects",obj_player_gun);

// Animation sprites (set these to your sprite asset names)
anim_idle = spr_player_idle;
anim_run  = spr_player_run;
anim_jump = spr_player_jump;
anim_fall = spr_player_fall;

// animation tuning
run_anim_speed = 1.5;        // multiplier for run animation speed
idle_anim_speed = 0.12;      // slow breathing idle
air_anim_speed = 0.0;        // 0 = static frame; set >0 if jump/fall are animated

anim_hsp_threshold = 0.25;   // how much horizontal speed is considered "running"

// track previous sprite so we can reset image_index on change
_prev_sprite_index = noone;
