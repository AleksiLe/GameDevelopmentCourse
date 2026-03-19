extends CharacterBody2D

var phase3: bool = false
var phase2: bool = false
var phase1: bool = true
var can_attack: bool = true
var spawn_pos: Vector2
const pixels_away: int = 30
@export var health: float = 1000
@export var speed: int = 200

signal phase1_projectile(pos, dir)
signal phase1_stop()
signal phase2_stop()

func _ready() -> void:
	spawn_pos = global_position
	
func _process(_delta: float) -> void:
	if(phase1):
		phaseOneProcess()
	elif(phase2):
		phaseTwoProcess()
	elif(phase3):
		phaseThreeProcess()
		
func phaseOneProcess():
	var direction_to_player = Globals.player_pos - global_position
	velocity = direction_to_player.normalized() * speed
	if can_attack:
		shoot_phase1(direction_to_player)
		
func phaseTwoProcess():
		var direction_to_player = Globals.player_pos - global_position
		velocity = direction_to_player.normalized() * speed
		if can_attack:
			shoot_phase1(direction_to_player) # change to phase 2 shooting later

func phaseThreeProcess():
		var direction_to_player = Globals.player_pos - global_position
		velocity = direction_to_player.normalized() * speed
		if can_attack:
			shoot_phase1(direction_to_player) # change to phase 3 shooting later
			
		move_and_slide()
	
func shoot_phase1(direction_to_player: Vector2) -> void:
	var pos: Vector2 = global_position + direction_to_player.normalized() * pixels_away
	var dir: Vector2 = (Globals.player_pos - global_position).normalized()
	var spread_angle := deg_to_rad(30) # tweak for tighter/wider spread
	can_attack = false
	$AttackCooldown.start()
	phase1_projectile.emit(pos, dir)
	phase1_projectile.emit(pos, dir.rotated(spread_angle))
	phase1_projectile.emit(pos, dir.rotated(-spread_angle))

func hit(dmg: float) -> void:
	health -= dmg
	if health < 700 and phase1:
		phase1 = false
		phase2 = true
		phase1_stop.emit()
	elif health < 300 and phase2:
		phase2 = false
		phase3 = true
		phase2_stop.emit()
	elif health <= 0:
		call_deferred("_die")

func _die() -> void:
	queue_free()

func _on_attack_cooldown_timeout() -> void:
	can_attack = true
