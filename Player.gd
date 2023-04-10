extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 7
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75

var ATTACK_DURATION = 0.75

var target_velocity = Vector3.ZERO

var attacking = false
var attack_time = 0
var attack_speed_scale

var animation_player

func _ready():
	animation_player = $Pivot/warrior/AnimationPlayer
	attack_speed_scale = 1 / (ATTACK_DURATION / animation_player.get_animation("Sword_Slash").length)

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO
	
	if attacking:
		if attack_time < ATTACK_DURATION:
			attack_time += delta
		else:
			attacking = false
			attack_time = 0
			animation_player.speed_scale = 1.0
		return
		
	if Input.is_action_just_pressed("basic_attack"):
		print("basic attack")
		if not attacking:
			attacking = true
			animation_player.current_animation = "Sword_Slash"
			animation_player.speed_scale = attack_speed_scale
		return

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	
	var animation = "Idle_Sword"
	if velocity.x or velocity.z:
		animation = "Run"
	animation_player.current_animation = animation
	
	move_and_slide()
