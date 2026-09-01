movement_init();

rotation_spd = irandom_range(8,15);
slow_rotation_spd = random_range(0.3,0.6);
rotate_dir = choose(-1,1);

friction = 0.3;

fade_spd = 0.05;
fade_away_timer = 4 * room_speed;

acc = random_range(0.25,0.6);