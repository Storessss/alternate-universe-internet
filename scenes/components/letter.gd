extends CharacterBody2D

class_name Letter

var character: String
var conversation_id: String
var finished: bool

var direction: Vector2
var sender: Component

func _process(_delta: float) -> void:
	velocity = direction * GlobalVariables.letter_speed
	move_and_slide()
