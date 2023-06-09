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
var attack_hit = false

var animation_player

var MAX_HEALTH = 1000.0
var health = MAX_HEALTH
@onready var target_enemy = null
var ATTACK_RANGE = 1.5

func _ready():
	animation_player = $Pivot/warrior/AnimationPlayer
	attack_speed_scale = 1 / (ATTACK_DURATION / animation_player.get_animation("Sword_Slash").length)

func _physics_process(delta):
	$HealthBarPivot.scale.x = health / MAX_HEALTH
	
	if attacking:
		animation_player.current_animation = "Sword_Slash"
		var collisions = $Pivot/warrior/CharacterArmature/Skeleton3D/Sword/SwordBody.get_colliding_bodies()
		if collisions and not attack_hit:
			attack_hit = true
			collisions[0].hit(50)
		if attack_time < ATTACK_DURATION:
			attack_time += delta
		else:
			attacking = false
			attack_hit = false
			attack_time = 0
			animation_player.speed_scale = 1.0
		return

	if target_enemy:
		if nav_agent.distance_to_target() < ATTACK_RANGE:
			attacking = true
		elif not nav_agent.is_target_reached():
			nav_agent.set_target_position(target_enemy.global_transform.origin)
	var next_position = nav_agent.get_next_path_position()
	var animation
	if nav_agent.target_position == Vector3.ZERO or nav_agent.is_target_reached():
		velocity = Vector3.ZERO
		animation = "Idle_Sword"
	else:
		var current_position = global_transform.origin
		next_position.y = current_position.y
		var new_velocity = (next_position - current_position).normalized() * SPEED
		velocity = new_velocity
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		if velocity != Vector3.ZERO:
			var direction = velocity.normalized()
			$Pivot.look_at(position + direction, Vector3.UP)
		animation = "Run"
	
	animation_player.current_animation = animation
	
	move_and_slide()

func hit(damage):
	print("hit for ", damage)
	health -= damage
	if health <= 0:
		queue_free()

func _on_command_player(position):
	target_enemy = null
	nav_agent.set_target_position(position)

func _on_player_attack(enemy):
	target_enemy = enemy
	nav_agent.set_target_position(target_enemy.global_transform.origin)
