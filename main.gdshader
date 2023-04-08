shader_type spatial;

void fragment() {
	float size = 20.0;
	vec2 pos = floor(UV * size);
	float mask = mod(pos.x + mod(pos.y, 2.0), 2.0);
	ALBEDO = vec3(0.0, 0.0, 0.0) + mask * vec3(0.0, 0.0, 0.5);
}
