extends CharacterBody2D

@onready var animacao: AnimatedSprite2D = $animacao_player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction := Input.get_axis("ui_left","ui_right")
	if direction> 0:
		animacao.play("walk")
		animacao.flip_h=false
		velocity.x = direction * SPEED
	elif direction< 0:
		animacao.play("walk")
		animacao.flip_h=true
		velocity.x = direction * SPEED
	else:
		animacao.play("indle")
		velocity.x=move_toward(velocity.x,0, SPEED)
		
	move_and_slide()
	
