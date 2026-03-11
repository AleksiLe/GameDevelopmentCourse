extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _on_area_2d_body_entered(_body: Node2D) -> void:
	TransitionLayer.change_scene("res://Scenes/Levels/castle.tscn")


func _on_timer_timeout() -> void:
	$".".visible = true
