extends Node2D

# ============================================================
# LEVEL 1
# ============================================================

var player_a_finished := false
var player_b_finished := false
var level_complete := false


func _ready() -> void:

	print("")
	print("==============================")
	print("       DOUBLE WORLDS")
	print("          LEVEL 1")
	print("==============================")


# ============================================================
# EXIT A
# ============================================================

func _on_exit_a_body_entered(body: Node2D) -> void:

	if body.name != "PlayerA":
		return

	if player_a_finished:
		return

	player_a_finished = true

	print("PLAYER A REACHED EXIT")

	check_level_complete()


# ============================================================
# EXIT B
# ============================================================

func _on_exit_b_body_entered(body: Node2D) -> void:

	if body.name != "PlayerB":
		return

	if player_b_finished:
		return

	player_b_finished = true

	print("PLAYER B REACHED EXIT")

	check_level_complete()


# ============================================================
# CHECK LEVEL COMPLETE
# ============================================================

func check_level_complete() -> void:

	if not player_a_finished or not player_b_finished:
		return

	if level_complete:
		return

	level_complete = true

	print("")
	print("==============================")
	print("       LEVEL 1 COMPLETE!")
	print("==============================")

	await get_tree().create_timer(1.5).timeout

	print("LOADING LEVEL 2...")

	get_tree().change_scene_to_file("res://scenes/level2.tscn")


# ============================================================
# HAZARD A
# ============================================================

func _on_hazard_a_body_entered(body: Node2D) -> void:

	if body.name != "PlayerA":
		return

	print("PLAYER A DIED")
	body.hurt_sound.play()
	body.shake_screen()

	await get_tree().create_timer(0.35).timeout

	get_tree().reload_current_scene()


func _on_hazard_b_body_entered(body: Node2D) -> void:

	if body.name != "PlayerB":
		return

	print("PLAYER B DIED")
	body.hurt_sound.play()
	body.shake_screen()
	

	await get_tree().create_timer(0.35).timeout

	get_tree().reload_current_scene()
