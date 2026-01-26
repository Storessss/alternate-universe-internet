extends Component

var already_delivered_messages: Array[String]

func process_message(paragraphs: PackedStringArray):
	if paragraphs[0] == "LP":
		if paragraphs[2] not in already_delivered_messages:
			already_delivered_messages.append(paragraphs[2])
			var ps_paragraphs: PackedStringArray = paragraphs[4].split("/", true, 4)
			var next_door_neighbor: Component = get_neighbor_by_label(ps_paragraphs[1])
			if next_door_neighbor:
				send_message(ps_paragraphs[0], ps_paragraphs[1], ps_paragraphs[2], ps_paragraphs[3])
			else:
				var connectors: Array[Component] = get_neighboring_connectors()
				for connector in connectors:
					send_message("LP", connector.label, paragraphs[2], label, paragraphs[4])
