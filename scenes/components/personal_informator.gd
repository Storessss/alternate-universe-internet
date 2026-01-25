extends Component

var pmp_conversations: Dictionary[String, Array]

var desktop_interface_scene: PackedScene = preload("res://scenes/interfaces/desktop_interface.tscn")

func process_message(paragraphs: PackedStringArray, conversation_id: String):
	if paragraphs[0] == "PMP":
		register_pmp_message(paragraphs[3], paragraphs[2], paragraphs[3])

func register_pmp_message(conversation_partner: String, message: String, speaker: String):
	if pmp_conversations.has(conversation_partner):
		pmp_conversations[conversation_partner].append({speaker: message})
	else:
		pmp_conversations[conversation_partner] = [{speaker: message}]

func _on_interface_pressed() -> void:
	var desktop_interface: Window = desktop_interface_scene.instantiate()
	add_child(desktop_interface)
