shader_type canvas_item;

uniform float vignette_intensity = 2.0;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.5;
uniform vec4 vignette_rgb : source_color = vec4(0.0, 0.0, 0.0, 1.0);

float vignette_mask(vec2 uv){
	vec2 centered = uv - 0.5;
	float dist = length(centered) * 2.0;
	return pow(clamp(dist, 0.0, 1.0), vignette_intensity);
}

void fragment(){
	vec4 base = COLOR;
	float mask = vignette_mask(UV) * vignette_opacity;
	COLOR = mix(base, vignette_rgb, mask);
}
