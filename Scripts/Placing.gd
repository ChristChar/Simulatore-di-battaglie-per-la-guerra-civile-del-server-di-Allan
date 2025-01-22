extends Area2D

var Data: Truppa
var Sprite := Sprite2D.new()
var Collision := CollisionShape2D.new()

@export var Eserito: Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	Data = load("res://Truppe/Tank.tscn").instantiate()
	add_child(Sprite)
	Collision.shape = RectangleShape2D.new()
	add_child(Collision)
	Update()

func Update():
	Sprite.texture = Data.texture
	Collision.shape.size = Data.texture.get_size()

func Change_data(NewData:Truppa):
	Data = NewData
	Update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if FileFunctions.IsBuilding:
		visible = true
		global_position = get_global_mouse_position()
		Sprite.flip_h = global_position.x > 0
		if get_overlapping_bodies().size() > 0:
			modulate = Color(1,0,0)
		else:
			modulate = Color(0,1,0)
			if Input.is_action_just_pressed("Place") and get_parent().Can_Place:
				var NewTruppa = Data.duplicate()
				NewTruppa.SquadraRossa = global_position.x >= 0
				NewTruppa.global_position = global_position
				Eserito.add_child(NewTruppa)
	else:
		visible = false
