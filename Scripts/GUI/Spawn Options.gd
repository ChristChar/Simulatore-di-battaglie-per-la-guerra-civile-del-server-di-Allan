extends HBoxContainer

var Option_scene = preload("res://Scenes/Option.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.queue_free()
	var Lollo: Truppa
	var Path = "res://Truppe/"
	for Scene in FileFunctions.get_files_in_directory(Path):
		Lollo = load(Path+Scene).instantiate()
		var Option = Option_scene.instantiate()
		Option.data = Lollo
		add_child(Option)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
