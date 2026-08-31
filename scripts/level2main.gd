extends Node2D


# ============================================================
# LEVEL 2
# DOUBLE WORLDS
# ============================================================

var player_a_finished := false
var player_b_finished := false
var level_complete := false
var switch_used := false


# ============================================================
# THE ONLY SPECIAL PLATFORM
# LOWER WORLD PLATFORM 4
# ============================================================

@onready var lower_platform4_collision: CollisionShape2D = $WorldB/platforms/platform4/CollisionShape2D


# ============================================================
# SWITCH
# ============================================================

@onready var switch_a: Area2D = $WorldA/SwitchA


# ============================================================
# READY
# ============================================================

func _ready() -> void:

	print("")
	print("==============================")
	print("       DOUBLE WORLDS")
	print("          LEVEL 2")
	print("==============================")

	# ONLY LOWER WORLD PLATFORM 4 starts disabled
	lower_platform4_collision.set_deferred("disabled", true)

	print("LOWER WORLD PLATFORM 4: DISABLED")


# ============================================================
# SWITCH
# PLAYER A ACTIVATES SWITCH
# ENABLES LOWER WORLD PLATFORM 4
# ============================================================

func _on_switch_a_body_entered(body: Node2D) -> void:

	print("SWITCH A BODY ENTERED: ", body.name)

	if body.name != "PlayerA":
		return

	if switch_used:
		return

	switch_used = true

	print("")
	print("PLAYER A ACTIVATED SWITCH A")

	# Enable ONLY the lower-world platform 4
	lower_platform4_collision.set_deferred("disabled", false)

	await get_tree().process_frame

	print("LOWER WORLD PLATFORM 4 ENABLED")
	print("DISABLED VALUE = ", lower_platform4_collision.disabled)

	# Remove the switch
	if is_instance_valid(switch_a):
		switch_a.queue_free()

	print("SWITCH A DISAPPEARED")


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

	if not player_a_finished:
		return

	if not player_b_finished:
		return

	if level_complete:
		return

	level_complete = true

	print("")
	print("==============================")
	print("       LEVEL 2 COMPLETE!")
	print("==============================")

	await get_tree().create_timer(2.0).timeout

	print("LOADING LEVEL 3...")

	get_tree().change_scene_to_file("res://scenes/level3.tscn")


# ============================================================
# HAZARD A
# ============================================================

# ============================================================
# HAZARD A
# ============================================================

func _on_hazard_a_body_entered(body: Node2D) -> void:

	if body.name != "PlayerA":
		return

	print("")
	print("PLAYER A DIED")
	body.hurt_sound.play()
	body.shake_screen()

	var tree := get_tree()

	await tree.create_timer(0.35).timeout

	tree.reload_current_scene()


# ============================================================
# HAZARD B
# ============================================================

func _on_hazard_b_body_entered(body: Node2D) -> void:

	if body.name != "PlayerB":
		return

	print("")
	print("PLAYER B DIED")

	body.hurt_sound.play()
	body.shake_screen()

	var tree := get_tree()

	await tree.create_timer(0.35).timeout

	tree.reload_current_scene()
