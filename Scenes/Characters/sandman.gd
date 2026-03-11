extends CharacterBody2D

var smoke_screen = preload("res://Scenes/Effects/smoke_screen.tscn").instantiate()
var portal = preload("res://Scenes/Objects/portal.tscn").instantiate()

var player_nearby: bool = false
var can_attack: bool = true
var spawn_pos: Vector2
const pixels_away: int = 60
@export var health: float = 100
@export var speed: int = 200

signal leaf_projectile(pos, dir)

func _ready() -> void:
	spawn_pos = global_position
	
func _process(_delta: float) -> void:
	if player_nearby:
		var direction_to_player = Globals.player_pos - global_position
		velocity = direction_to_player.normalized() * speed
		if can_attack:
			shoot_shotgun(direction_to_player)
	else:
		var direction_to_spawn = spawn_pos - global_position
		velocity = direction_to_spawn.normalized() * speed
		if direction_to_spawn.length() < 10:
			velocity = Vector2.ZERO
		
	move_and_slide()
	
func shoot_shotgun(direction_to_player: Vector2) -> void:
	var pos: Vector2 = global_position + direction_to_player.normalized() * pixels_away
	var dir: Vector2 = (Globals.player_pos - global_position).normalized()
	var spread_angle := deg_to_rad(15) # tweak for tighter/wider spread
	can_attack = false
	$AttackCooldown.start()
	leaf_projectile.emit(pos, dir)
	leaf_projectile.emit(pos, dir.rotated(spread_angle))
	leaf_projectile.emit(pos, dir.rotated(-spread_angle))

func hit(dmg: float) -> void:
	health -= dmg
	if health <= 0:
		call_deferred("_die")

func _die() -> void:
	sandmandDies(global_position)
	queue_free()

func sandmandDies(pos: Vector2) -> void:
	smoke_screen.global_position = pos
	portal.global_position = pos
	get_tree().current_scene.add_child(portal)
	get_tree().current_scene.add_child(smoke_screen)
	

func _on_attack_area_body_entered(_body: Node2D) -> void:
	player_nearby = true
func _on_attack_area_body_exited(_body: Node2D) -> void:
	player_nearby = false
func _on_attack_cooldown_timeout() -> void:
	can_attack = true
