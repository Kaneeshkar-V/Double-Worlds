extends Node2D


# ============================================================
# LEVEL 3
# DOUBLE WORLDS
# ============================================================

var player_a_finished := false
var player_b_finished := false
var level_complete := false

var switch_a_used := false
var switch_b_used := false


# ============================================================
# NODE REFERENCES
# ============================================================

var platform4_a_collision: CollisionShape2D = null
var platform4_b_collision: CollisionShape2D = null

var switch_a: Area2D = null
var switch_b: Area2D = null

var exit_a: Area2D = null
var exit_b: Area2D = null

var hazard_a: Area2D = null
var hazard_b: Area2D = null


# ============================================================
# READY
# ============================================================

func _ready() -> void:

	print("")
	print("================================")
	print("          DOUBLE WORLDS")
	print("             LEVEL 3")
	print("================================")


	# ========================================================
	# FIND PLATFORM 4 COLLISIONS
	# ========================================================

	platform4_a_collision = find_collision_by_path_keywords(
		["WorldA", "platforms", "platform4"]
	)

	platform4_b_collision = find_collision_by_path_keywords(
		["WorldB", "platforms", "platform4"]
	)


	# ========================================================
	# FIND SWITCHES
	# ========================================================

	switch_a = find_area_by_names(
		["SwitchA", "switch_a"]
	)

	switch_b = find_area_by_names(
		["SwitchB", "switch_b"]
	)


	# ========================================================
	# FIND EXITS
	# ========================================================

	exit_a = find_area_by_names(
		["ExitA", "exit_a"]
	)

	exit_b = find_area_by_names(
		["ExitB", "exit_b"]
	)


	# ========================================================
	# FIND HAZARDS
	# ========================================================

	hazard_a = find_area_by_names(
		["HazardA", "hazard_a"]
	)

	hazard_b = find_area_by_names(
		["HazardB", "hazard_b"]
	)


	# ========================================================
	# PRINT NODE CHECK
	# ========================================================

	print("")
	print("LEVEL 3 NODE CHECK")
	print("------------------------------")

	print("Platform 4 A: ", platform4_a_collision)
	print("Platform 4 B: ", platform4_b_collision)

	print("Switch A: ", switch_a)
	print("Switch B: ", switch_b)

	print("Exit A: ", exit_a)
	print("Exit B: ", exit_b)

	print("Hazard A: ", hazard_a)
	print("Hazard B: ", hazard_b)

	print("------------------------------")


	# ========================================================
	# CHECK REQUIRED PLATFORMS
	# ========================================================

	if platform4_a_collision == null:
		print("ERROR: PLATFORM 4 A NOT FOUND!")

	if platform4_b_collision == null:
		print("ERROR: PLATFORM 4 B NOT FOUND!")


	# ========================================================
	# DISABLE BOTH SPECIAL PLATFORMS
	# ========================================================

	if platform4_a_collision != null:
		platform4_a_collision.set_deferred(
			"disabled",
			true
		)

	if platform4_b_collision != null:
		platform4_b_collision.set_deferred(
			"disabled",
			true
		)

	print("PLATFORM 4 A: DISABLED")
	print("PLATFORM 4 B: DISABLED")


	# ========================================================
	# CONNECT SWITCHES
	# ========================================================

	connect_area_signal(
		switch_a,
		"body_entered",
		Callable(self, "_on_switch_a_body_entered")
	)

	connect_area_signal(
		switch_b,
		"body_entered",
		Callable(self, "_on_switch_b_body_entered")
	)


	# ========================================================
	# CONNECT EXITS
	# ========================================================

	connect_area_signal(
		exit_a,
		"body_entered",
		Callable(self, "_on_exit_a_body_entered")
	)

	connect_area_signal(
		exit_b,
		"body_entered",
		Callable(self, "_on_exit_b_body_entered")
	)


	# ========================================================
	# CONNECT HAZARDS
	# ========================================================

	connect_area_signal(
		hazard_a,
		"body_entered",
		Callable(self, "_on_hazard_a_body_entered")
	)

	connect_area_signal(
		hazard_b,
		"body_entered",
		Callable(self, "_on_hazard_b_body_entered")
	)


	print("")
	print("LEVEL 3 READY")
	print("")


# ============================================================
# FIND AREA2D BY NAME
# ============================================================

func find_area_by_names(names: Array[String]) -> Area2D:

	var result := find_node_recursive(self, names)

	if result is Area2D:
		return result as Area2D

	return null


# ============================================================
# RECURSIVE NODE SEARCH
# ============================================================

func find_node_recursive(
	node: Node,
	names: Array[String]
) -> Node:

	if node.name in names:
		return node

	for child in node.get_children():

		var result := find_node_recursive(
			child,
			names
		)

		if result != null:
			return result

	return null


# ============================================================
# FIND PLATFORM COLLISION
# ============================================================

