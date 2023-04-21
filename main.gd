extends Node

var ZOOM_FACTOR = 3

@onready var camera = $Camera
@onready var world = $World
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	for floor_piece in get_tree().get_nodes_in_group("floor"):
		floor_piece.command_player.connect($Player._on_command_player)
	world.rotate_y(45)

func spawn_enemy(origin):
	var enemy = load("res://enemy.tscn")
	var instance = enemy.instantiate()
	add_child(instance)
	instance.position = origin
	instance.player_attack.connect($Player._on_player_attack)
	instance.fireball.connect(create_fireball)

func create_fireball(origin, target):
	var attack = load("res://fireball.tscn").instantiate()
	add_child(attack)
	attack.initialize(origin, target)

var _last_spawn_point = null
var enemies_to_spawn = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_tree().call_group(
		"enemies",
		"update_target_position",
		player.global_transform.origin
	)
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0:
		var verts = $World/NavigationRegion3D.navigation_mesh.get_vertices()
		for i in range(enemies_to_spawn):
			var spawn_point = verts[randi() % verts.size()]
			while spawn_point == _last_spawn_point:
				spawn_point = verts[randi() % verts.size()]
			spawn_enemy(spawn_point)
		enemies_to_spawn += 1
	
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
