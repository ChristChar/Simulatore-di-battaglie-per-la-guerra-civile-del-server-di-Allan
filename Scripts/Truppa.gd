extends CharacterBody2D
class_name Truppa

@export_enum("Insegui", "Fermo", "Avanti", "Casuale", "Scappa") var Movment_when_terget: String = "Insegui"
@export_enum("Fermo", "Avanti", "Casuale") var Movment_when_not_terget: String = "Avanti"
@export var texture: Texture2D
@export var HP: int
@export var Speed: float = 100.0
@export var SquadraRossa: bool
@export var arma: Arma
@export var vision_range: float = 2000.0  # Distanza massima per rilevare bersagli
@export var Costo: int = 1
@export var Name: String = "E"

var Progress: ProgressBar
var Collision := CollisionShape2D.new()
var Target: Truppa
var Attack_countdown = 0.0
var Area: Area2D
var HPPivot: Node2D
var Sprite := Sprite2D.new()
var Direction = 0
var raycasts: Array[RayCast2D] = []
var Invert = false
var Initialize = false
var IsMouseIn = false
var Death = false
var Current_HP: int
var Original_Position: Vector2

func _ready():
	randomize()
	Current_HP = HP
	Original_Position = global_position
	add_to_group("Truppa")
	var Size = texture.get_size()
	Sprite.texture = texture
	add_child(Sprite)
	Progress = ProgressBar.new()
	Progress.size = Vector2(Size.x, 40)
	Progress.position = Vector2(-Size.x / 2, -Size.y / 2 - 40)
	if SquadraRossa:
		Progress.modulate = Color(1, 0, 0)
		Direction = deg_to_rad(180)
		rotation = deg_to_rad(180)
		Sprite.flip_v = true
		name = "Rosso"
		Invert = true
	else:
		Progress.modulate = Color(0, 0.5, 1)
		name = "Blu"
		Direction = deg_to_rad(180)
		rotation = deg_to_rad(180)
	Progress.max_value = HP
	HPPivot = Node2D.new()
	HPPivot.add_child(Progress)
	add_child(HPPivot)
	var Shape = RectangleShape2D.new()
	Shape.size = Size
	Collision.shape = Shape
	Area = Area2D.new()
	var AreaCollision = CollisionShape2D.new()
	AreaCollision.shape = Shape.duplicate()
	AreaCollision.shape.size += Vector2(10, 10)
	Area.add_child(AreaCollision)
	add_child(Area)
	add_child(Collision)
	if arma:
		if arma.Sprite:
			var Arma_sprite = Sprite2D.new()
			Arma_sprite.texture = arma.Sprite
			Arma_sprite.position = Vector2(0, Size.y * 0.3)
			add_child(Arma_sprite)
	for i in range(20):
		var raycast = RayCast2D.new()
		raycast.target_position = Vector2(Size.x, Size.y / 16 * (i - 10))
		raycast.enabled = true
		raycasts.append(raycast)
		add_child(raycast)
	Attack_countdown = randf()
	if not SquadraRossa:
		Direction = 0
		rotation = 0
	Progress.value = Current_HP
	HPPivot.global_rotation = 0
	Find_Target()
	AreaConnect()
	Initialize = true

func AreaConnect():
	Area.connect("mouse_entered", mouse_entered)
	Area.connect("mouse_exited", mouse_exited)

func mouse_entered():
	IsMouseIn = true

func mouse_exited():
	IsMouseIn = false

func Find_Target():
	# Trova tutte le truppe nemiche valide
	var Truppe = get_tree().get_nodes_in_group("Truppa").duplicate()
	var Truppe_non_valide = []
	for truppa in Truppe:
		if is_instance_valid(truppa) and (truppa.SquadraRossa == SquadraRossa or global_position.distance_to(truppa.global_position) >= vision_range):
			Truppe_non_valide.append(truppa)
	for truppa in Truppe_non_valide:
		Truppe.erase(truppa)
	if Truppe.size() == 0:
		return
	else:
		Target = Truppe[randi_range(0, Truppe.size() - 1)]
	
	# Ordina le truppe in base alla distanza e alla salute
	Truppe.sort_custom(_sort_by_distance_and_hp)
	Target = Truppe[0]

