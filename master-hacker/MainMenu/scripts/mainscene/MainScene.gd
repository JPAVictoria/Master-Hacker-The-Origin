extends Node2D

@export var day_image: Texture2D
@export var night_image: Texture2D

# Reference the Sprite2D node under ParallaxLayer
@onready var sprite: Sprite2D = $"ParallaxBackground/ParallaxLayer/Background"

@onready var main_title_sprite = $MainTitle
@onready var subtitle_sprite = $SubTitle
@onready var a = $ClickSFX  # Adjust the path as necessary

# Preload the textures for day and night
var day_main_title_texture = preload("res://MainMenu/Title/1.png")
var night_main_title_texture = preload("res://MainMenu/Title/3.png")
var day_subtitle_texture = preload("res://MainMenu/Title/2.png")
var night_subtitle_texture = preload("res://MainMenu/Title/4.png")

func _ready():
	# Print the nodes to check their paths
	print(main_title_sprite)
	print(subtitle_sprite)
	print(sprite)
	
	# Call the function to update the background and titles based on the current time
	update_background_and_titles()

# Function to update background texture and sprite textures based on the time of day
func update_background_and_titles():
	# Get the current system time dictionary
	var current_time = Time.get_time_dict_from_system()
	
	# Extract the current hour
	var current_hour = current_time["hour"]
	
	# Set the background texture based on the time of day
	if current_hour >= 6 and current_hour < 18:  # Day: from 6 AM to 6 PM
		sprite.texture = day_image
		main_title_sprite.texture = day_main_title_texture
		subtitle_sprite.texture = day_subtitle_texture
	else:  # Night: from 6 PM to 6 AM
		sprite.texture = night_image
		main_title_sprite.texture = night_main_title_texture
		subtitle_sprite.texture = night_subtitle_texture

func _on_instruction_button_night_pressed():
	
	get_tree().change_scene_to_file("res://MainMenu/scenes/Instructions.tscn")
	a.play()
	
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://MainGame/progress_bar/testing.tscn")
	a.play()
