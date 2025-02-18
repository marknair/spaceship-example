extends Area2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	var tween = create_tween()
	var sprite_2d = get_node("Sprite2D")
	var target_position = Vector2(300, 400)
	var animation_duration = 2.0
	
	tween.tween_property(sprite_2d, "position", target_position, animation_duration)
	tween.tween_property(sprite_2d, "scale", Vector2(2, 2), 1.0)
	
func _on_area_entered(area_that_entered: Area2D) -> void: 
	queue_free()
	
