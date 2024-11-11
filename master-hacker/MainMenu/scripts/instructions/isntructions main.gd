extends Node2D

@export var day_image: Texture2D
@export var night_image: Texture2D

@onready var sprite: Sprite2D = $"ParallaxBackground/ParallaxLayer/BackgroundDynamic"
@onready var instruction_sprite: Sprite2D = $Instruction1
@onready var instruction_video_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var next_button = $AdvanceButton
@onready var previous_button = $PreviousButton

# Array to hold paths to instruction media (images and videos)
var instruction_media = []
var current_media_index = 0

func _ready():
	update_background()
	instruction_media.append(load("res://MainMenu/instructionsUI/Instructions1.png") as Texture2D)  # Image
	instruction_media.append(load("res://Instructionsss/2.ogv") as VideoStream)  # Video
	instruction_media.append(load("res://Instructionsss/3.ogv") as VideoStream)  # Video
	instruction_media.append(load("res://Instructionsss/4.ogv") as VideoStream)  # Video
	instruction_media.append(load("res://Instructionsss/5.ogv") as VideoStream)  # Video
	
	update_instruction_media()
	next_button.connect("pressed", Callable(self, "_on_advance_button_pressed"))
	previous_button.connect("pressed", Callable(self, "_on_previous_button_pressed"))

func update_instruction_media():
	var current_media = instruction_media[current_media_index]

	if current_media is Texture2D:
		instruction_sprite.texture = current_media
		instruction_sprite.visible = true
		instruction_video_player.visible = false
		instruction_video_player.stop()
	elif current_media is VideoStream:
		instruction_video_player.stream = current_media
		instruction_video_player.visible = true
		instruction_sprite.visible = false
		
		# Create and assign the shader material for chroma keying
		var shader = load("res://ChromaKey.gdshader")
		var shader_material = ShaderMaterial.new()
		shader_material.shader = shader
		shader_material.set_shader_parameter("key_color", Color(0.0, 0.698, 0.251))  # Match the color #00b140
		shader_material.set_shader_parameter("threshold", 0.1)  # Set the threshold
		
		instruction_video_player.material = shader_material
		instruction_video_player.play()

func _on_advance_button_pressed():
	if current_media_index < instruction_media.size() - 1:
		current_media_index += 1
		update_instruction_media()

func _on_previous_button_pressed():
	if current_media_index == 0:
		get_tree().change_scene_to_file("res://MainMenu/scenes/MainScene.tscn")
	else:
		current_media_index -= 1
		update_instruction_media()

func update_background():
	var current_time = Time.get_time_dict_from_system()
	var current_hour = current_time["hour"]
	
	if current_hour >= 6 and current_hour < 18:
		sprite.texture = day_image
	else:
		sprite.texture = night_image
