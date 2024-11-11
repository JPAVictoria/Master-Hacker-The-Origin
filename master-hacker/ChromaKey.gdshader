shader_type canvas_item;

uniform vec4 key_color : source_color; // The color to be removed (chroma key)
uniform float threshold : hint_range(0.0, 1.0) = 0.1; // Adjustable threshold for color removal

void fragment() {
    vec4 texColor = texture(TEXTURE, UV);
    if (distance(texColor.rgb, key_color.rgb) < threshold) {
        discard; // Discard the specified key color
    }
    COLOR = texColor; // Output the color of the video
}
