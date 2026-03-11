extends Area2D

@export var speed: int = 600
var direction: Vector2 = Vector2.UP

func _ready() -> void:
	$ProjectileTimeout.start()
	
func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
		#if body.has_method("hit"):
	if "hit" in body:
		body.hit(20)
	queue_free()

func _on_projectile_timeout_timeout() -> void:
	queue_free()
