extends Node2D

var projectile_scene: PackedScene = preload("res://Scenes/Projectiles/ghost_projectile_phase2.tscn")

@export var radius: float = 1150
@export var rotation_speed: float = 0.5

var angle := 0.0
var ghosts := []
var shoot: bool = false

func _ready():
	ghosts = get_children()
	$"../Timer".start()

func _process(delta):
	angle -= rotation_speed * delta
	
	var step = TAU / ghosts.size()  # evenly spaced
	
	for i in ghosts.size():
		var ghost_angle = angle + step * i
		
		ghosts[i].position = Vector2(
			cos(ghost_angle),
			sin(ghost_angle)
		) * radius
		
	if shoot:
		shoot_all_ghosts()
		shoot = false
		
func shoot_all_ghosts():
	var center = global_position  # center of the circle
	
	for ghost in ghosts:
		var projectile = projectile_scene.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = ghost.global_position
		var dir = (center - ghost.global_position).normalized()
		projectile.rotation = dir.angle() + (PI/2)
		projectile.direction = dir
		
		

func _on_timer_timeout() -> void:
	shoot = true
