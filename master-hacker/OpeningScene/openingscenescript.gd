extends VideoStreamPlayer


func _ready() -> void:
	AudioManager.stop_bgm()

func _on_VideoPlayer_finished():
	AudioManager.play_default_bgm()
	get_tree().change_scene_to_file("res://MainMenu/scenes/MainScene.tscn")


func _on_skip_button_pressed() -> void:
	stop()  # Stop the video playback
	_go_to_main_menu()

# Transition to the main menu
func _go_to_main_menu():
	AudioManager.play_default_bgm()
	get_tree().change_scene_to_file("res://MainMenu/scenes/MainScene.tscn")
