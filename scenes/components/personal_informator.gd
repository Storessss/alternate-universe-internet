extends Node2D

@export var label: String
@export var neighbors: Array[Node2D]

var letter_scene: PackedScene = preload("res://scenes/components/letter.tscn")
var message_connections: Dictionary[String, String]

var desktop_interface_scene: PackedScene = preload("res://scenes/interfaces/desktop_interface.tscn")

func _ready() -> void:
	connect_to_neighbors()
	
	send_message("test2", "test_message")

func connect_to_neighbors() -> void:
	for neighbor in neighbors:
		var wire: Line2D = Line2D.new()
		wire.add_point(global_position)
		wire.add_point(neighbor.global_position)
		wire.default_color = Color(
			randf_range(0.0, 1.0),
			randf_range(0.0, 1.0),
			randf_range(0.0, 1.0)
		)
		wire.width = 2.0
		wire.z_index = -5
		get_tree().current_scene.call_deferred("add_child", wire)

func send_message(destination_label: String, message: String) -> void:
	for neighbor in neighbors:
		if neighbor.label == destination_label:
			var direction: Vector2 = (neighbor.global_position - global_position).normalized()
			var time: String = Time.get_datetime_string_from_system()
			for i in range(message.length()):
				var letter: Letter = letter_scene.instantiate()
				letter.character = message[i]
				letter.source_label = label + time
				letter.destination_label = destination_label
				letter.direction = direction
				letter.global_position = global_position
				if i == message.length() - 1:
					letter.finished = true
				get_tree().current_scene.call_deferred("add_child", letter)
				await get_tree().create_timer(GlobalVariables.letter_delay).timeout


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Letter:
		if body.destination_label == label:
			read_message(body.source_label, body.character, body.finished)
			body.queue_free()

func read_message(source_label: String, character: String, finished: bool) -> void:
	if message_connections.has(source_label):
		message_connections[source_label] += character
	else:
		message_connections[source_label] = character
	if finished:
		print(message_connections[source_label])

func _on_texture_button_pressed() -> void:
	var desktop_interface: Window = desktop_interface_scene.instantiate()
	add_child(desktop_interface)
