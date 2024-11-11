extends Node2D

@export var day_image: Texture2D
@export var night_image: Texture2D

# Reference the Sprite2D node under ParallaxLayer
@onready var sprite: Sprite2D = $"ParallaxBackground/ParallaxLayer/Background"

@onready var a = $ClickSFX  # Adjust the path as necessary
@onready var dialougebg: TextureRect = $DialougeBG  # Adjust to your node name
@export var lose_sound: AudioStream  # Sound to play on wrong input

var daydialougebg = preload("res://Dialouge/dbackgroundday/14.png")
var nightdialougebg = preload("res://Dialouge/dbackgroundnight/13.png")

func _ready():
		get_tree().paused = false
		play_lose_sound()  # Call the method to play the sound
		update_background_and_titles()


func play_lose_sound() -> void:
	var audio_manager = get_node("/root/AudioManager")  # Assuming AudioManager is a singleton
	if audio_manager:
		audio_manager.play_lose_sound()  # Call the method in AudioManager
		print("Lose sound played")  # Debug print to confirm
		
# Function to update background texture and sprite textures based on the time of day
func update_background_and_titles():
	# Get the current system time dictionary
	var current_time = Time.get_time_dict_from_system()
	
	# Extract the current hour
	var current_hour = current_time["hour"]
	
	# Set the background texture based on the time of day
	if current_hour >= 6 and current_hour < 18:  # Day: from 6 AM to 6 PM
		sprite.texture = day_image
		dialougebg.texture = nightdialougebg
		
	else:  # Night: from 6 PM to 6 AM
		sprite.texture = night_image
		dialougebg.texture = daydialougebg


func _on_home_button_pressed() -> void:
	AudioManager.play_default_bgm()
	get_tree().change_scene_to_file("res://MainMenu/scenes/MainScene.tscn")


func _on_retry_button_pressed() -> void:
	AudioManager.play_default_bgm()
	get_tree().change_scene_to_file("res://MainGame/progress_bar/testing.tscn")
