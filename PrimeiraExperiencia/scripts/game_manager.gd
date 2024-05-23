extends Node

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				spawn_object()
				print(event)
	pass
	
func spawn_object() -> void:
	pass
