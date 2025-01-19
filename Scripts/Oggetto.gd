extends StaticBody2D
class_name Oggetto

@export var texture: Texture2D
# Called when the node enters the scene tree for the first time.
func _ready():
	var Size = texture.get_size()
	var Sprite = Sprite2D.new()
	Sprite.texture = texture
	add_child(Sprite)
	var Shape = RectangleShape2D.new()
	Shape.size = Vector2(Size.x, Size.y / 2)
	var Collision = CollisionShape2D.new()
	Collision.shape = Shape
	Collision.position.y = Size.y / 4
	add_child(Collision)
	z_index = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
