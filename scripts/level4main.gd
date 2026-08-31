extends Node2D


# ============================================================
# LEVEL 4 - FINAL LEVEL
# DOUBLE WORLDS
# ============================================================

var player_a_finished := false
var player_b_finished := false
var level_complete := false

var coin_a_used := false
var coin_b_used := false


# ============================================================
# PLATFORM COLLISIONS
# ============================================================

# World A Platform 4
@onready var platform4_a_collision: CollisionShape2D = $WorldA/platforms/platform4/CollisionShape2D

# World B Platform 4
@onready var platform4_b_collision: CollisionShape2D = $WorldB/platforms/platform4/CollisionShape2D


# ============================================================
# MAGIC COINS
# ============================================================

@onready var coin_a: Area2D = $WorldA/SwitchA
@onready var coin_b: Area2D = $WorldB/SwitchB


# ============================================================
# READY
# ============================================================

func _ready() -> void:

	print("")
	print("================================")
	print("         DOUBLE WORLDS")
	print("          FINAL LEVEL")
	print("            LEVEL 4")
	print("================================")

	# Both special platforms start disabled
	platform4_a_collision.set_deferred("disabled", true)
	platform4_b_collision.set_deferred("disabled", true)

	print("PLATFORM 4 A: DISABLED")
	print("PLATFORM 4 B: DISABLED")


# ============================================================
# MAGIC COIN A
#
# PLAYER A COLLECTS COIN A
#          ↓
# PLATFORM 4 B ENABLES
# ============================================================

func _on_switch_a_body_entered(body: Node2D) -> void:

	if body.name != "PlayerA":
		return

	if coin_a_used:
		return

	coin_a_used = true

	print("")
	print("PLAYER A COLLECTED MAGIC COIN A")

	# IMPORTANT:
	# Coin A controls the platform in WORLD B
	platform4_b_collision.set_deferred("disabled", false)

	await get_tree().process_frame

	print("PLATFORM 4 B ENABLED")
	print("PLATFORM 4 B DISABLED VALUE = ",
		platform4_b_collision.disabled
	)

	# Make Coin A disappear
	if is_instance_valid(coin_a):
		coin_a.queue_free()

	print("MAGIC COIN A DISAPPEARED")


# ============================================================
# MAGIC COIN B
#
# PLAYER B COLLECTS COIN B
#          ↓
# PLATFORM 4 A ENABLES
# ============================================================

func _on_switch_b_body_entered(body: Node2D) -> void:

	if body.name != "PlayerB":
		return

	if coin_b_used:
		return

	coin_b_used = true

	print("")
	print("PLAYER B COLLECTED MAGIC COIN B")

	# IMPORTANT:
	# Coin B controls the platform in WORLD A
	platform4_a_collision.set_deferred("disabled", false)

	await get_tree().process_frame

	print("PLATFORM 4 A ENABLED")
	print("PLATFORM 4 A DISABLED VALUE = ",
		platform4_a_collision.disabled
	)

	# Make Coin B disappear
	if is_instance_valid(coin_b):
		coin_b.queue_free()

	print("MAGIC COIN B DISAPPEARED")


# ============================================================
# EXIT A
# ============================================================

func _on_exit_a_body_entered(body: Node2D) -> void:

	if body.name != "PlayerA":
		return

	if player_a_finished:
		return

	player_a_finished = true

	print("")
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

	print("")
	print("PLAYER B REACHED EXIT")

	check_level_complete()


# ============================================================
# CHECK FINAL LEVEL
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
	print("================================")
	print("        LEVEL 4 COMPLETE!")
	print("================================")

	print("")
	print("       BOTH PLAYERS ESCAPED")

	print("")
	print("================================")
	print("         GAME COMPLETED!")
	print("================================")

	await get_tree().create_timer(2.0).timeout

	print("")
	print("================================")
	print("            YOU WIN!")
	print("================================")


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
