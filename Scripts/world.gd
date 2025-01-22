extends Node2D

var Can_Place = true
var Esercito: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Clear_Troops():
	for child in $Esercito.get_children():
		child.queue_free()

func Start_Battle():
	Esercito = $Esercito.duplicate(true)
	print(Esercito)
	FileFunctions.IsBuilding = false
	$"CanvasLayer/Battle GUI".visible = true
	$"CanvasLayer/Build GUI".visible = false
	
	
func Finish_Battle():
	$Esercito.queue_free()
	add_child(Esercito)
	await get_tree().create_timer(0.01).timeout
	Esercito.name = "Esercito"
	FileFunctions.IsBuilding = true
	$"CanvasLayer/Battle GUI".visible = false
	$"CanvasLayer/Build GUI".visible = true
	$Place.Eserito = $Esercito


func _on_button_pressed():
	Start_Battle()


func _on_finish_button_pressed():
	Finish_Battle()


func _on_clear_pressed():
	Clear_Troops()
