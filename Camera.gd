extends Camera3D

@export var maximum_zoom = 10
@export var minimum_zoom = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	size = minimum_zoom
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
