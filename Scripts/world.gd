extends Node2D

var Can_Place = true
var RedTeamMoney = 0
var BlueTeamMoney = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	Clear_Troops()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Esercito:
		if FileFunctions.IsBuilding:
			$CanvasLayer/BlueTeamCount.text = str(BlueTeamMoney)
			$CanvasLayer/RedTeamCount.text = str(RedTeamMoney)
		else:
			var RedCount = 0
			var BlueCount = 0
			for truppa in get_tree().get_nodes_in_group("Truppa"):
				if $Esercito.is_ancestor_of(truppa) and not truppa.Death:
					if truppa.SquadraRossa:
						RedCount += 1
					else:
						BlueCount += 1
			$CanvasLayer/BlueTeamCount.text = str(BlueCount)
			$CanvasLayer/RedTeamCount.text = str(RedCount)
			await get_tree().create_timer(1).timeout
		

func Clear_Troops():
	for child in $Esercito.get_children():
		child.queue_free()
	RedTeamMoney = 0
	BlueTeamMoney = 0

func Start_Battle():
	FileFunctions.IsBuilding = false
	$"CanvasLayer/Battle GUI".visible = true
	$"CanvasLayer/Build GUI".visible = false
	
	
func Finish_Battle():
	FileFunctions.IsBuilding = true
	$"CanvasLayer/Battle GUI".visible = false
	$"CanvasLayer/Build GUI".visible = true
	$Place.Eserito = $Esercito
	for Bullet in get_tree().get_nodes_in_group("Bullet"):
		Bullet.queue_free()
	for truppa in $Esercito.get_children():
		if truppa is Truppa:
			truppa.Reset()

func _on_button_pressed():
	Start_Battle()


func _on_finish_button_pressed():
	Finish_Battle()


func _on_clear_pressed():
	Clear_Troops()
