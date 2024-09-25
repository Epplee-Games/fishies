shader_type canvas_item;

uniform float amount;
uniform vec2 mesh_size;

void vertex() {
	// float speed = INSTANCE_CUSTOM.x;
	float speed = 2.0;

	// downscale the given mesh as it's very big.
	VERTEX *= 0.1;

	vec2 scaled_size = mesh_size * 0.1;
	float head_nearness = (VERTEX.x + scaled_size.x / 2.0) / scaled_size.x;
	float mask = smoothstep(0.0, 1.0, 1.0 - head_nearness);

	// move the whole fish side-to-side.
	VERTEX.y += cos(TIME * speed * 4.0) * 2.0 * amount;

	// rotate the fish around it's center a little bit.
	float pivot_angle = cos(TIME * speed * 4.0) * -0.1;
	mat2 rotation_matrix = mat2(vec2(cos(pivot_angle), -sin(pivot_angle)), vec2(sin(pivot_angle), cos(pivot_angle)));

	// Set the position to rotate around slightly right of the center of the mesh.
	vec2 centered_position = VERTEX - vec2(scaled_size.x * 0.2, scaled_size.y * 0.5);

	VERTEX.xy = centered_position * rotation_matrix;

	VERTEX.y += cos(INSTANCE_CUSTOM.y + TIME * speed * 4.0 + head_nearness) * amount * mask * 3.0;

	// for debugging
	// COLOR = vec4(mask, mask, mask, 1.0);
}

void fragment() {
	// for debugging
	// vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
	// COLOR = black;
}
