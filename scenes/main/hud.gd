extends CanvasLayer

enum Tool {
	POINTER,
	WIRE,
	PERSONAL_INFORMATOR,
	CONNECTOR
}
var selected_tool: Tool
var pressed_component: Component
var components_to_wire: Array[Component]

var viewport_mouse_position: Vector2
var canvaslayer_mouse_position: Vector2
var pi_scene: PackedScene = preload("res://scenes/components/personal_informator.tscn")
var connector_scene: PackedScene = preload("res://scenes/components/connector.tscn")

func _ready() -> void:
	GlobalVariables.component_pressed.connect(Callable(self, "_on_component_pressed"))
	
func _process(_delta: float) -> void:
	if selected_tool == Tool.POINTER:
		GlobalVariables.pointer_tool_selected = true
	else:
		GlobalVariables.pointer_tool_selected = false
		
	if selected_tool == Tool.WIRE:
		if components_to_wire.size() < 2:
			if pressed_component:
				components_to_wire.append(pressed_component)
			if components_to_wire.size() == 2:
				if components_to_wire[0] != components_to_wire[1] and \
				components_to_wire[0] not in components_to_wire[1].neighbors and \
				components_to_wire[1] not in components_to_wire[0].neighbors:
					components_to_wire[0].neighbors.append(components_to_wire[1])
					components_to_wire[1].neighbors.append(components_to_wire[0])
					components_to_wire[0].connect_to_neighbors()
					components_to_wire[1].connect_to_neighbors()
				components_to_wire.clear()
	
	viewport_mouse_position = get_viewport().get_mouse_position()
	canvaslayer_mouse_position = get_viewport().get_canvas_transform().affine_inverse() * viewport_mouse_position
	if Input.is_action_just_pressed("click") and \
	viewport_mouse_position.y < $ToolBar/ColorRect.global_position.y:
		if selected_tool == Tool.PERSONAL_INFORMATOR:
			var pi: Component = pi_scene.instantiate()
			pi.global_position = canvaslayer_mouse_position
			pi.label = generate_label(3)
			get_tree().current_scene.add_child(pi)
		elif selected_tool == Tool.CONNECTOR:
			var connector: Component = connector_scene.instantiate()
			connector.global_position = canvaslayer_mouse_position
			connector.label = generate_label(3)
			get_tree().current_scene.add_child(connector)
			
	pressed_component = null

func _on_pointer_pressed() -> void:
	selected_tool = Tool.POINTER
func _on_wire_pressed() -> void:
	selected_tool = Tool.WIRE
func _on_component_pressed(component: Component):
	pressed_component = component
func _on_pi_pressed() -> void:
	selected_tool = Tool.PERSONAL_INFORMATOR
func _on_connector_pressed() -> void:
	selected_tool = Tool.CONNECTOR

func generate_label(length: int) -> String:
	var allowed_characters: String = "abcdefghijklmnopqrstuvwxyz1234567890"
	var label: String
	for i in length:
		label += allowed_characters[randi() % allowed_characters.length()]
	return label
