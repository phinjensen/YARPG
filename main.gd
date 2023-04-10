extends Node

var ZOOM_FACTOR = 3

@onready var camera = $Camera
@onready var world = $World
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	world.rotate_y(90)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_tree().call_group(
		"enemies",
		"update_target_position",
		player.global_transform.origin
	)
	
	var camera_position = Vector3(
		$Player.position.x,
		$Player.position.y + 25,
		$Player.position.z + 25
	)
	camera.position = camera_position

	if Input.is_action_just_released("zoom_in"):
		camera.size = max(camera.size - ZOOM_FACTOR, camera.maximum_zoom)
	elif Input.is_action_just_released("zoom_out"):
		camera.size = min(camera.size + ZOOM_FACTOR, camera.minimum_zoom)
