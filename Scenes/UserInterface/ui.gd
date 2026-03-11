extends CanvasLayer

@onready var health_bar: TextureProgressBar = $HBoxContainer/TextureProgressBar

func _ready() -> void:
	Globals.connect("player_health_change", update_health_text)
	
func update_health_text():
	health_bar.value = Globals.player_health
