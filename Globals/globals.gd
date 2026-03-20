extends Node
signal player_health_change

var player_pos: Vector2
var player_health = 100:
	get:
		return player_health
	set(value):
		player_health = value
		player_health_change.emit()
		
var player_dmg: float = 25
