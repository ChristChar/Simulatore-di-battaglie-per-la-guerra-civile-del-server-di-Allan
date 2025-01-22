extends TileMapLayer

@export var Y_size: int = 100
@export var X_size: int = 175

var Textures = [
	preload("res://Resources/Images/Albero.png"),
	preload("res://Resources/Images/Rock.png")
]
var MapArea := Area2D.new()

func _ready():
	for x in range(-X_size / 2, X_size/2+1):
		for y in range(-Y_size / 2, Y_size/2+1):
			set_cell(Vector2i(x,y), 0, Vector2(0, 0))
	for i in range(randi_range(10,30)):
		var Alberino = Oggetto.new( Textures.pick_random())
		Alberino.global_position = Vector2(randi_range(-X_size/2 * 32, X_size/2 * 32),randi_range(-Y_size/2 * 32, Y_size/2 * 32))
		add_child(Alberino)
	var Shape = RectangleShape2D.new()
	Shape.size = Vector2(X_size * 32, Y_size * 32)
	var Collision = CollisionShape2D.new()
	Collision.shape = Shape
	MapArea.add_child(Collision)
	add_child(MapArea)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for truppa in get_tree().get_nodes_in_group("Truppa"):
		if not truppa in MapArea.get_overlapping_bodies() and truppa.Initialize and not FileFunctions.IsBuilding:
			truppa.Invert = not truppa.Invert
	await get_tree().create_timer(10).timeout
