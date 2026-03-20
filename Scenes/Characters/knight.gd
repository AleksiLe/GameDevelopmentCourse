extends CharacterBody2D

var phase3: bool = false
var phase2: bool = false
var phase1: bool = true
var can_attack: bool = true
var spawn_pos: Vector2
const pixels_away: int = 30
@export var health: float = 1000
@export var speed: int = 300

signal knight_projectile(pos, dir)
signal phase1_stop()
signal phase2_stop()
signal phase3_stop()

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
	if can_attack:
		shoot_phase1(direction_to_player)
		
func phaseTwoProcess():
		if can_attack:
			shoot_phase2()

func phaseThreeProcess():
		var direction_to_player = Globals.player_pos - global_position
		velocity = direction_to_player.normalized() * speed
		if can_attack:
			shoot_phase1(direction_to_player) # change to phase 3 shooting later
			
		move_and_slide()
	
func shoot_phase1(direction_to_player: Vector2) -> void:
	var pos: Vector2 = global_position + direction_to_player.normalized() * pixels_away
	var dir: Vector2 = (Globals.player_pos - global_position).normalized()
	var spread_angle := deg_to_rad(42) # tweak for tighter/wider spread
	can_attack = false
	$AttackCooldown.start()
	knight_projectile.emit(pos, dir)
	knight_projectile.emit(pos, dir.rotated(spread_angle))
	knight_projectile.emit(pos, dir.rotated(-spread_angle))
	
@export var bullet_count: int = 24
@export var bullet_speed: float = 400
@export var pattern_rotation_speed: float = 0.5
@export var gap_size: int = 4  # number of missing bullets
var pattern_angle := 0.0

func shoot_phase2() -> void:
	can_attack = false
	$AttackCooldown.start()
	var step = TAU / bullet_count
	
	for i in bullet_count:
		var angle = pattern_angle + step * i
		var dir = Vector2(cos(angle), sin(angle))
		
		var pos: Vector2 = global_position + dir * pixels_away
		knight_projectile.emit(pos, dir)

func hit(dmg: float) -> void:
	health -= dmg
	$ProgressBar.value = health
	if health < 650 and phase1:
		phase1 = false
		phase2 = true
		phase1_stop.emit()
	elif health < 200 and phase2:
		phase2 = false
		phase3 = true
		phase2_stop.emit()
	elif health <= 0:
		call_deferred("_die")

func _die() -> void:
	phase3_stop.emit()
	queue_free()
	

func _on_attack_cooldown_timeout() -> void:
	can_attack = true
