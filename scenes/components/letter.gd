extends CharacterBody2D

class_name Letter

var character: String
var source_label: String
var destination_label: String
var direction: Vector2

var finished: bool

func _process(_delta: float) -> void:
	velocity = direction * GlobalVariables.letter_speed
	move_and_slide()
