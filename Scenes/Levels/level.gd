extends Node2D
class_name LevelParent

var wizard_attack: PackedScene = preload("res://Scenes/Projectiles/wizard_attack.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func create_wizard_attack(pos, dir) -> void:
	var laser = wizard_attack.instantiate() as Area2D
	laser.position = pos
	laser.rotation = dir.angle() + (PI/2)
	laser.direction = dir
	$Projectiles.add_child(laser)


func _on_player_wizard_attack(pos, dir) -> void:
	create_wizard_attack(pos, dir)
