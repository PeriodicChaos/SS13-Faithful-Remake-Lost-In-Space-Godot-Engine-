extends KinematicBody2D

onready var animationPlayer = $AnimationPlayer
onready var ray = $RayCast2D
var grid_size = 32
var inputs = {
	'ui_up': Vector2.UP,
	'ui_down': Vector2.DOWN,
	'ui_left': Vector2.LEFT,
	'ui_right': Vector2.RIGHT
}

func _process(delta):
	var left = Input.is_action_just_pressed("ui_right")
	var right = Input.is_action_just_pressed("ui_left")
	var up = Input.is_action_just_pressed("ui_up")
	var down = Input.is_action_just_pressed("ui_down")
	
	if right:
		animationPlayer.play("MovementRight")
	elif left:
		animationPlayer.play("MovementLeft")
	elif up:
		animationPlayer.play("MovementUp")
	elif down:
		animationPlayer.play("MovmentDown")

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	var vector_pos = inputs[dir] * grid_size
	ray.cast_to = vector_pos
	ray.force_raycast_update()
	if !ray.is_colliding():
		position += vector_pos
	else:
		var collider = ray.get_collider()
		if collider.is_in_group('Closet'):
			if collider.move(dir):
				position += vector_pos