func find_collision_by_path_keywords(
	keywords: Array[String]
) -> CollisionShape2D:

	var result := find_collision_recursive(
		self,
		keywords
	)

	if result is CollisionShape2D:
		return result as CollisionShape2D

	return null


# ============================================================
# RECURSIVE PLATFORM SEARCH
# ============================================================

func find_collision_recursive(
	node: Node,
	keywords: Array[String]
) -> CollisionShape2D:

	# We specifically look for:
	# WorldA/WorldB
	# platforms
	# platform4
	# CollisionShape2D

	if node is CollisionShape2D:

		var parent := node.get_parent()

		if parent != null and parent.name == "platform4":

			var platforms_node := parent.get_parent()

			if platforms_node != null and platforms_node.name == "platforms":

				var world_node := platforms_node.get_parent()

				if world_node != null and world_node.name in ["WorldA", "WorldB"]:

					if world_node.name == keywords[0]:

						return node as CollisionShape2D


	for child in node.get_children():

		var result := find_collision_recursive(
			child,
			keywords
		)

		if result != null:
			return result

	return null


# ============================================================
# CONNECT SIGNAL SAFELY
# ============================================================

func connect_area_signal(
	area: Area2D,
	signal_name: StringName,
	callable: Callable
) -> void:

	if area == null:
		print(
			"WARNING: Could not connect ",
			signal_name,
			" because Area2D was not found."
		)
		return

	if not area.has_signal(signal_name):
		print(
			"WARNING: ",
			area.name,
			" has no signal ",
			signal_name
		)
		return

	if not area.is_connected(signal_name, callable):
		area.connect(signal_name, callable)

	print(
		"CONNECTED: ",
		area.name,
		" -> ",
		signal_name
	)


# ============================================================
# SWITCH A
# PLAYER A -> PLATFORM 4 A
# ============================================================

func _on_switch_a_body_entered(body: Node2D) -> void:

	print("SWITCH A SIGNAL FIRED: ", body.name)

	if body.name != "PlayerA":
		return

	if switch_a_used:
		return

	switch_a_used = true

	print("")
	print("PLAYER A ACTIVATED SWITCH A")


	# Enable Platform 4 A

	if platform4_a_collision != null:

		platform4_a_collision.set_deferred(
			"disabled",
			false
		)

		await get_tree().process_frame

		print("PLATFORM 4 A ENABLED")
		print(
			"PLATFORM 4 A DISABLED = ",
			platform4_a_collision.disabled
		)

	else:

		print("ERROR: PLATFORM 4 A IS NULL!")


	# ========================================================
	# REMOVE SWITCH A
	# ========================================================

	if is_instance_valid(switch_a):

		switch_a.visible = false

		switch_a.set_deferred(
			"monitoring",
			false
		)

		switch_a.set_deferred(
			"monitorable",
			false
		)

		print("SWITCH A DISAPPEARED")

	else:

		print("ERROR: SWITCH A IS INVALID")


# ============================================================
# SWITCH B
# PLAYER B -> PLATFORM 4 B
# ============================================================

func _on_switch_b_body_entered(body: Node2D) -> void:

	print("SWITCH B SIGNAL FIRED: ", body.name)

	if body.name != "PlayerB":
		return

	if switch_b_used:
		return

	switch_b_used = true

	print("")
	print("PLAYER B ACTIVATED SWITCH B")


	# Enable Platform 4 B

	if platform4_b_collision != null:

		platform4_b_collision.set_deferred(
			"disabled",
			false
		)

		await get_tree().process_frame

		print("PLATFORM 4 B ENABLED")
		print(
			"PLATFORM 4 B DISABLED = ",
			platform4_b_collision.disabled
		)

	else:

		print("ERROR: PLATFORM 4 B IS NULL!")


	# ========================================================
	# REMOVE SWITCH B
	# ========================================================

	if is_instance_valid(switch_b):

		switch_b.visible = false

		switch_b.set_deferred(
			"monitoring",
			false
		)

		switch_b.set_deferred(
			"monitorable",
			false
		)

		print("SWITCH B DISAPPEARED")

	else:

		print("ERROR: SWITCH B IS INVALID")


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
# CHECK LEVEL COMPLETE
# ============================================================

func check_level_complete() -> void:

	print(
		"EXIT STATUS -> A: ",
		player_a_finished,
		" | B: ",
		player_b_finished
	)

	if not player_a_finished:
		return

	if not player_b_finished:
		return

	if level_complete:
		return

	level_complete = true

	print("")
	print("================================")
	print("       LEVEL 3 COMPLETE!")
	print("================================")

	print("")
	print("BOTH PLAYERS ESCAPED")

	await get_tree().create_timer(2.0).timeout

	print("LOADING LEVEL 4...")

	var error := get_tree().change_scene_to_file(
		"res://scenes/level4.tscn"
	)

	if error != OK:
		print("ERROR LOADING LEVEL 4: ", error)
	else:
		print("LEVEL 4 LOADING SUCCESSFULLY")


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
