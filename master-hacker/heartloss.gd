extends AudioStreamPlayer2D

func play_heart_loss_sound(sound: AudioStream) -> void:
	stream = sound  # Set the stream to play the sound
	play()           # Play the sound
