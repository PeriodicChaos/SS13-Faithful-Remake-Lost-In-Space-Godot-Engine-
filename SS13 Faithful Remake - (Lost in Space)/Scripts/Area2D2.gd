extends Area2D
signal InTheMiddle(Vaule)

func _ready():
	connect("body_entered", self, "_on_body_enter")
	connect("body_exited", self, "_on_body_exited")

func _on_body_exited(body):
	if body.is_in_group("player"):
		emit_signal("InTheMiddle", false)
		print("1")

func _on_body_enter(body):
	if body.is_in_group("player"):
		emit_signal("InTheMiddle", true)
		print("2")
