extends Control

var speaker: String
var message: String

func _ready() -> void:
	$Speaker.text = speaker
	$Message.text = message
