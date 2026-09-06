extends Area2D
class_name Enemy

signal player_entered(player: PlayerController)

@export var damage := 1
@export var active := true


func _on_body_entered(body: Node2D) -> void:
	if not active or not body is PlayerController:
		return
	player_entered.emit(body)
	if body.has_method("take_damage"):
		body.take_damage(damage)
