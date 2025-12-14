extends Area2D

var coins = 0

func _on_body_entered(body):
	print(1)
	queue_free()
