extends LevelParent

var ghost_projectile: PackedScene = preload("res://Scenes/Projectiles/ghost_projectile.tscn")
var wall_block = preload("res://Scenes/Objects/broken_wall.tscn").instantiate()

func _ready() -> void:
	print("Castle started")

func _on_ghost_ghost_projectile(pos: Variant, dir: Variant) -> void:
	ghost_shoot(pos, dir)

func _on_ghost_2_ghost_projectile(pos: Variant, dir: Variant) -> void:
	ghost_shoot(pos, dir)

func ghost_shoot(pos: Variant, dir: Variant) -> void:
	var projectile = ghost_projectile.instantiate() as Area2D
	projectile.position = pos
	projectile.rotation = dir.angle() + (PI/2)
	projectile.direction = dir
	$Projectiles.add_child(projectile)
	
func blockEntrance():
	wall_block.global_position = $Positions/BlockWallPos.global_position
	$Objects.add_child(wall_block)

func startBossFight():
	blockEntrance()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	startBossFight()
