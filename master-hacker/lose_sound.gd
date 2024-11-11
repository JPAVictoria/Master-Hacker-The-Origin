extends AudioStreamPlayer2D

func play_loss(sound: AudioStream) -> void:
	stream = sound  # Set the stream to play the sound
	play()           # Play the sound
