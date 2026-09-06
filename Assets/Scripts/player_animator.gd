extends Node2D

@export var player_controller: PlayerController
@export var ghost_interval := 0.04
@export var ghost_fade_time := 0.25
@export var ghost_color := Color(1.0, 1.0, 1.0, 0.6)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var _current_animation := &""
var _ghost_timer := 0.0


func _physics_process(delta: float) -> void:
	var direction := player_controller.direction
	if direction > 0.0:
		sprite.flip_h = false
	elif direction < 0.0:
		sprite.flip_h = true

	var velocity := player_controller.velocity
	var animation := &"idle"
	if velocity.y < 0.0:
		animation = &"jump"
	elif velocity.y > 0.0:
		animation = &"fall"
	elif velocity.x != 0.0:
		animation = &"move"

	if animation != _current_animation:
		_current_animation = animation
		sprite.play(animation)

	if player_controller.is_dashing:
		_ghost_timer -= delta
		if _ghost_timer <= 0.0:
			_ghost_timer = ghost_interval
			_spawn_ghost()
	else:
		_ghost_timer = 0.0


func _spawn_ghost() -> void:
	var ghost := Sprite2D.new()
	ghost.texture = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	ghost.flip_h = sprite.flip_h
	ghost.offset = sprite.offset
	ghost.modulate = ghost_color

	var container := player_controller.get_parent()
	container.add_child(ghost)
	container.move_child(ghost, player_controller.get_index())
	ghost.global_position = sprite.global_position

	var tween := ghost.create_tween()
	tween.tween_property(ghost, "modulate:a", 0.0, ghost_fade_time)
	tween.tween_callback(ghost.queue_free)
