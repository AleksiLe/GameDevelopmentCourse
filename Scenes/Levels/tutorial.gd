extends LevelParent

var leaf_projectile: PackedScene = preload("res://Scenes/Projectiles/leaf_projectile.tscn")

func _ready() -> void:
	print("tutorial started")

func _on_sandman_leaf_projectile(pos: Variant, dir: Variant) -> void:
	var laser = leaf_projectile.instantiate() as Area2D
	laser.position = pos
	laser.rotation = dir.angle() + (PI/2)
	laser.direction = dir
	$Projectiles.add_child(laser)
