extends Button

var data: Truppa
# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.texture = data.texture
	$Label.text = data.Name + "\nCosto: " + str(data.Costo)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	get_tree().get_first_node_in_group("World").get_node("Place").Change_data(data)
