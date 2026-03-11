extends Area2D
@export var max_rotation_speed: int = 15
@export var damage_per_second: int = 30
@export var spinup_time: float = 5.0

var player_inside: Node2D = null
var elapsed_time: float = 0.0

func _process(delta):
	elapsed_time += delta
	
	var current_speed = lerp(0.0, float(max_rotation_speed), min(elapsed_time / spinup_time, 1.0))
	rotation += delta * current_speed
	
	if elapsed_time >= spinup_time and player_inside != null:
		if "hit" in player_inside:
			player_inside.hit(damage_per_second * delta)

func _on_body_entered(body: Node2D) -> void:
	player_inside = body

func _on_body_exited(body: Node2D) -> void:
	if body == player_inside:
		player_inside = null
