extends Area2D

const MainArea = ("Area2D/CollisionShape2D")
onready var door = get_node("..")
var InArea = false
var InTheMiddle = false

func _ready():
	connect("body_entered", self, "_on_body_enter")
	connect("body_exited", self, "_on_body_exited")

func _on_body_exited(body):
	if body.is_in_group("player"):
		InArea = false
		print("worked out")
	if InArea ==  false:
		yield(get_tree().create_timer(0.5), "timeout")
		$AnimationPlayer.play("Close")
		var collisionShape = door.get_node("StaticBody2D/CollisionShape2D")
		yield(get_tree().create_timer(0.1), "timeout")
		collisionShape.disabled = false

func _on_body_enter(body):
	if body.is_in_group("player"):
		InArea = true
		print("worked in")
	if InArea == true:
		yield(get_tree().create_timer(0.5), "timeout")
		$AnimationPlayer.play("Open")
		var collisionShape = door.get_node("StaticBody2D/CollisionShape2D")
		yield(get_tree().create_timer(0.1), "timeout")
		collisionShape.disabled = true
	if InTheMiddle == true:
		InArea = false
	else:
		InTheMiddle = false
		InArea = false

func _on_Area2D2_InTheMiddle(Vaule):
	if Vaule == true:
		InTheMiddle = true
	else:
		InTheMiddle = false
