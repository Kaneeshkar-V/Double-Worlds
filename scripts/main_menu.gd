extends Control


@onready var play_button: Button = $PLAY
@onready var quit_button: Button = $QUIT


func _ready() -> void:
	print("MAIN MENU READY")

	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func _on_play_pressed() -> void:
	print("PLAY BUTTON PRESSED")

	var error := get_tree().change_scene_to_file(
		"res://scenes/level1.tscn"
	)

	if error != OK:
		print("ERROR LOADING LEVEL 1: ", error)


func _on_quit_pressed() -> void:
	print("QUIT BUTTON PRESSED")
	get_tree().quit()
