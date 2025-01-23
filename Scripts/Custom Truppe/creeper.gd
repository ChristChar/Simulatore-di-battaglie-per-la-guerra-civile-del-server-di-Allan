extends Truppa

var Is_Exploding = false
var Exploding = 0.0
var Explosion_particles_sceen = preload("res://Scenes/Particles/Explosion.tscn")
var Explosion_sound = preload("res://Resources/Sounds/Ka booms.mp3")
var Explosion_Audio := AudioStreamPlayer2D.new()
var Explosion_particles: CPUParticles2D
var Already_exploded: Array[Truppa] = []

@export var Exploding_damage: int = 100
@export var Exploding_knockback: int = 100

func _ready():
	super._ready()
	Explosion_particles = Explosion_particles_sceen.instantiate()
	Explosion_particles.emitting = false
	add_child(Explosion_particles)
	Area.get_child(0).shape.size *= 2
	Explosion_Audio.stream = Explosion_sound
	Explosion_Audio.connect("finished", DIE)
	add_child(Explosion_Audio)

func DIE():
	super.DIE()
	Explosion_particles.emitting = false
	Is_Exploding = false  # Resetta lo stato dell'esplosione
	Exploding = 0.0  # Resetta il tempo dell'esplosione
	Already_exploded.clear()  # Rimuove i nemici già esplosi
	Explosion_particles.emitting = false  # Ferma le particelle
	Explosion_Audio.stop()  # Ferma l'

func _process(delta):
	if FileFunctions.IsBuilding or Death:
		return
	if Is_Exploding:
		velocity = Vector2.ZERO
		for body in Area.get_overlapping_bodies():
			if body is Truppa and body != self and not body in Already_exploded:
				body.Current_HP -= Exploding_damage
				body.velocity += global_position.direction_to(body.global_position) * Exploding_knockback
				Already_exploded.append(body)
	else:
		super._process(delta)
		for body in Area.get_overlapping_bodies():
			if body is Truppa and body.SquadraRossa != SquadraRossa:
				Exploding += delta
				if Exploding >= 1:
					Explosion_particles.emitting = true
					Is_Exploding = true
					Explosion_Audio.pitch_scale = randf_range(0.9,1.1)
					Explosion_Audio.play()
