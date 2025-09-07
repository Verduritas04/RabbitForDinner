shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE:hint_screen_texture, filter_nearest;
uniform float intensity = 0.5;

void fragment() {
	vec2 offset = vec2(intensity, 0.0) * SCREEN_PIXEL_SIZE;
	COLOR.r = texture(SCREEN_TEXTURE, SCREEN_UV - offset).r;
	COLOR.g = texture(SCREEN_TEXTURE, SCREEN_UV).g;
	COLOR.b = texture(SCREEN_TEXTURE, SCREEN_UV + offset).b;
}
