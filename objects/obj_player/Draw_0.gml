if flash {
    gpu_set_fog(true,c_white,0,1);
    draw_sprite_ext(sprite_index, image_index, x, y, xscale * facing, yscale, sprite_angle, image_blend, image_alpha);
    gpu_set_fog(false,c_white,0,1);
} else {
    //draw sprite normally
    draw_sprite_ext(sprite_index, image_index, x, y, xscale * facing, yscale, sprite_angle, image_blend, image_alpha);
}
