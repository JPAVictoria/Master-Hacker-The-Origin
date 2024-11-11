shader_type canvas_item;

uniform vec4 key_color : hint_color; // Correctly declare the uniform with a hint
uniform float threshold = 0.1; // Default threshold value

void fragment() {
    vec4 video_color = texture(TEXTURE, UV); // Sample the video texture
    float diff = distance(video_color.rgb, key_color.rgb); // Calculate the color difference

    if (diff < threshold) {
        discard; // Discard the fragment if it's close to the key color
    } else {
        COLOR = video_color; // Set the fragment color to the video color
    }
}
