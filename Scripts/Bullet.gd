extends Area2D
class_name BulletBody

@export var data: BulletData
var Direction: Vector2 = Vector2.ZERO
var Owner: bool
var Penetraione: int
var Not_valid_guys: Array[Truppa] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	add_to_group("Bullet")
	var Shape = RectangleShape2D.new()
	Shape.size = data.Size
	var Collision = CollisionShape2D.new()
	Collision.shape = Shape
	add_child(Collision)
	var Quadrato = ColorRect.new()
	Quadrato.size = data.Size
	Quadrato.position = -data.Size / 2
	Quadrato.color = data.color
	add_child(Quadrato)
	Penetraione = data.Penetraione

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in get_overlapping_bodies():
		if body is Truppa:
			if is_instance_valid(body) and not body.Death:
				if body.SquadraRossa != Owner and not body in Not_valid_guys:
					body.Current_HP -= data.Damage
					Penetraione -= 1
					Not_valid_guys.append(body)
					if Penetraione <= 0:
						queue_free()
		else: 
			Direction += Vector2(randf_range(-1, 1), randf_range(-1, 1))

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += Direction * data.speed * delta
