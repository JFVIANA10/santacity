extends CharacterBody2D

@onready var animacao_player: AnimatedSprite2D = $animacao_player
const MAX_JUMP = 2
const SPEED = 260.0
const JUMP_VELOCITY = -400.0 
const ACELERACAO = 200
const DESACELERACAO = 450

var JUMP_COUNT = 0
var direcao = 0
var jump_pad_max = -500
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

func _ready() -> void:
	prepara_indle()

func _physics_process(delta: float) -> void:
	match estado_atual:
		EstadoPlayer.indle:
			indle(delta)
		
		EstadoPlayer.walk:
			walk(delta)
			
		EstadoPlayer.fall:
			fall(delta)
			
		EstadoPlayer.jump:
			jump(delta)
		EstadoPlayer.ataque:
			ataque(delta)
			
	move_and_slide()
	
func ativar_gravidade (delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
func mover(delta):
	atualizar_animacao()
	if direction:
		velocity.x = move_toward(velocity.x,direction * SPEED,ACELERACAO * delta)
	else:
		velocity.x = move_toward(velocity.x,0,DESACELERACAO * delta)

func atualizar_animacao():
	direction = Input.get_axis("ui_left", "ui_right")
	if direction < 0:
		animacao_player.flip_h = true
	elif direction > 0:
		animacao_player.flip_h = false
		
func pode_pular():
	if JUMP_COUNT < MAX_JUMP:
		return true
	else:
		return false
		
func walk(delta):
	ativar_gravidade(delta)
	mover(delta)
	if velocity.x == 0:
		prepara_indle()
		return
		
	if Input.is_action_just_pressed("pulo"):
		prepara_jump()
		return
		
	if not is_on_floor():
		JUMP_COUNT += 1
		prepara_fall()
		return
	
	if Input.is_action_just_pressed("ataque"):
		prepara_ataque()
		return
		
func jump(delta):
	ativar_gravidade(delta)
	mover(delta)
	
	if Input.is_action_just_pressed("pulo") && pode_pular():
		prepara_jump()
		return
		
	if velocity.y > 0:
		prepara_fall()
		return
		
func fall(delta):
	ativar_gravidade(delta)
	mover(delta)
	if Input.is_action_just_pressed("pulo") and pode_pular():
		prepara_jump()
		return
		
	if is_on_floor():
		JUMP_COUNT = 0
		if velocity.x == 0:
			prepara_indle()
		else:
			prepara_walk()
		return
		
func indle(delta):
	ativar_gravidade(delta)
	mover(delta)
	
	if velocity.x != 0 :
		prepara_walk()
		return
		
	if Input.is_action_just_pressed("pulo"):
		prepara_jump()
		return
	
	if Input.is_action_just_pressed("ataque"):
		prepara_ataque()
		return

func ataque(delta):
	ativar_gravidade(delta)
	mover(delta)
	
	if Input.is_action_just_pressed("ataque"):
		prepara_ataque()
		return
		
	if Input.is_action_just_released("ataque"):
		prepara_indle()
		return

func prepara_jump():
	estado_atual = EstadoPlayer.jump
	animacao_player.play("jump")
	velocity.y = JUMP_VELOCITY
	JUMP_COUNT += 1

func prepara_walk():
	estado_atual = EstadoPlayer.walk
	animacao_player.play("walk")
	
func prepara_indle():
	estado_atual = EstadoPlayer.indle
	animacao_player.play("indle")

func prepara_fall():
	estado_atual = EstadoPlayer.fall
	animacao_player.play("fall")

func prepara_ataque():
	estado_atual = EstadoPlayer.ataque
	animacao_player.play("ataque")
