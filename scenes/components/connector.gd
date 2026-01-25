extends Component

func process_message(paragraphs: PackedStringArray, conversation_id: String):
	if paragraphs[0] == "LP":
		print(paragraphs[2])
		var nested_paragraphs: PackedStringArray = paragraphs[2].split("/")
		var next_door_neighbor: Component = get_neighbor_by_label(nested_paragraphs[1])
		if next_door_neighbor:
			send_message(nested_paragraphs[0], nested_paragraphs[1], nested_paragraphs[2], nested_paragraphs[3])
		else:
			var connectors: Array[Component] = get_neighboring_connectors()
			for connector in connectors:
				send_message(paragraphs[0], paragraphs[1], paragraphs[2], paragraphs[3])
