extends Path2D
class_name MovingPlatform

@export var path_time := 1.0
@export var looping := false
@export var ease_type: Tween.EaseType
@export var transition_type: Tween.TransitionType
@export var path_follow_2d: PathFollow2D


func _ready() -> void:
	_start_tween()


func _start_tween() -> void:
	var return_time := 0.0 if looping else path_time
	var tween := create_tween().set_loops()
	tween.tween_property(path_follow_2d, "progress_ratio", 1.0, path_time).set_ease(ease_type).set_trans(transition_type)
	tween.tween_property(path_follow_2d, "progress_ratio", 0.0, return_time).set_ease(ease_type).set_trans(transition_type)
