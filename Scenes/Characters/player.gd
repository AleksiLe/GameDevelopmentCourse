extends CharacterBody2D

signal wizard_attack
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var can_shoot = true

func _process(_delta: float) -> void:
	# Input
	var direction = Input.get_vector("left", "right", "up", "down")
	# Flip sprite based on horizontal movement
	if direction.x > 0:
		animated_sprite.flip_h = true
	elif direction.x < 0:
		animated_sprite.flip_h = false
	
	#if direction.y > 0:
	#	player_facing = "front"
	#elif direction.y < 0:
	#	player_facing = "back"
	
	# Movement
	velocity = direction * 500
	move_and_slide()
	Globals.player_pos = global_position
	
	# Spell cast
	var player_aim_dir = (get_global_mouse_position() - position).normalized()
	if Input.is_action_pressed("primary_action") and can_shoot == true:
		print("pew")
		animated_sprite.play("front_shoot")
		#var laser_markers = $LaserStartPositions.get_children()
		#var selected_laser = laser_markers[randi() % laser_markers.size()]
		can_shoot = false
		$Timer.start()
		#$GPUParticles2D.emitting = true
		wizard_attack.emit(Globals.player_pos, player_aim_dir)


func hit(dmg: float) -> void:
	Globals.player_health -= dmg
	if Globals.player_health <= 0:
		call_deferred("restart")

func restart() -> void:
	Globals.player_health = 100
	get_tree().reload_current_scene()

func _on_timer_timeout() -> void:
	can_shoot = true
