if hp < max_hp {
	hp_draw = lerp(hp_draw, (hp / max_hp) * 100, 0.2);
	
	var h = sprite_get_height(sprite_index);
	
	draw_healthbar(
		x - 24, 
		y - h - hp_bar_y_ofs+2, 
		x + 24, 
		y - h - hp_bar_y_ofs - hp_bar_y_height-2,
		hp_draw, #781d36, #da284b, #da284b, 0, true, false);
}