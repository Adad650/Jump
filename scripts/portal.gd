extends Node2D

@onready var exit_point: Marker2D = $ExitPoint
@export var cooldown := 0.2
var _can_teleport := true

func _on_area_2d_body_entered(body: Node) -> void:
	if not _can_teleport:
		return
	if body is CharacterBody2D:
		_can_teleport = false
		body.global_position = exit_point.global_position
		await get_tree().create_timer(cooldown).timeout
		_can_teleport = true
