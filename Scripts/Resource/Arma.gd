extends Resource
class_name Arma

@export_enum("Mischia", "Distanza") var Type: String = "Mischia"
@export var Sprite: Texture2D
@export var Damage: int = 1
@export var Countdown: float = 1.0

@export_group("Mischia")

@export_group("Distanza")
@export var bullet: BulletData = BulletData.new()
