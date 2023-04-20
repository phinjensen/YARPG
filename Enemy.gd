extends CharacterBody3D

signal player_attack

const SPEED = 2.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var nav_agent = $NavigationAgent3D

const MAX_HEALTH = 150.0
var health = 150.0

func _physics_process(delta):
	$HealthBarPivot.scale.x = health / MAX_HEALTH
	var current_position = global_transform.origin
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - current_position).normalized() * SPEED
	
	velocity = new_velocity
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	move_and_slide()

func update_target_position(target):
	nav_agent.set_target_position(target)

func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("player_attack", self)

func hit(damage):
	health -= damage
	print(health)
	if health <= 0:
		queue_free()
