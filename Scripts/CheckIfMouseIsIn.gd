extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", _mouse_entered)
	connect("mouse_exited", _mouse_exited)

func _mouse_entered():
	get_tree().get_first_node_in_group("World").Can_Place = false

func _mouse_exited():
	get_tree().get_first_node_in_group("World").Can_Place = true
