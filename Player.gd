extends CharacterBody3D

# How fast the player moves in meters per second.
@export var SPEED = 7

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var nav_agent = $NavigationAgent3D

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
	if attacking:
		if attack_time < ATTACK_DURATION:
			attack_time += delta
		else:
			attacking = false
			attack_time = 0
			animation_player.speed_scale = 1.0
		return
	
	#if Input.is_action_just_pressed("movement"):
	#	var space_state = get_world_3d().direct_space_state
	#	var query = PhysicsRayQueryParameters3D.create()
		
	#if Input.is_action_just_pressed("basic_attack"):
	#	if not attacking:
	#		attacking = true
	#		animation_player.current_animation = "Sword_Slash"
	#		animation_player.speed_scale = attack_speed_scale
	#	return

	var current_position = global_transform.origin
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - current_position).normalized() * SPEED
	
	velocity = new_velocity
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	print(nav_agent.target_position, nav_agent.distance_to_target(), nav_agent.is_target_reached())
	if velocity != Vector3.ZERO and not nav_agent.is_target_reached():
		var direction = velocity.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
	
	var animation = "Idle_Sword"
	if velocity.x or velocity.z:
		animation = "Run"
	animation_player.current_animation = animation
	
	move_and_slide()

func _on_command_player(position):
	nav_agent.set_target_position(position)
