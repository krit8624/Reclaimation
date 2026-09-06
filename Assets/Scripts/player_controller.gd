extends CharacterBody2D
class_name PlayerController

signal damaged(amount: int)

const ONE_WAY_GROUND_LAYER := 10
const SPEED_MULTIPLIER := 30.0
const JUMP_MULTIPLIER := -30.0

@export var speed := 5.0
@export var jump_power := 10.0
@export var dash_speed := 350.0
@export var dash_duration := 0.15
@export var dash_cooldown := 0.4
@export var max_health := 3

var direction := 0.0
var is_dashing := false
var health := 3

var _facing := 1.0
var _dash_direction := 0.0
var _dash_timer := 0.0
var _dash_cooldown_timer := 0.0


func _ready() -> void:
	health = max_health


func take_damage(amount: int) -> void:
	health = maxi(health - amount, 0)
	damaged.emit(amount)


func _physics_process(delta: float) -> void:
	_dash_cooldown_timer = maxf(_dash_cooldown_timer - delta, 0.0)

	if Input.is_action_just_pressed("dash") and _dash_cooldown_timer <= 0.0:
		_start_dash()

	if is_dashing:
		_dash_timer -= delta
		if _dash_timer <= 0.0:
			is_dashing = false
		else:
			velocity = Vector2(_dash_direction * dash_speed, 0.0)
			direction = _dash_direction
			move_and_slide()
			return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_power * JUMP_MULTIPLIER

	direction = Input.get_axis("move_left", "move_right")
	var max_speed := speed * SPEED_MULTIPLIER
	if direction:
		_facing = signf(direction)
		velocity.x = direction * max_speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, max_speed)

	set_collision_mask_value(ONE_WAY_GROUND_LAYER, not Input.is_action_pressed("move_down"))

	move_and_slide()


func _start_dash() -> void:
	_dash_direction = direction if direction else _facing
	_dash_timer = dash_duration
	_dash_cooldown_timer = dash_duration + dash_cooldown
	is_dashing = true
