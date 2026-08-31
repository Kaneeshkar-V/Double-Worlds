extends CharacterBody2D


# ============================================================
# MOVEMENT
# ============================================================

@export_category("Movement")

@export var move_speed: float = 350.0
@export var acceleration: float = 2200.0
@export var friction: float = 2600.0
@export var air_control: float = 0.85


# ============================================================
# JUMP
# ============================================================

@export_category("Jump")

@export var jump_velocity: float = -500.0
@export var gravity: float = 1800.0

# Coyote time
@export var coyote_time: float = 0.12


# ============================================================
# SCREEN SHAKE
# ============================================================

@export_category("Screen Shake")

@export var shake_strength: float = 8.0
@export var shake_duration: float = 0.15


# ============================================================
# REFERENCES
# ============================================================

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer = $JumpSound
@onready var hurt_sound: AudioStreamPlayer = $HurtSound
@onready var camera: Camera2D = $Camera2D



# ============================================================
# VARIABLES
# ============================================================

var coyote_timer: float = 0.0

var shake_timer: float = 0.0


# ============================================================
# READY
# ============================================================

func _ready() -> void:

	animated_sprite.play("idle")


# ============================================================
# PHYSICS PROCESS
# ============================================================

func _physics_process(delta: float) -> void:

	update_coyote_time(delta)

	apply_gravity(delta)

	handle_movement(delta)

	handle_jump()

	move_and_slide()

	update_animation()

	update_screen_shake(delta)


# ============================================================
# COYOTE TIME
# ============================================================

func update_coyote_time(delta: float) -> void:

	if is_on_floor():

		coyote_timer = coyote_time

	else:

		coyote_timer -= delta


# ============================================================
# GRAVITY
# ============================================================

func apply_gravity(delta: float) -> void:

	if not is_on_floor():

		velocity.y += gravity * delta


# ============================================================
# MOVEMENT
# ============================================================

func handle_movement(delta: float) -> void:

	var direction := 0.0


	# --------------------------------------------------------
	# LEFT
	# --------------------------------------------------------

	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):

		direction -= 1.0


	# --------------------------------------------------------
	# RIGHT
	# --------------------------------------------------------

	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):

		direction += 1.0


	# --------------------------------------------------------
	# TARGET SPEED
	# --------------------------------------------------------

	var target_speed := direction * move_speed

	var current_acceleration := acceleration


	# --------------------------------------------------------
	# AIR CONTROL
	# --------------------------------------------------------

	if not is_on_floor():

		current_acceleration *= air_control


	# --------------------------------------------------------
	# ACCELERATION
	# --------------------------------------------------------

	if direction != 0.0:

		velocity.x = move_toward(
			velocity.x,
			target_speed,
			current_acceleration * delta
		)


	# --------------------------------------------------------
	# FRICTION
	# --------------------------------------------------------

	else:

		velocity.x = move_toward(
			velocity.x,
			0.0,
			friction * delta
		)


	# --------------------------------------------------------
	# FACE DIRECTION
	# --------------------------------------------------------

	if direction < 0.0:

		animated_sprite.flip_h = true

	elif direction > 0.0:

		animated_sprite.flip_h = false


# ============================================================
# JUMP
# ============================================================

func handle_jump() -> void:

	# --------------------------------------------------------
	# ONLY JUMP WHEN SPACE IS ACTUALLY PRESSED
	# --------------------------------------------------------

	if Input.is_key_pressed(KEY_SPACE):

		if coyote_timer > 0.0:

			velocity.y = jump_velocity
			jump_sound.play()

			coyote_timer = 0.0


	# --------------------------------------------------------
	# SHORT JUMP WHEN SPACE IS RELEASED
	# --------------------------------------------------------

	if not Input.is_key_pressed(KEY_SPACE):

		if velocity.y < 0.0:

			velocity.y *= 0.5


# ============================================================
# ANIMATION
# ============================================================

func update_animation() -> void:

	# --------------------------------------------------------
	# AIRBORNE
	# --------------------------------------------------------

	if not is_on_floor():

		if velocity.y < 0.0:

			if animated_sprite.animation != "jump":

				animated_sprite.play("jump")

		else:

			if animated_sprite.animation != "fall":

				animated_sprite.play("fall")

		return


	# --------------------------------------------------------
	# RUNNING
	# --------------------------------------------------------

	if abs(velocity.x) > 20.0:

		if animated_sprite.animation != "run":

			animated_sprite.play("run")

		return


	# --------------------------------------------------------
	# IDLE
	# --------------------------------------------------------

	if animated_sprite.animation != "idle":

		animated_sprite.play("idle")


# ============================================================
# SCREEN SHAKE
# ============================================================


func shake_screen() -> void:

	shake_timer = shake_duration


func update_screen_shake(delta: float) -> void:

	if shake_timer > 0.0:

		shake_timer -= delta

		camera.position = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)

	else:

		camera.position = Vector2.ZERO


# ============================================================
# SCREEN SHAKE UPDATE
# ============================================================
