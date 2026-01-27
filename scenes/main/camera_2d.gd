extends Camera2D

var speed: int = 350
var direction: Vector2

var zoom_step: Vector2 = Vector2(0.04, 0.04)

func _process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	position += direction * speed * delta
	
	if Input.is_action_just_pressed("zoom_in"):
		zoom += zoom_step
	elif Input.is_action_just_pressed("zoom_out"):
		zoom -= zoom_step
	$Background.scale = Vector2(1, 1) / zoom
	$Background.pivot_offset = $Background.size / 2
