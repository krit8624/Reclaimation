extends Node2D

@export var player_controller : PlayerController

@onready var sprite = $AnimatedSprite2D 

func _process(delta):

	if player_controller.direction == 1:
		sprite.flip_h = false
	elif player_controller.direction == -1:
		sprite.flip_h = true
		
	if player_controller.velocity.y < 0.0:
		sprite.play("jump")
	elif player_controller.velocity.y > 0.0:
		sprite.play("fall")
	elif abs(player_controller.velocity.x) > 0.0:
		sprite.play("move")
	else:
		sprite.play("idle")
