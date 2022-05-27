extends Area2D

onready var ray = $RayCast2D

const PLAYERNAME = "Player"
onready var animationPlayer = $AnimationPlayer
onready var  door = get_node("..")

func _ready():
	connect("body_entered", self, "_on_body_enter")
	connect("process", self, "_process")
	
	
func _process(delta):

	if Input.is_action_just_pressed("ui_e"):
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if (body.get_name() == PLAYERNAME):
				if (animationPlayer.get_current_animation() == "Open"):
					animationPlayer.play("Close")
					var collisionShape = door.get_node("StaticBody2D/CollisionShape2D")
					collisionShape.disabled  = false
				else:
					animationPlayer.play("Open")
					var collisionShape = door.get_node("StaticBody2D/CollisionShape2D")
					collisionShape.disabled  = true

func _on_body_enter(body):
	print(body.get_name() + " entered the area")
