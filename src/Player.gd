extends KinematicBody2D


const gravity = 30
const speed = 400
const jumpforce = -600
var canjump = 0
var facing = 0

var velocity = Vector2()
export var jumpspeed = 700
var jump = 0
var input
var horizontal_speed = null
const ACCELERATION = 3000



#func get_player_input():
#	if Input.is_action_pressed("move_left"):
#		velocity.x = velocity.x -1 * speed
#	elif Input.is_action_pressed("move_right"):
#		velocity.x = velocity.x + 1 *speed
#	else:
#		velocity.x = 0
#	velocity.x = velocity.clamped(1*speed).x

#Better Input(using action strength
func get_horizontal_input(delta):
	horizontal_speed = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if horizontal_speed != 0.0:
		velocity.x += ACCELERATION * horizontal_speed * delta
		if horizontal_speed>0.01 and velocity.x > speed*horizontal_speed:
			velocity.x = speed*horizontal_speed
		if horizontal_speed < -0.01 and velocity.x < speed*horizontal_speed:
			velocity.x = speed*horizontal_speed
	else:
		velocity.x = velocity.move_toward(Vector2.ZERO, ACCELERATION*2*delta).x
	

func jumping():
	if Input.is_action_just_pressed("move_up") and Input.is_action_pressed("move_right") and canjump==1 and is_on_wall():
		velocity.x = -1.5*speed
		jump_without_player_input()
		#canjump = 0 #this does not work
	elif Input.is_action_just_pressed("move_up") and Input.is_action_pressed("move_left") and canjump==1 and is_on_wall():
		velocity.x = 1.5*speed
		jump_without_player_input()
		#canjump = 0 #this does not work
	elif Input.is_action_pressed("move_up") and canjump == 1: 
		velocity.y = jumpforce
		canjump = 0
	if is_on_wall() and velocity.x != 0:
		velocity.y = 0

func jump_without_player_input():
	velocity.y = jumpforce

func _physics_process(delta):
	get_horizontal_input(delta)
#	get_player_input()
	if is_on_floor():
		canjump = 1
	elif is_on_wall() and velocity.x != 0:
		canjump = 1
	velocity.y = velocity.y + gravity
	if is_on_wall() and velocity.x != 0 and velocity.y == 0:
		velocity.y = 0
	jumping()
	print(velocity.x)
	velocity = move_and_slide(velocity, Vector2.UP)
