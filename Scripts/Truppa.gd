extends CharacterBody2D
class_name  Truppa

var Progress: ProgressBar
var Target: Truppa

@export var texture: Texture2D
@export var HP: int
@export var SquadraRossa: bool
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	add_to_group("Truppa")
	var Size = texture.get_size()
	var Sprite = Sprite2D.new()
	Sprite.texture = texture
	add_child(Sprite)
	Progress = ProgressBar.new()
	Progress.size = Vector2(Size.x, 40)
	Progress.position = Vector2( -Size.x/2, -Size.y / 2 - 40)
	if SquadraRossa:
		Progress.modulate = Color(1,0,0)
	else:
		Progress.modulate = Color(0,0.5,1)
	Progress.max_value = HP
	add_child(Progress)
	var Shape = RectangleShape2D.new()
	Shape.size = Size
	var Collision = CollisionShape2D.new()
	Collision.shape = Shape
	add_child(Collision)
	Find_Target()

func Find_Target():
	var Truppe = get_tree().get_nodes_in_group("Truppa")
	for truppa in Truppe:
		if truppa.SquadraRossa == SquadraRossa:
			Truppe.erase(truppa)
	if Truppe.size() == 0:
		return
	else:
		Target = Truppe[randi_range(0, Truppe.size() - 1)]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Progress.value = HP
	if HP <= 0:
		queue_free()
	if Target:
		pass
	else:
		Find_Target()
		
func _physics_process(delta):
	if Target:
		global_position = lerp(global_position, Target.global_position, delta)
