extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collisions = move_and_collide(delta * direction * 4)
	if collisions:
		var collider = collisions.get_collider()
		#if collider.has_method("hit"):
		#	collider.hit(100)
		queue_free()


func initialize(origin, target):
	position = origin
	direction = (target - origin).normalized()
