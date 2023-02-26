extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Label.text = "Thanks for playing! Your Score: " + str(Global.score)