func _sort_by_distance_and_hp(a: Truppa, b: Truppa) -> int:
	var dist_a = global_position.distance_to(a.global_position)
	var dist_b = global_position.distance_to(b.global_position)
	
	if dist_a != dist_b:
		return dist_a < dist_b  # Priorità al nemico più vicino
	return a.Current_HP < b.Current_HP  # Se le distanze sono uguali, priorità al nemico con meno HP

func DIE():
	visible = false
	Death = true
	global_position = Vector2(9999999,9999999)

func Reset():
	global_position = Original_Position
	HPPivot.global_rotation = 0
	visible = true
	Death = false
	Current_HP = HP
	Progress.value = Current_HP
	if SquadraRossa:
		Direction = deg_to_rad(180)
		rotation = deg_to_rad(180)
	else:
		Direction = 0
		rotation = 0

func _process(delta):
	if Death:
		return
	if FileFunctions.IsBuilding:
		if IsMouseIn and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			queue_free()
			if SquadraRossa:
				get_tree().get_first_node_in_group("World").RedTeamMoney -= Costo
			else:
				get_tree().get_first_node_in_group("World").BlueTeamMoney -= Costo
	else:
		Progress.value = Current_HP
		HPPivot.global_rotation = 0
		Attack_countdown -= delta
		
		if Current_HP <= 0:
			DIE()
		
		if Is_target_valid():
			Direction = global_position.angle_to_point(Target.global_position)
			if arma and arma.Type == "Mischia":
				for body in Area.get_overlapping_bodies():
					if body is Truppa and body.SquadraRossa != SquadraRossa:
						Attack(body)
			
			if arma and arma.Type == "Distanza":
				if Attack_countdown <= 0:
					var NewBullet = BulletBody.new()
					NewBullet.global_position = global_position
					NewBullet.Direction = angle_to_vector(Direction)
					NewBullet.Owner = SquadraRossa
					NewBullet.data = arma.bullet
					get_parent().add_child(NewBullet)
					Attack_countdown = arma.Countdown + randf_range(-0.3,0.3)
		else:
			Find_Target()
		
		rotation = lerp_angle(rotation, Direction, delta)

func angle_to_vector(angle: float) -> Vector2:
	return Vector2(cos(angle), sin(angle))

func Attack(Target: Truppa):
	if Attack_countdown <= 0:
		Target.Current_HP -= arma.Damage
		Attack_countdown = arma.Countdown + randf_range(-0.3,0.3)

func Is_target_valid() -> bool:
	return Target and is_instance_valid(Target) and global_position.distance_to(Target.global_position) <= vision_range

func _physics_process(delta):
	if FileFunctions.IsBuilding or Death:
		return
	if Is_target_valid():
		Move(Movment_when_terget, delta)
	else:
		Move(Movment_when_not_terget, delta)
	move_and_slide()

func Raycast_check() -> Vector2:
	var avoidance_vector = Vector2()
	var collision_count = 0

	for raycast in raycasts:
		if raycast.is_colliding():
			var collision_point = raycast.get_collision_point()
			var collision_vector = global_position.direction_to(collision_point)
			avoidance_vector += collision_vector
			collision_count += 1

	if collision_count > 0:
		avoidance_vector /= collision_count
		avoidance_vector = avoidance_vector.rotated(deg_to_rad(90))  # Perpendicolare
		return -avoidance_vector.normalized()
	
	return Vector2.ZERO

func Move(Move_type: String, delta: float):
	match Move_type:
		"Insegui":
			var direction = Target.global_position - global_position
			direction = direction.normalized()
			var raycast_result = Raycast_check()
			if raycast_result != Vector2.ZERO:
				velocity = (direction + raycast_result).normalized() * Speed
			else:
				velocity = direction * Speed
		"Scappa":
			var direction = Target.global_position - global_position
			direction = -direction.normalized()
			var raycast_result = Raycast_check()
			if raycast_result != Vector2.ZERO:
				velocity = (direction + raycast_result).normalized() * Speed
			else:
				velocity = direction * Speed
		"Avanti":
			Direction = deg_to_rad(180) if Invert else 0
			var raycast_result = Raycast_check()
			velocity = (angle_to_vector(Direction) + raycast_result).normalized() * Speed
		"Casuale":
			if randf() < delta:
				Direction += randf_range(-2, 2)
			var raycast_result = Raycast_check()
			velocity = (angle_to_vector(Direction) + raycast_result).normalized() * Speed
		"Fermo":
			velocity = Vector2.ZERO
