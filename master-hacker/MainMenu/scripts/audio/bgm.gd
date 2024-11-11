extends Node2D

@onready var bgm_player = $BGMPlayer  # Ensure the path is correct

var current_bgm: AudioStreamPlayer2D

@export var lose_sound: AudioStream  # Assign this in the editor

@onready var lose_sound_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

func _ready() -> void:
	current_bgm = $BGMPlayer  # Assuming you have an AudioStreamPlayer node named BGMPlayer
	play_default_bgm()
	
	lose_sound_player.stream = lose_sound
	add_child(lose_sound_player)  # Ensure it's added to the scene tree
	
func play_lose_sound():
	lose_sound_player.play()  # Play the sound
	
func play_default_bgm():
	current_bgm.stream = preload("res://MainMenu/music/menubgm.mp3")
	current_bgm.play()

func play_warning_bgm():
	current_bgm.stream = preload("res://MainGame/sounds/chase.mp3")
	current_bgm.play()

func pause_bgm() -> void:
	if bgm_player.playing:
		bgm_player.pause()

func resume_bgm() -> void:
	if not bgm_player.playing:
		bgm_player.play()

func stop_bgm():
	current_bgm.stop()
	
func _process(_delta):
	position = get_global_mouse_position()
	if Input.is_action_just_pressed("Left_Mouse"):
		$CursorSound.play() 
