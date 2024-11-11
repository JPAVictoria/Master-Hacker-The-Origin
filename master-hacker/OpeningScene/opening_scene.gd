extends Node2D

# Declare variables for the VideoPlayer, Button, and AnimationPlayer nodes
@onready var video_player = $VideoStreamPlayer
@onready var button = $VideoStreamPlayer/SkipButton
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Start playing the video
	video_player.play()
	
	# Set the button's initial opacity to 0 (invisible)
	button.modulate.a = 0

	# Create a Timer to trigger the fade-in after 6 seconds
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 6  # Wait for 6 seconds
	timer.one_shot = true  # The timer will only run once
	timer.start()  # Start the timer

	# Connect the timer's timeout signal to a function that plays the fade-in animation
	timer.timeout.connect(_on_timer_timeout)

# Function to play the fade-in animation when the timer times out
func _on_timer_timeout():
	animation_player.play("fade_in")
