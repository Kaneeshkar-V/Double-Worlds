extends Node

var music_player: AudioStreamPlayer


func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

	music_player.stream = load("res://assets/audio/background.mp3")
	music_player.volume_db = -10.0
	music_player.play()
