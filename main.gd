extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var ZOOM_FACTOR = 3
var MIN_ZOOM = 15
var MAX_ZOOM = 35

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var camera_position = Vector3(
		$Player.position.x,
		$Player.position.y + 25,
		$Player.position.z + 25
	)
	$Camera.position = camera_position

	if Input.is_action_just_released("zoom_in"):
		$Camera.size = max($Camera.size - ZOOM_FACTOR, MIN_ZOOM)
	elif Input.is_action_just_released("zoom_out"):
		$Camera.size = min($Camera.size + ZOOM_FACTOR, MAX_ZOOM)
