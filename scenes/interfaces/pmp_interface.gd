extends Window

@onready var component: Component = get_parent().get_parent()
var conversation_partner: String

var pmp_message_scene: PackedScene = preload("res://scenes/interfaces/pmp_message.tscn")

func _on_close_requested() -> void:
	hide()

func _on_connect_pressed() -> void:
	conversation_partner = $ConversationPartnerField.text
	load_pmp_conversation()
	
func load_pmp_conversation() -> void:
	for child in $PmpConversation/VBoxContainer.get_children():
		child.queue_free()
	if component.pmp_conversations.has(conversation_partner):
		var conversation: Array = component.pmp_conversations[conversation_partner]
		for record in conversation:
			for speaker in record:
				var pmp_message: Control = pmp_message_scene.instantiate()
				pmp_message.speaker = "[b]" + speaker + ":[/b]"
				pmp_message.message = record[speaker]
				$PmpConversation/VBoxContainer.add_child(pmp_message)
		
func _on_send_pressed() -> void:
	var next_door_neighbor: Component = component.get_neighbor_by_label($ConversationPartnerField.text)
	if next_door_neighbor:
		component.send_message("PMP", $ConversationPartnerField.text, $MessageField.text, component.label)
	else:
		var connectors: Array[Component] = component.get_neighboring_connectors()
		for connector in connectors:
			component.send_message("LP", connector.label, "PMP" + "/" + $ConversationPartnerField.text \
			+ "/" + $MessageField.text + "/" + component.label, component.label)
	component.register_pmp_message($ConversationPartnerField.text, $MessageField.text, component.label)

func _process(_delta: float) -> void:
	if conversation_partner:
		$Send.visible = true
	else:
		$Send.visible = false
		
	position = get_parent().position + get_parent().size / 2 - size / 2
		
	load_pmp_conversation()
