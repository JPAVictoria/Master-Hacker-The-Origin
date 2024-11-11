extends Sprite2D  # Attach this script to the Sprite2D node

var wave_timer = 0.0
var wave_frequency = 3.0  # Frequency of the wave
var wave_amplitude = 10.0  # Amplitude of the wave
var original_position: Vector2  # Store the original position

func _ready():
	original_position = position  # Save the original position when the scene is ready

func _process(delta):
	wave_timer += delta
	# Calculate the wavy position based on a sine wave
	var offset_y = sin(wave_timer * wave_frequency) * wave_amplitude
	position.y = original_position.y + offset_y  # Adjust only the y position
