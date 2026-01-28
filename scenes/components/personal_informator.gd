extends Component

var pmp_conversations: Dictionary[String, Array]

var desktop_interface_scene: PackedScene = preload("res://scenes/interfaces/desktop_interface.tscn")

func process_message(paragraphs: PackedStringArray):
	var protocol: String = paragraphs[0].split(":")[1]
	if protocol == "PMP":
		var body: String
		var source_label: String
		for paragraph in paragraphs:
			if paragraph.begins_with("BODY:"):
				body = paragraph.split(":")[1]
			elif paragraph.begins_with("SENDER:"):
				source_label = paragraph.split(":")[1]
		register_pmp_message(source_label, body, source_label)

func register_pmp_message(conversation_partner: String, message: String, speaker: String):
	if pmp_conversations.has(conversation_partner):
		pmp_conversations[conversation_partner].append({speaker: message})
	else:
		pmp_conversations[conversation_partner] = [{speaker: message}]
