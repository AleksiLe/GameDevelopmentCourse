extends CharacterBody2D

var player_nearby: bool = false
var can_attack: bool = true
const pixels_away: int = 30
@export var health: float = 50
@export var speed: int = 300

signal ghost_projectile(pos, dir)
	
func _process(_delta: float) -> void:
	if player_nearby:
		var direction_to_player = Globals.player_pos - global_position
		velocity = direction_to_player.normalized() * speed
		if can_attack:
			shoot(direction_to_player)

		
	move_and_slide()
	
func shoot(direction_to_player: Vector2) -> void:
	var pos: Vector2 = global_position + direction_to_player.normalized() * pixels_away
	var dir: Vector2 = (Globals.player_pos - global_position).normalized()
	can_attack = false
	$AttackCooldown.start()
	ghost_projectile.emit(pos, dir)


func hit(dmg: float) -> void:
	health -= dmg
	if health <= 0:
		queue_free()


func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func _on_attack_area_body_entered(_body: Node2D) -> void:
	player_nearby = true

func _on_attack_area_body_exited(_body: Node2D) -> void:
	player_nearby = false
