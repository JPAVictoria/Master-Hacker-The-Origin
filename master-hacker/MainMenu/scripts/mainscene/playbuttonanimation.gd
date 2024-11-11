extends TextureButton


var wave_timer: float = 0.0  # Timer for the wave effect
var wave_frequency: float = 3.0  # Frequency of the wave
var wave_amplitude: float = 10.0  # Amplitude of the wave
var original_position: Vector2  # Store the original position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = position  # Save the original position when the scene is ready

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	wave_timer += delta
	# Calculate the wavy position based on a sine wave
	var offset_y = sin(wave_timer * wave_frequency) * wave_amplitude
	position.y = original_position.y + offset_y  # Adjust only the y position
