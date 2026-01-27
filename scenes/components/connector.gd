extends Component

var already_delivered_messages: Array[String]

func process_message(paragraphs: PackedStringArray):
	var protocol: String = paragraphs[0].split(":")[1]
	if protocol == "PMP":
		var destination_label: String
		var body: String
		var source_label: String
		var conversation_id: String
		var exclude: String
		for paragraph in paragraphs:
			if paragraph.begins_with("RECIPIENT:"):
				destination_label = paragraph.split(":")[1]
			elif paragraph.begins_with("BODY:"):
				body = paragraph.split(":")[1]
			elif paragraph.begins_with("SENDER:"):
				source_label = paragraph.split(":")[1]
			elif paragraph.begins_with("CONVERSATION_ID:"):
				conversation_id = paragraph.split(":", true, 1)[1]
			elif paragraph.begins_with("EXCLUDE:"):
				exclude = paragraph.split(":")[1]
		if conversation_id not in already_delivered_messages:
			already_delivered_messages.append(conversation_id)
			var message: String = "\n".join(paragraphs)
			if not await send_message("PMP", destination_label, message, label):
				var excluded_labels: PackedStringArray = exclude.split("|")
				var new_exclude: String = exclude
				var connectors: Array[Component] = get_neighboring_connectors()
				if label not in excluded_labels:
					new_exclude += label + "|"
				for connector in connectors:
					if connector.label not in excluded_labels:
						new_exclude += connector.label + "|"
				message = message.replace("EXCLUDE:" + exclude, "EXCLUDE:" + new_exclude)
				for connector in connectors:
					if connector.label not in exclude:
						send_message("PMP", connector.label, message, label)

func _on_component_pressed() -> void:
	GlobalVariables.component_pressed.emit(self)
