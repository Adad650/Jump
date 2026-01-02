extends Node

var score = 0

@onready var label: Label = $Label


func add_point():
	score += 1
	label.text = "Level 1, You have " + str(score) + "/26coins"
