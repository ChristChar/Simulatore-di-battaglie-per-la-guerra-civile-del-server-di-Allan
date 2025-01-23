extends Truppa

func _ready():
	super._ready()
	Area.get_child(0).shape.size *= 4

func _process(delta):
	if FileFunctions.IsBuilding or Death:
		return
	super._process(delta)
	for body in Area.get_overlapping_bodies():
		if body is Truppa and  body.SquadraRossa != SquadraRossa and randf() < delta * 2:
			global_position += Vector2(randi_range(-1000,1000),randi_range(-1000,1000))
		if body is BulletBody and  body.Owner != SquadraRossa and randf() < delta * 2:
			global_position += Vector2(randi_range(-1000,1000),randi_range(-1000,1000))
