shader_type canvas_item;

uniform float speed;
uniform vec2 size;

void vertex() {
	if (VERTEX.x < 0.0) {
		VERTEX.y += cos(TIME * speed) * size.y / 4.0;
	}
}

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	COLOR = texture_color;
}
