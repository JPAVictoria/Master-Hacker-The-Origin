extends Node2D

@export var default_texture: Texture2D
@export var display_texture: Texture2D
@export var correct_texture: Texture2D
@export var wrong_texture: Texture2D
@export var lost_heart_texture: Texture2D
@export var heart_sound: AudioStream
@export var timer_label: Label
@export var game_won_scene: PackedScene

@export var progress_textures: Array[Texture2D]  # Should have 10 textures for 0% to 90%

@onready var pause_menu = $PauseMenu

var buttons: Array[TextureButton] = []
var countdown_label: Label
var hearts: Array[TextureRect] = []
var heart_count: int = 3

var pattern: Array[int] = []
var current_index: int = 0
var max_pattern_length: int = 4
var current_difficulty: int = 0
var levels_per_difficulty: int = 3
var total_levels: int = 10
var current_level: int = 0
var countdown_time: int = 15
var timer_running: bool = false
var is_paused: bool = false
var patterns_displayed: bool = false
var pattern_display_index: int = 0

func _ready() -> void:
	pause_menu.visible = false
	for i in range(1, 10):
		var button = $Monitor.get_node("Tile" + str(i)) as TextureButton
		buttons.append(button)
		button.pressed.connect(_on_button_pressed.bind(i - 1))

	countdown_label = $Monitor/Control/CountdownLabel
	timer_label = $Monitor/Countdown/TimerLabeL

	for i in range(heart_count):
		var heart = $Monitor.get_node("Heart" + str(i + 1)) as TextureRect
		hearts.append(heart)

	countdown_label.visible = false
	start_countdown()

func start_new_level() -> void:
	if current_level < total_levels:
		current_difficulty = current_level / levels_per_difficulty
		max_pattern_length = 4 + current_difficulty
		pattern.clear()
		current_index = 0
		timer_running = false  # Ensure timer doesn't run prematurely
		patterns_displayed = false  # Reset pattern display state

		# Adjust countdown time by difficulty
		match current_difficulty:
			0: countdown_time = 5
			1: countdown_time = 10
			2: countdown_time = 15
			3: countdown_time = 20

		var available_buttons = range(buttons.size())
		for s in range(max_pattern_length):
			var rand_index = randi() % available_buttons.size()
			pattern.append(available_buttons[rand_index])
			available_buttons.remove_at(rand_index)
		
		display_pattern()  # Start displaying the pattern
	else:
		AudioManager.stop_bgm()
		show_game_won()

func show_game_won() -> void:
	if is_instance_valid(get_tree()):
		get_tree().change_scene_to_file("res://Dialouge/DialougeScene/DialougeSceneWin.tscn")

func display_pattern() -> void:
	# Disable buttons while displaying the pattern
	for button in buttons:
		button.disabled = true
	pattern_display_index = 0
	display_pattern_step()

func display_pattern_step() -> void:
	if pattern_display_index >= pattern.size() or is_paused:
		if pattern_display_index >= pattern.size():
			patterns_displayed = true
			pattern_display_index = 0
			for button in buttons:
				button.disabled = false
			if not is_paused:
				start_timer()
		return

	var button = buttons[pattern[pattern_display_index]]
	button.texture_normal = display_texture

	await get_tree().create_timer(1).timeout
	if is_paused:
		return

	button.texture_normal = default_texture
	pattern_display_index += 1
	display_pattern_step()

func start_timer() -> void:
	if is_paused or not patterns_displayed:
		return

	timer_running = true
	timer_label.text = str(countdown_time).pad_zeros(2)

	await get_tree().create_timer(1.0).timeout
	while countdown_time > 0 and timer_running:
		countdown_time -= 1
		timer_label.text = str(countdown_time).pad_zeros(2)
		await get_tree().create_timer(1.0).timeout

	if countdown_time == 0:
		heart_loss_on_timeout()

func heart_loss_on_timeout() -> void:
	Heartloss.play_heart_loss_sound(heart_sound)
	update_hearts()
	reset_all_buttons()

	if heart_count > 0:
		start_new_level()
	else:
		show_game_over()

func _on_button_pressed(button_index: int) -> void:
	if button_index == pattern[current_index]:
		buttons[button_index].texture_normal = correct_texture
		current_index += 1

		if current_index == pattern.size():
			timer_running = false
			timer_label.text = "00" 
			current_level += 1
			update_progress_bar()
			await get_tree().create_timer(1.0).timeout
			reset_all_buttons()
			start_new_level()
	else:
		buttons[button_index].texture_normal = wrong_texture
		Heartloss.play_heart_loss_sound(heart_sound)
		update_hearts()

		if heart_count <= 0:
			show_game_over()

func update_progress_bar() -> void:
	var percentage_completed = int(float(current_level) / float(total_levels) * 100)
	var index = int(percentage_completed / 10)
	if index >= 0 and index < progress_textures.size():
		$Monitor/ProgressBar.texture = progress_textures[index]

func reset_all_buttons() -> void:
	for button in buttons:
		button.texture_normal = default_texture

func update_hearts() -> void:
	if heart_count > 0:
		heart_count -= 1
		hearts[heart_count].texture = lost_heart_texture

		if heart_count == 1:
			AudioManager.play_warning_bgm()
		if heart_count == 0:
			AudioManager.stop_bgm()
			play_lose_sound()
			show_game_over()

func play_lose_sound() -> void:
	AudioManager.play_lose_sound()

func show_game_over() -> void:
	if is_instance_valid(get_tree()):
		get_tree().change_scene_to_file("res://Dialouge/DialougeScene/DialougeSceneLose.tscn")

func start_countdown() -> void:
	#hide_all_elements_except_label()
	#countdown_label.visible = true
	#countdown_label.text = "READY"
	#await get_tree().create_timer(1.0).timeout
	#countdown_label.text = "SET"
	#await get_tree().create_timer(1.0).timeout
	#countdown_label.text = "GO"
	#await get_tree().create_timer(1.0).timeout

	countdown_label.visible = false
	show_all_elements_after_countdown()
	start_new_level()

func hide_all_elements_except_label() -> void:
	for button in buttons:
		button.visible = false

func show_all_elements_after_countdown() -> void:
	for button in buttons:
		button.visible = true

func _on_settings_button_pressed() -> void:
	get_tree().paused = true
	pause_menu.visible = true
	is_paused = true
	timer_running = false

func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false
	is_paused = false

	if patterns_displayed and countdown_time > 0 and not timer_running:
		start_timer()
	elif pattern_display_index < pattern.size():
		display_pattern_step()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainGame/progress_bar/testing.tscn")
	AudioManager.stop_bgm()
	AudioManager.play_default_bgm()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu/scenes/MainScene.tscn")
	AudioManager.stop_bgm()
	AudioManager.play_default_bgm()
