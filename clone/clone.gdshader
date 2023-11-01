shader_type canvas_item;

uniform vec4 color_override: source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
	tex_color.rgb = color_override.rgb;
	COLOR = tex_color;
}