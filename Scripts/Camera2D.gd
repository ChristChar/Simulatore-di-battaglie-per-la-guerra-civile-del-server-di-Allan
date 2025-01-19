extends Camera2D

@export var move_speed: float = 400  # Velocità di movimento della telecamera
@export var zoom_speed: float = 0.1  # Velocità di zoom

# Chiamato ogni frame
func _process(delta):
	# Movimentazione con le frecce direzionali
	var direction = Vector2()
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	var Shift = 1
	if Input.is_key_pressed(KEY_SHIFT):
		Shift *= 4
	# Movimento della telecamera
	position += direction.normalized() * move_speed * delta * Shift

	# Zoom con la rotellina del mouse
	if Input.is_action_just_pressed("zoom_in"):
		zoom *= (1 + zoom_speed)
	elif Input.is_action_just_pressed("zoom_out"):
		zoom *= (1 - zoom_speed)
