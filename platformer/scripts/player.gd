extends CharacterBody2D

@export var speed = 100
@export var gravity = 300
@export var jump_height = -200
@export var acceleration = 10
var isTurnedRight: bool = true

func _physics_process(delta):
	velocity.y += gravity * delta
	
	horizontal_movement()
	move_and_slide()
	player_animations()

func horizontal_movement ():
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = horizontal_input * speed
	
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
		if Input.is_action_pressed("ui_run"):
			speed = 200
		else:
			speed = 100
	else:
		speed = 0

#animations
func player_animations():	
	#flipping 
	if Input.is_action_pressed("ui_right"):
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed("ui_left"):
		$AnimatedSprite2D.flip_h = true
		
	#idle
	if is_on_floor() and (speed == 0) and !Input.is_action_pressed("ui_up") and !Input.is_action_pressed("ui_down"):
		$AnimatedSprite2D.play("idleR")
		
	#looking up
	if Input.is_action_pressed("ui_up") and is_on_floor():
		$AnimatedSprite2D.play("upR")
		
	#looking down
	if Input.is_action_just_pressed("ui_down") and is_on_floor():
		$AnimatedSprite2D.play("duckR")
		
	#walking
	if (speed <= 100) and is_on_floor():
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
			$AnimatedSprite2D.play("walkR")
				
	#running
	if (speed > 100) and is_on_floor():
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
			$AnimatedSprite2D.play("runR")
			
	#falling
	if (velocity.y > 0) and !is_on_floor():
		$AnimatedSprite2D.play("fall")
			
func _input(event):
	#on jump
	if event.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_height
		$AnimatedSprite2D.play("jump")
