extends CharacterBody2D

@onready var animacao_player: AnimatedSprite2D = $animacao_player
const MAX_JUMP = 2
const SPEED = 300.0
const JUMP_VELOCITY = -400.0 
var JUMP_COUNT = 0

enum EstadoPlayer{
	indle,
	jump,
	walk,
	died,
	ataque,
	squat,
	fall
}
var estado_atual: EstadoPlayer
var direction = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("pulo") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	direction = Input.get_axis("ui_left","ui_right")
	if direction> 0:
		animacao_player.play("walk")
		animacao_player.flip_h=false
		velocity.x = direction * SPEED
	elif direction< 0:
		animacao_player.play("walk")
		animacao_player.flip_h=true
		velocity.x = direction * SPEED
	else:
		animacao_player.play("indle")
		velocity.x=move_toward(velocity.x,0, SPEED)
		
	move_and_slide()
	
func ativar_gravidade (delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func mover(delta):
	if direction:
		velocity.x = move_toward(velocity.x,direction * SPEED,400 * delta)
	else:
		velocity.x = move_toward(velocity.x,0,400 * delta)

func atualizar_animacao():
	direction = Input.get_axis("left", "right")
	if direction < 0:
		animacao_player.flip_h = true
	elif direction > 0:
		animacao_player.flip_h = false
func pode_pular():
	if JUMP_COUNT < MAX_JUMP:
		return true
	else:
		return false
func pular(delta):
	ativar_gravidade(delta)
	mover(delta)
	
	if Input.is_action_just_pressed("jump") && pode_pular():
		return
		
	if velocity.y > 0:
		return
func parado(delta):
	ativar_gravidade(delta)
	mover(delta)
	
	if velocity.x != 0 :
		return
	if Input.is_action_just_pressed("jump"):
		preparar_pulo()
		return
	
func preparar_pulo():
	estado_atual = EstadoPlayer.jump
	animacao_player.play("jump")
	velocity.y = JUMP_VELOCITY
	JUMP_COUNT += 1

func prepara_andando():
	estado_atual = EstadoPlayer.walk
	animacao_player.play("walk")
	
	
