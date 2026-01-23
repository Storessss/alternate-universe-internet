extends Window

var pmp_interface_scene: PackedScene = preload("res://scenes/interfaces/pmp_interface.tscn")

func _on_close_requested() -> void:
	hide()


func _on_pmp_pressed() -> void:
	var pmp_interface = pmp_interface_scene.instantiate()
	add_child(pmp_interface)
