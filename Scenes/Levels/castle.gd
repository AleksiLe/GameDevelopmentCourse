extends LevelParent

var ghost_projectile: PackedScene = preload("res://Scenes/Projectiles/ghost_projectile.tscn")
var wall_block = preload("res://Scenes/Objects/broken_wall.tscn").instantiate()
var boss = preload("res://Scenes/Characters/knight.tscn").instantiate()
var shurikenPhase = preload("res://Scenes/Phases/shuriken_phase.tscn").instantiate()
var ghostPhase = preload("res://Scenes/Phases/phase_2.tscn").instantiate()
var blocked: bool = false

func _ready() -> void:
	print("Castle started")

func _on_ghost_ghost_projectile(pos: Variant, dir: Variant) -> void:
	ghost_shoot(pos, dir)

func ghost_shoot(pos: Variant, dir: Variant) -> void:
	var projectile = ghost_projectile.instantiate() as Area2D
	projectile.position = pos
	projectile.rotation = dir.angle() + (PI/2)
	projectile.direction = dir
	$Projectiles.add_child(projectile)
	
func blockEntranceAndStartPhase1():
	wall_block.global_position = $Positions/BlockWallPos.global_position
	$Objects.add_child(wall_block)
	shurikenPhase.global_position = $Positions/Center.global_position
	$Objects.add_child(shurikenPhase)
	
func startPhase2():
	ghostPhase.global_position = $Positions/Center.global_position
	$Objects.add_child(ghostPhase)
	

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if !blocked:
		call_deferred("blockEntranceAndStartPhase1")
		blocked = true

func _on_knight_phase_1_projectile(pos: Variant, dir: Variant) -> void:
	ghost_shoot(pos, dir)


func _on_knight_phase_1_stop() -> void:
	shurikenPhase.queue_free()
	startPhase2()
	
