@abstract
extends Node2D

class_name Component

@export var label: String
@export var neighbors: Array[Component]

var letter_scene: PackedScene = preload("res://scenes/components/letter.tscn")

var message_connections: Dictionary[String, String]

func _ready() -> void:
	connect_to_neighbors()

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

func send_message(protocol: String, destination_label: String, message: String, \
source_label: String):
	message = protocol + "/" + destination_label + "/" + message + "/" + source_label
	var time: String = Time.get_time_string_from_system()
	var next_door_neighbor: Component = get_neighbor_by_label(destination_label)
	if next_door_neighbor:
		var direction: Vector2 = (next_door_neighbor.global_position - global_position).normalized()
		for i in range(message.length()):
			var letter: Letter = letter_scene.instantiate()
			letter.character = message[i]
			letter.conversation_id = source_label + "/" + protocol + "/" + time
			letter.direction = direction
			letter.global_position = global_position
			letter.sender = self
			if i == message.length() - 1:
				letter.finished = true
			get_tree().current_scene.call_deferred("add_child", letter)
			await get_tree().create_timer(GlobalVariables.letter_delay).timeout

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Letter:
		if body.sender != self:
			read_message(body.character, body.conversation_id, body.finished)
			body.queue_free()

func read_message(character: String, conversation_id: String, finished: bool) -> void:
	if message_connections.has(conversation_id):
		message_connections[conversation_id] += character
	else:
		message_connections[conversation_id] = character
	if finished:
		process_message(message_connections[conversation_id].split("/"), conversation_id)
		message_connections.erase(conversation_id)
		
@abstract func process_message(paragraphs: PackedStringArray, conversation_id: String)

func get_neighbor_by_label(label: String) -> Component:
	for neighbor in neighbors:
		if neighbor.label == label:
			return neighbor
	return null

func get_neighboring_connectors() -> Array[Component]:
	var connectors: Array[Component]
	for neighbor in neighbors:
		if neighbor.is_in_group("connectors"):
			connectors.append(neighbor)
	return connectors
