extends Window

var pmp_interface_scene: PackedScene = preload("res://scenes/interfaces/pmp_interface.tscn")

func _ready() -> void:
	title = get_parent().label

func _on_close_requested() -> void:
	hide()
	for child in get_children():
		if child is Window:
			child.hide()

func _on_pmp_pressed() -> void:
	var pmp_interface = pmp_interface_scene.instantiate()
	add_child(pmp_interface)
