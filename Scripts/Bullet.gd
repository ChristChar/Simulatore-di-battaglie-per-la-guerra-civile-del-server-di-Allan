extends Area2D
class_name BulletBody

@export var data: BulletData
var Direction: Vector2 = Vector2.ZERO
var Owner: Truppa

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in get_overlapping_bodies():
		if body is Truppa:
			if body != Owner:
				body.HP -= data.Damage
				queue_free()
		else: 
			Direction += Vector2(randf_range(-1, 1), randf_range(-1, 1))

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += Direction * data.speed * delta
