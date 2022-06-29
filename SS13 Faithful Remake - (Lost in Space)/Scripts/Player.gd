extends KinematicBody2D

onready var animationPlayer = $AnimationPlayer
onready var tween = $Tween

onready var ray = $RayCast2D
var grid_size = 32
var Pull = 'ui_e'

puppet var puppet_position = Vector2(0, 0) setget puppet_position_set

var inputs = {
	'ui_up': Vector2.UP,
	'ui_down': Vector2.DOWN,
	'ui_left': Vector2.LEFT,
	'ui_right': Vector2.RIGHT
}

var movement_queue : Vector2
var movement_speed : float = 0.65
var is_moving      : bool = false

func _process(delta: float) -> void:
	if is_network_master():
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

func puppet_position_set(new_value) -> void:
	puppet_position = new_value
	
	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
	tween.start()

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action(dir):
			movement_input(dir)
			
func _physics_process(delta):
	if(movement_queue != position and is_moving): move()

func move():
	position = lerp(position, movement_queue, movement_speed)
	if(movement_queue.is_equal_approx(position)): is_moving = false
				
func movement_input(dir):
	var vector_pos = inputs[dir] * grid_size
	ray.cast_to = vector_pos
	ray.force_raycast_update()
	if ray.is_colliding() == false and is_moving == false:
		is_moving = true
		movement_queue = vector_pos + position
	else:
		var collider = ray.get_collider()
		if(collider == null): return
		if collider.is_in_group('Moveable'):
			if collider.move(dir):
				position += vector_pos 

func MouseMovement(dir):
	InputEventMouseButton.position()


func _on_Network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position)
