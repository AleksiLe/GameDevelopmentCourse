extends Area2D

@export var speed: int = 1000
@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D
var direction: Vector2 = Vector2.UP

func _ready() -> void:
	$SelfDestructTimer.start()
	animation_sprite.play("default")
	

func _process(delta):
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:

	#if body.has_method("hit"):
	if "hit" in body:
		body.hit(Globals.player_dmg)
	queue_free()

func _on_self_destruct_timer_timeout() -> void:
	queue_free()
