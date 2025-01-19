extends TileMapLayer

@export var Y_size: int = 100
@export var X_size: int = 175
var Textures = [
	preload("res://Resources/Images/Albero.png"),
	preload("res://Resources/Images/Rock.png")
]
# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(-X_size / 2, X_size/2+1):
		for y in range(-Y_size / 2, Y_size/2+1):
			set_cell(Vector2i(x,y), 0, Vector2(0, 0))
	for i in range(randi_range(10,50)):
		var Alberino = Oggetto.new()
		Alberino.global_position = Vector2(randi_range(-X_size/2 * 32, X_size/2 * 32),randi_range(-Y_size/2 * 32, Y_size/2 * 32))
		Alberino.texture = Textures.pick_random()
		add_child(Alberino)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
