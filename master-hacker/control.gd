extends Control

@onready var video_stream_player = $CanvasLayer/VideoStreamPlayer

func _ready():
	# Load the video stream
	video_stream_player.stream = preload("res://Instructionsss/2.ogv")
	video_stream_player.play()

	# Create the shader material
	var shader = load("res://ChromaKeyShader.shader")
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	
	# Set shader parameters using the correct method
	shader_material.set_shader_parameter("key_color", Color(0.0, 1.0, 0.0))  # Set the key color to green
	shader_material.set_shader_parameter("threshold", 0.1)  # Set the threshold

	# Assign the shader material to the VideoStreamPlayer
	video_stream_player.material = shader_material
