extends Node2D


func _on_exit_zone_lvl_1_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/lvl2.tscn")
